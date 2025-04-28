const express = require('express');
const { verifyEmail } = require('../controllers/PublicController');

const router = express.Router();

router.get('/verify', verifyEmail);

module.exports = router;