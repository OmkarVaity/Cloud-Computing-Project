const bcrypt = require('bcrypt');
const User = require('../models/UserModels');
const ApiError = require('../utils/ApiError');
const ApiResponse = require('../utils/ApiResponse');
const basicAuth = require('basic-auth');
const { logApiCall, logApiResponseTime, logDbQueryTime } = require('../utils/metrics');
const  logger  = require('../utils/logger');
const AWS = require('aws-sdk');
const sns = new AWS.SNS({ region: process.env.REGION || 'us-east-1' });
const { v4: uuidv4 } = require('uuid');
const EmailVerification = require('../models/EmailVerification');


const setHeaders = (res) => {    
    return res.set('Cache-Control', 'no-cache, no-store, must-revalidate')
    .set('Pragma', 'no-cache')
    .set('X-Content-Type-Options', 'nosniff');
};

async function authenticate(req,res,next){
    const credentials = basicAuth(req);
    if(!credentials){
        logger.warn('Authentication credentials not provided');
        return setHeaders(res).status(401).send();    
    }
try{
    const user = await User.findOne({ where: { email: credentials.name } });
    if(!user || !(await bcrypt.compare(credentials.pass, user.password))){
        logger.warn(`Authentication failed for user: ${credentials.name}`);
        return setHeaders(res).status(401).send();
    }

    if(!user.is_verified){
        logger.warn(`User not verified: ${user.email}`);
        return setHeaders(res).status(403).json(new ApiError(403, 'User email not verified. Please verify your email before proceeding.'));
    }

    logger.info(`User authenticated successfully: ${user.email}`);
    req.user = user;
    next();
} catch(error){
    logger.error('Error during authentication', error);
    return setHeaders(res).status(500).json(new ApiError(500, 'Internal Server Error',[error.message]));
}
}

// Create user

