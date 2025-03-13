const express = require("express")
const { loginBlynkToken, verify_token, logout } = require("../controllers/authController");

const router = express.Router();

router.post("/login",loginBlynkToken);
router.post("/logout", logout);
router.get("/protected", verify_token, (req, res) => {
    res.json({ message: "Access granted", user: req.user });
});


module.exports = router;