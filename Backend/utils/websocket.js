const axios = require("axios");
require("dotenv").config();

const BLYNK_AUTH_TOKEN = process.env.BLYNK_AUTH_TOKEN;
const get_api_base = "https://blynk.cloud/external/api/get?token=";


const fetchIntruderStatus = async () => {
    try {
        const response = await axios.get(`${get_api_base}${BLYNK_AUTH_TOKEN}&V6`);
        return response.data == 1 ? "Intruder Detected" : "No Intruder Detected";
    } catch (error) {
        console.error("Error fetching Intruder Status:", error.message);
        return "Error fetching Intruder Status";
    }
};


const fetchWaterLevel = async () => {
    try {
        const response = await axios.get(`${get_api_base}${BLYNK_AUTH_TOKEN}&V4`);
        return ((response.data / 4096) * 100).toFixed(2);
    } catch (error) {
        console.error("Error fetching Water Level:", error.message);
        return "Error fetching Water Level";
    }
};


const fetchTemperature = async () => {
    try {
        const response = await axios.get(`${get_api_base}${BLYNK_AUTH_TOKEN}&V2`);
        return response.data;
    } catch (error) {
        console.error("Error fetching Temperature:", error.message);
        return "Error fetching Temperature";
    }
};

// WebSocket Setup
function setupWebSockets(io) {
    io.on("connection", (socket) => {
        console.log(`✅ New WebSocket client connected: ${socket.id}`);

        const fetchAndEmitData = async () => {
            console.log("🔄 Fetching data..."); // Debugging log

            try {
                const [intruderStatus, waterLevel, temperature] = await Promise.all([
                    fetchIntruderStatus(),
                    fetchWaterLevel(),
                    fetchTemperature()
                ]);

                 console.log("📡 Data Sent:", { intruderStatus, waterLevel, temperature });

                // Use `io.emit` to send to all clients
                io.emit("sensorData", { intruderStatus, waterLevel, temperature });

            } catch (error) {
                console.error("Error fetching data:", error.message);
            }
        };

        // First fetch after connection
        setTimeout(fetchAndEmitData, 1000);

        // Fetch data every 2 seconds
        const interval = setInterval(fetchAndEmitData, 2000);

        // Handle disconnection
        socket.on("disconnect", () => {
            console.log(`WebSocket client disconnected: ${socket.id}`);
            clearInterval(interval);
        });
    });
}

module.exports = { setupWebSockets };