async function createUser(req, res) {
    const start = Date.now();
    logApiCall('/v1/user');
    const { email, password, first_name, last_name } = req.body;

    if(!email || !password || !first_name || !last_name) {
        logger.warn('Missing required fields for user creation');
        logApiResponseTime('/v1/user', Date.now() - start);
        return setHeaders(res).status(400).send();
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if(!emailRegex.test(email)){
        logger.warn('Invalid email format');
        logApiResponseTime('/v1/user', Date.now() - start);
        return setHeaders(res).status(400).send();
    }
    
    try {
        const dbStart = Date.now();
        const existingUser = await User.findOne({ where: { email } });
        logDbQueryTime('FindUserByEmail', Date.now() - dbStart);

        if (existingUser) {
            logger.warn(`User creation failed: Email already exists - ${email}`);
            logApiResponseTime('/v1/user', Date.now() - start);
            return setHeaders(res).status(400).send();
        }
    
    const saltRounds = 10;
    const salt = await bcrypt.genSalt(saltRounds);
    
    const hashedPassword = await bcrypt.hash(password, salt);
    const token = uuidv4();
    const expiresAt = new Date(Date.now() + 2 * 60 * 1000);


    const dbCreateStart = Date.now();
    const newUser = await User.create({
        email,
        password: hashedPassword,
        first_name,
        last_name,
        is_verified: false,
        verificationToken: token,
        expiresAt,
    });
    logDbQueryTime('CreateUser', Date.now() - dbCreateStart);

    const verificationLink = `http://demo.vaityorg.me/verify?user=${email}&token=${token}`;

    const snsMessage = {
        action: 'verifyEmail',
        data: {
          //  userId: newUser.id,
            email: newUser.email,
            // firstName: newUser.first_name,
            // createdAt: new Date().toISOString(),
            verificationLink,
        },
    };

    try {
        await sns.publish({
            Message: JSON.stringify(snsMessage),
            TopicArn: process.env.SNS_TOPIC_ARN,
        }).promise();
        logger.info(`SNS message published for user verification: ${newUser.email}`);
    } catch (snsError) {
        logger.error('Error publishing SNS message:', snsError);
        throw new Error('Error publishing SNS message');
    }
    
    logApiResponseTime('/v1/user', Date.now() - start);
    logger.info(`User created successfully: ${newUser.email}`);
    return setHeaders(res).status(201).json({
            id: newUser.id,
            email: newUser.email,
            first_name: newUser.first_name,
            last_name: newUser.last_name,
            account_created: newUser.account_created,
            account_updated: newUser.account_updated,
    });
} catch (error) {
    logger.error('Error during user creation', error);
    logApiResponseTime('/v1/user', Date.now() - start);
    return setHeaders(res).status(500).json(new ApiError(500, 'Internal Server Error', [error.message]));
}
}

// Update user
async function updateUser(req, res) {
    const start = Date.now(); 
    logApiCall('/v1/user/self');

    if (Object.keys(req.query).length !== 0) {
        logger.warn('Update user failed: Query parameters not allowed');
        logApiResponseTime('/v1/user/self', Date.now() - start); 
        return setHeaders(res).status(400).send();
    }

    const contentType = req.headers['content-type'];
    if (!contentType || contentType !== 'application/json' || Object.keys(req.body).length === 0) {
        logger.warn('Update user failed: Invalid content type or empty body');
        logApiResponseTime('/v1/user/self', Date.now() - start); 
        return setHeaders(res).status(400).send();
    }

    const { first_name, last_name, password} = req.body;

    if (!first_name && !last_name && !password) {  
        logger.warn('Update user failed: No fields to update provided');
        logApiResponseTime('/v1/user/self', Date.now() - start); 
        return setHeaders(res).status(400).send();
    }

    const allowedFields = ['first_name', 'last_name', 'password'];
    const invalidFields = Object.keys(req.body)
        .filter(field => !allowedFields.includes(field));
        if (invalidFields.length > 0) {  
            logger.warn(`Update user failed: Invalid fields - ${invalidFields.join(', ')}`); 
            logApiResponseTime('/v1/user/self', Date.now() - start);  
            return setHeaders(res).status(400).send();
        }

    try {
        const user = req.user;

        if (first_name) {
            user.first_name = first_name;
        }

        if (last_name) {
            user.last_name = last_name;
        }

        if(password) {
            user.password = await bcrypt.hash(password, 10);
        }

        const dbStart = Date.now();
        await user.save();
        logDbQueryTime('UpdateUserSave', Date.now() - dbStart);

        logApiResponseTime('/v1/user/self', Date.now() - start); 
        logger.info(`User updated successfully: ${user.email}`);
        return setHeaders(res).status(204).send();
    } catch(error){
        logger.error('Error during user update', error);
        logApiResponseTime('/v1/user/self', Date.now() - start);
        return setHeaders(res).status(500).json(new ApiError(500, 'Internal Server Error', [error.message]));
    }
}

// Get user
async function getUser(req, res) {

    const start = Date.now();
    logApiCall('/v1/user/self');

    if (Object.keys(req.query).length !== 0) {
        logger.warn('Get user failed: Query parameters not allowed');
        logApiResponseTime('/v1/user/self', Date.now() - start);
        return setHeaders(res).status(400).send();
    }

    const contentLength = req.get('Content-Length');
    const hasPayload = contentLength && parseInt(contentLength) > 0;
    if (hasPayload || Object.keys(req.body).length !== 0) {
        logger.warn('Get user failed: Unexpected payload in GET request');
        logApiResponseTime('/v1/user/self', Date.now() - start);
        return setHeaders(res).status(400).send();
    }

    const user = req.user;

    if(!user){
        logger.warn('Get user failed: User not found');
        logApiResponseTime('/v1/user/self', Date.now() - start);
        return setHeaders(res).status(404).send();
    }

    logApiResponseTime('/v1/user/self', Date.now() - start);
    logger.info(`User retrieved successfully: ${user.email}`);
    return setHeaders(res).status(200).json({
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name,
            email: user.email,
            account_created: user.account_created,
            account_updated: user.account_updated,
        
    });
}

module.exports = {
    authenticate,
    createUser,
    updateUser,
    getUser
};
