// const dotenv = require("dotenv");
// dotenv.config();
const axios = require("axios");

const BLYNK_AUTH_TOKEN=process.env.BLYNK_AUTH_TOKEN;
const get_api_base="https://blynk.cloud/external/api/get?token=";
const update_api_base="https://blynk.cloud/external/api/update?token=";

exports.getTemprature = async(req,res) => {
    try {
        const url = `${get_api_base}${BLYNK_AUTH_TOKEN}&V2`;

        const response = await axios.get(url)

        res.status(200).json({
            success:true,
            value: response.data
        });

    } catch(error){
        console.error("Error fetching temperature:", error.message);
        res.status(500).json({
            success:false,
            message:"Failed to fetch temperature data"
        });
    }

};

exports.getHumidity =  async(req,res)=> {
    try {
        const url = `${get_api_base}${BLYNK_AUTH_TOKEN}&V1`;

        const response = await axios.get(url)

        res.status(200).json({
            success:true,
            value: response.data
        });

    } catch(error){
        console.error("Error fetching humidity:", error.message);
        res.status(500).json({
            success:false,
            message:"Failed to fetch humidity data"
        });
    }
    
};

exports.getLDR = async(req,res)=> {
    try {
        const url = `${get_api_base}${BLYNK_AUTH_TOKEN}&V3`;

        const response = await axios.get(url)
        let response1 = ''
        if (response.data == 1){
            response1 = 'Enough Light'
        }else{
            response1 = 'Light not Present'
        }

        res.status(200).json({
            success:true,
            value: response1
        });

    } catch(error){
        console.error("Error fetching LDR:", error.message);
        res.status(500).json({
            success:false,
            message:"Failed to fetch LDR data"
        });
    }

};

exports.getWaterLevel = async (req, res) => {
    try {
        const url = `${get_api_base}${BLYNK_AUTH_TOKEN}&V4`;

        const response = await axios.get(url);
        const percentage = (response.data / 4096) * 100; // Convert to percentage

        res.status(200).json({
            success: true,
            value: percentage.toFixed(2) // Limit to 2 decimal places
        });

    } catch (error) {
        console.error("Error fetching Water Level:", error.message);
        res.status(500).json({
            success: false,
            message: "Failed to fetch Water Level data",
            error: error.message
        });
    }
};


exports.getIR1 = async (req, res) => {
    try {
        const url = `${get_api_base}${BLYNK_AUTH_TOKEN}&V5`;

        const response = await axios.get(url)
        let response1 = ''
        if (response.data == 1){
            response1 = 'Height Reached'
        }else{
            response1 = 'Still Growing'
        }

        res.status(200).json({
            success:true,
            value: response1
        });

    } catch(error){
        console.error("Error fetching IR1:", error.message);
        res.status(500).json({
            success:false,
            message:"Failed to fetch IR1 data"
        });
    }
};

exports.getIR2 = async (req, res) => {
    try {
        const url = `${get_api_base}${BLYNK_AUTH_TOKEN}&V6`;

        const response = await axios.get(url)
        let response1 = ''
        if (response.data == 1){
            response1 = 'Intruder Detected'
        }else{
            response1 = 'No Intruder Detected'
        }

        res.status(200).json({
            success:true,
            value: response1
        });

    } catch(error){
        console.error("Error fetching IR2:", error.message);
        res.status(500).json({
            success:false,
            message:"Failed to fetch IR2 data"
        });
    }
    
};

exports.getSoilMoisture = async (req, res) => {
    try {
        const url = `${get_api_base}${BLYNK_AUTH_TOKEN}&V7`;

        const response = await axios.get(url);
        const percentage = (response.data / 4096) * 100; // Convert to percentage

        res.status(200).json({
            success: true,
            value: percentage.toFixed(2) // Limit to 2 decimal places
        });

    } catch (error) {
        console.error("Error fetching Soil Moisture:", error.message);
        res.status(500).json({
            success: false,
            message: "Failed to fetch Soil Moisture data",
            error: error.message
        });
    }
};

exports.Manual_Water_Pump_switch = async (req,res) => {
    try {
        const url_update_on=`${update_api_base}${BLYNK_AUTH_TOKEN}&V8=1`;
        const url_update_off=`${update_api_base}${BLYNK_AUTH_TOKEN}&V8=0`;
        await axios.get(url_update_on);
        console.log("water pump turned ON");
        setTimeout( async () => {
            await axios.get(url_update_off);
            console.log("water pump turned off");
        }, 5000);
        res.status(200).json({success: true });
        
    } catch (error) {
        console.error("Error controlling water pump:", error.message);
        res.status(500).json({
        success:false,
        message: "Failed to activate water pump", error: error.message });
    }
};