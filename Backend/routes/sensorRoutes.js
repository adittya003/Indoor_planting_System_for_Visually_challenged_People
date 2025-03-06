const router = require('express').Router()
const { getTemprature, getHumidity, getLDR, getWaterLevel, getIR1, getIR2, getSoilMoisture, Manual_Water_Pump_switch } = require('../controllers/sensorController');

router.get('/get-Temprature',getTemprature)
    .get('/get-Humidity',getHumidity)
    .get('/get-LDR',getLDR)
    .get('/get-WaterLevel',getWaterLevel)
    .get('/get-IR1',getIR1)
    .get('/get-IR2',getIR2)
    .get('/get-SoilMoisture',getSoilMoisture)
    .post('/waterpump-button',Manual_Water_Pump_switch)

module.exports = router;