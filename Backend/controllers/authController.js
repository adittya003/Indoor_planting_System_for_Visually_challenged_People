const jwt = require("jsonwebtoken");
const axios = require("axios");
require("dotenv").config();

const SECRET_KEY = process.env.JWT_SECRET;
const base_url = "https://blynk.cloud/external/api/get?token=";

const loginBlynkToken = async (req, res) => {
    const { blynkToken } = req.body;

    if (!blynkToken) {
        return res.status(400).json({ error: "Blynk Token is required" });
    }

    try {
        const url = `${base_url}${blynkToken}&V1`;
        const response = await axios.get(url);

        if (response.status === 200 && response.data !== undefined) {
            // Generate JWT Token
            const token = jwt.sign({ blynkToken }, SECRET_KEY, { expiresIn: "24h" });
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
            if (err.name === "TokenExpiredError") {
                return res.status(401).json({ error: "Token expired, please login again" });
            }
            return res.status(401).json({ error: "Unauthorized" });
        }
        
        req.user = decoded; // Store user info (including Blynk token) in req.user
        next();
    });
};




module.exports = { loginBlynkToken, verify_token };
