# Go TCP Chat

A simple terminal-based TCP/IP chat application developed in **Go**, designed to demonstrate basic networking principles. The program allows two-way communication between a server and client on the same device (localhost) over a TCP connection. This project is intended for use in the **Fundamentals of Internet of Things** course as a foundational example of TCP communication.

<p align="center"><img src="TCPChat/docs/demo.png"/></p>

## Table of Contents
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [User Manual](#user-manual)
  - [Start the Server](#start-the-server)
  - [Start the Client](#start-the-client)
  - [Usage](#usage)

## Prerequisites

**Go (Golang)**: Make sure [Go is installed and updated](https://golang.org/doc/install) on your device.

## Project Structure

```plaintext
TCPChat/
├── server.go       # Server code for handling client connections and message sending
├── client.go       # Client code for connecting to server and exchanging messages
├── docs/         
|   └── demo.png    # README documentation asset
└── README.md       # Project documentation and usage instructions
```
## User Manual

### Start the Server

In one terminal window, run the following command to start the server:

```bash
go run server.go
```

You should see a message confirming that the server is running on port `9000`.

### Start the Client

In a **new terminal window**, navigate to the same directory and run the client:

```bash
go run client.go
```

Once connected, you’ll see a confirmation message in both the server and client terminals.

### Usage

After both the server and client are running:

1. **Type a message** in the server terminal and press Enter. The message will appear in the client terminal.
2. **Type a message** in the client terminal and press Enter. The message will appear in the server terminal.
3. **Disconnect Handling**: If either the client or server disconnects, the program will display a disconnection message and shut down.
