const User = require('../models/UserModels');
const { Op } = require('sequelize');
const logger = require('../utils/logger');
const ApiError = require('../utils/ApiError');

async function verifyEmail(req, res) {
    const { user, token } = req.query;

    if(!user || !token){
        logger.warn('Verification failed: Missing user or token');
        return res.status(400).send(`
            <h1>Verification Failed</h1>
            <p>Invalid verification link. Please check the link and try again.</p>
        `);
    }

    try{
        const userRecord = await User.findOne({
            where: {
                email: user,
                verificationToken: token,
                expiresAt: {
                    [Op.gt]: new Date()
                },
            },
        });

        if(!userRecord) {
            logger.warn('Verification failed: Invalid or expired token');
            return res.status(400).send(`
                <h1>Verification Failed</h1>
                <p>The verification link is invalid or has expired. Please contact support if you need assistance.</p>
            `);
        }

        userRecord.is_verified = true;
        userRecord.verificationToken = null;
        userRecord.expiresAt = null;
        await userRecord.save();

        logger.info(`User verified successfully: ${userRecord.email}`);
        return res.status(200).send(`
            <h1>Verification Successful</h1>
            <p>Your email has been successfully verified.</p>
        `);
    }catch (error) {
        logger.error('Error during email verification', error);
        return res.status(500).send(`
            <h1>Verification Failed</h1>
            <p>An error occurred while processing your request. Please try again later.</p>
        `);
    }
}

module.exports = { verifyEmail };