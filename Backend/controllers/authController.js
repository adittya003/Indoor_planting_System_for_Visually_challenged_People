const jwt = require("jsonwebtoken");
const axios = require("axios");
require("dotenv").config();

const SECRET_KEY = process.env.JWT_SECRET;
const base_url = "https://blynk.cloud/external/api/get?token=";

// Temporary storage for active user sessions 
let activeTokens = {};

const loginBlynkToken = async (req, res) => {
    const { blynkToken } = req.body;

    if (!blynkToken) {
        return res.status(400).json({ error: "Blynk Token is required" });
    }

    // Check if the user is already logged in
    if (activeTokens[blynkToken]) {
        return res.json({ message: "Already logged in", token: activeTokens[blynkToken] });
    }

    try {
        const url = `${base_url}${blynkToken}&V1`;
        const response = await axios.get(url);

        if (response.status === 200 && response.data !== undefined) {
            // Generate JWT Token (NO EXPIRATION)
            const token = jwt.sign({ blynkToken }, SECRET_KEY);

            // Store active session
            activeTokens[blynkToken] = token;

            return res.json({ message: "Login successful", token });
        }
        return res.status(401).json({ error: "Invalid Blynk Token" });
    } catch (error) {
        console.error("Blynk API Error:", error.response ? error.response.data : error.message);
        return res.status(500).json({ error: "Failed to verify Blynk token" });
    }
};

const verify_token = (req, res, next) => {
    const authHeader = req.headers["authorization"];

    if (!authHeader || !authHeader.startsWith("Bearer ")) {
        return res.status(403).json({ error: "No token provided or format incorrect" });
    }

    const token = authHeader.split(" ")[1]; // Extract token after "Bearer"

    jwt.verify(token, SECRET_KEY, (err, decoded) => {
        if (err) {
            return res.status(401).json({ error: "Unauthorized" });
        }

        // Check if the token is still active
        if (activeTokens[decoded.blynkToken] !== token) {
            return res.status(401).json({ error: "Session expired, please login again" });
        }

        req.user = decoded; // Store user info (including Blynk token) in req.user
        next();
    });
};

// Logout function (removes the token)
const logout = (req, res) => {
    const token = req.headers["authorization"]?.split(" ")[1];

    if (!token) {
        return res.status(400).json({ error: "No token provided" });
    }

    // Find and remove the token from activeTokens
    for (const [key, value] of Object.entries(activeTokens)) {
        if (value === token) {
            delete activeTokens[key];
            return res.json({ message: "Logout successful" });
        }
    }

    return res.status(401).json({ error: "Invalid or expired token" });
};

module.exports = { loginBlynkToken, verify_token, logout };
