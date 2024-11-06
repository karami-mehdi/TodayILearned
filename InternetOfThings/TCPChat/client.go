// TCP Client for a simple terminal-based chat application,
// connecting to a server on the same device.

// Author: Mehdi Karami
// Student Number: 400434784
// Date: November 6, 2024
// Course: Fundamentals of Internet of Things
// Institution: Zand Institute of Higher Education

// Usage:
// 1. Ensure the server is running on localhost at port 9000 (`go run server.go`).
// 2. Run this file in a separate terminal window to start the client.
//    Command: `go run client.go`
// 3. Type messages in each terminal to simulate a chat between client and server.

// Note: This client is configured to connect to a TCP server on the same
//       device (localhost:9000) for demonstration purposes.

package main

import (
    "bufio"
    "fmt"
    "net"
    "os"
)

// ANSI color codes for terminal output
const (
    Reset   = "\033[0m"
    Red     = "\033[31m"
    Cyan    = "\033[36m"
    Magenta = "\033[35m"
    Yellow  = "\033[33m"
)

// main establishes a connection to the server and manages message exchanges
func main() {
    // Connect to the server at localhost on port 9000
    conn, err := net.Dial("tcp", "127.0.0.1:9000")
    if err != nil {
        fmt.Println(Red + "Error connecting to server:" + Reset, err)
        return
    }
    defer conn.Close()
    fmt.Println(Magenta + "Connected to the server!" + Reset)

    // Channel to detect server disconnection
    disconnectChan := make(chan bool)

    // Goroutine to handle incoming server messages
    go func() {
        for {
            // Read incoming message from the server
            message, err := bufio.NewReader(conn).ReadString('\n')
            if err != nil {
                fmt.Println(Yellow + "Server disconnected." + Reset)
                disconnectChan <- true // Signal server disconnection
                return
            }
            fmt.Print(Cyan + "Server: " + Reset + message)
        }
    }()

    // Capture and send messages to the server until they disconnect
    scanner := bufio.NewScanner(os.Stdin)
    for {
        select {
        case <-disconnectChan:
            fmt.Println(Red + "Exiting client due to server disconnect." + Reset)
            return
        default:
            // Check if input from stdin is available
            if scanner.Scan() {
                text := scanner.Text() + "\n" // Append newline for server readability
                _, err := conn.Write([]byte(text))
                if err != nil {
                    fmt.Println(Red + "Error writing to server. Disconnecting." + Reset)
                    return
                }
            }
            // Handle scanner errors
            if err := scanner.Err(); err != nil {
                fmt.Println(Red + "Error reading from input:" + Reset, err)
                return
            }
        }
    }
}
