const express = require("express");
const http = require("http");
const cors = require("cors");
const dotenv = require("dotenv");
const helmet = require("helmet");
const compression = require("compression");
const morgan = require("morgan");
const { Server } = require("socket.io");
const { readdirSync } = require("fs");
const { setupWebSockets } = require("./utils/websocket"); // WebSocket Handler

dotenv.config();

const app = express();
const server = http.createServer(app); // Create HTTP server
const io = new Server(server, {
    cors: {
        origin: "*", // Adjust if needed
        methods: ["GET", "POST"]
    }
});

const PORT = process.env.PORT || 5000; // Ensure PORT is defined

// Middleware
app.use(express.json());
app.use(cors());
app.use(helmet());
app.use(compression());
app.use(morgan("dev"));

// Routes
readdirSync("./routes").map((route) => app.use("/api/v1", require("./routes/" + route)));

// Setup WebSockets
setupWebSockets(io);
console.log("WebSocket Server is Initialized"); // Debug log

// Extra Debugging: Check if WebSockets are actually receiving connections
io.on("connection", (socket) => {
    console.log(`Client Connected: ${socket.id}`);
});

server.listen(PORT, () => {
    console.log(`🚀 Server running on http://localhost:${PORT}`);
});
