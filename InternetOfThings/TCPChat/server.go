// TCP Server for a simple terminal-based chat application,
// allowing communication with a client on the same device.

// Author: Mehdi Karami
// Student Number: 400434784
// Date: November 6, 2024
// Course: Fundamentals of Internet of Things
// Institution: Zand Institute of Higher Education

// Usage:
// 1. Run this file in a terminal to start the server.
//    Command: `go run server.go`
// 2. Open a new terminal and run the client using `go run client.go`.
// 3. Type messages in each terminal to simulate a chat between client and server.

// Note: This program demonstrates a basic TCP connection using Go and
//       runs entirely on localhost (127.0.0.1:9000) for single-device testing.

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
    Green   = "\033[32m"
    Cyan    = "\033[36m"
    Magenta = "\033[35m"
    Yellow  = "\033[33m"
)

// main initializes the server, listens for a client connection, and manages message exchanges
func main() {
    // Start the server on localhost at port 9000
    ln, err := net.Listen("tcp", "127.0.0.1:9000")
    if err != nil {
        fmt.Println(Red + "Error starting server:" + Reset, err)
        return
    }
    defer ln.Close()
    fmt.Println(Cyan + "Server is running on port 9000..." + Reset)

    // Accept a single client connection
    conn, err := ln.Accept()
    if err != nil {
        fmt.Println(Red + "Error accepting connection:" + Reset, err)
        return
    }
    defer conn.Close()
    fmt.Println(Green + "Client connected!" + Reset)

    // Channel to detect client disconnection
    disconnectChan := make(chan bool)

    // Goroutine to handle incoming client messages
    go func() {
        for {
            // Read incoming message from the client
            message, err := bufio.NewReader(conn).ReadString('\n')
            if err != nil {
                fmt.Println(Yellow + "Client disconnected." + Reset)
                disconnectChan <- true // Signal client disconnection
                return
            }
            fmt.Print(Magenta + "Client: " + Reset + message)
        }
    }()

    // Capture and send messages to the client until they disconnect
    scanner := bufio.NewScanner(os.Stdin)
    for {
        select {
        case <-disconnectChan:
            fmt.Println(Red + "Shutting down server due to client disconnect." + Reset)
            return
        default:
            // Check if input from stdin is available
            if scanner.Scan() {
                text := scanner.Text() + "\n" // Append newline for client readability
                _, err := conn.Write([]byte(text))
                if err != nil {
                    fmt.Println(Red + "Error writing to client. Disconnecting." + Reset)
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
