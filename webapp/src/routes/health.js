const express = require("express");
const sequelize = require("../db/database");
const  ApiError  = require('../utils/ApiError');
const ApiResponse = require('../utils/ApiResponse');

const router = express.Router();

router.get('/', async(req,res) => {

    if(req.method === 'HEAD' && req.path === '/'){
        res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
        res.setHeader('Pragma', 'no-cache');
        res.setHeader('X-Content-Type-Options', 'nosniff');
        return res.status(405).send();
    }

    const contentLength = req.get('Content-Length');
    const hasPayload = contentLength && parseInt(contentLength) > 0;

    if(hasPayload || Object.keys(req.body).length !== 0){
        res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
        res.setHeader('Pragma', 'no-cache');
        res.setHeader('X-Content-Type-Options', 'nosniff');
        return res.status(400).send();
    }

    if (Object.keys(req.query).length !== 0) {
        res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
        res.setHeader('Pragma', 'no-cache');
        res.setHeader('X-Content-Type-Options', 'nosniff');
        return res.status(400).send();
    }

    try {
        await sequelize.authenticate();
        res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
        res.setHeader('Pragma', 'no-cache');
        res.setHeader('X-Content-Type-Options', 'nosniff');
        return res.status(200).send();
    } catch (error) {
        res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
        res.setHeader('Pragma', 'no-cache');
        res.setHeader('X-Content-Type-Options', 'nosniff');
        return res.status(503).send();
    }
    
});

router.all('/', (req, res) => {
    res.setHeader('Cache-Control', 'no-cache, no-store, must-revalidate');
    res.setHeader('Pragma', 'no-cache');
    res.setHeader('X-Content-Type-Options', 'nosniff');
    return res.status(405).send();
});

module.exports = router;