const express = require("express");
const http = require("http");
const cors = require("cors");
const dotenv = require("dotenv");
const helmet = require("helmet");
const compression = require("compression");
const morgan = require("morgan");
const { Server } = require("socket.io");
const { setupWebSockets } = require("./utils/websocket"); // WebSocket Handler
const authRoutes = require("./routes/authRoutes");
const { readdirSync } = require("fs");

dotenv.config();

const app = express();
const server = http.createServer(app); // Create HTTP server
const io = new Server(server, {
    cors: {
        origin: "*",
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
app.use("/api/auth", authRoutes);
// Load Other Routes (if needed)
readdirSync("./routes").forEach((file) => {
    if (file !== "authRoutes.js") {
        app.use("/api/v1", require(`./routes/${file}`));
    }
});

// Setup WebSockets
setupWebSockets(io);
console.log("WebSocket Server is Initialized");

// Debugging: Ensure WebSockets are receiving connections
io.on("connection", (socket) => {
    console.log(`Client Connected: ${socket.id}`);
});

// Start Server
server.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
