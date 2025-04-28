const { v4: uuidv4 } = require('uuid');
const AWS = require('aws-sdk');
//const s3 = new AWS.S3({region: "us-east-1"});
const BUCKET_NAME = process.env.S3_BUCKET_NAME;
const { logApiCall, logApiResponseTime, logDbQueryTime, logS3OperationTime } = require('../utils/metrics');
const Image = require('../models/Image');
const logger = require('../utils/logger');

const s3 = new AWS.S3({
    region: process.env.REGION || 'us-east-1',
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
});

const setHeaders = (res) => {    
    return res.set('Cache-Control', 'no-cache, no-store, must-revalidate')
    .set('Pragma', 'no-cache')
    .set('X-Content-Type-Options', 'nosniff');
};

async function uploadProfilePicture(req, res) {
    const start = Date.now();
    logApiCall('/v1/user/self/pic');

    const user = req.user;
    const file = req.file;

    if(!file){
        logger.warn('File upload failed: No file provided');
        logApiResponseTime('/v1/user/self/pic', Date.now() - start);
        return res.status(400).json({ error: "File is required" });
    }

    const fileKey = `user-images/${user.id}/${file.originalname}`;
    const params = {
        Bucket: BUCKET_NAME,
        Key: fileKey,
        Body: file.buffer,
        ContentType: file.mimetype,
        ACL: 'private'
    };

    try {
        const s3Start = Date.now();
        logger.info(`Attempting to upload to S3 with fileKey: ${fileKey}`);
        const data = await s3.upload(params).promise();
        console.log(data);
        
        logS3OperationTime('UploadProfilePicture', Date.now() - s3Start);
        logger.info('S3 Upload Success:', data);
      

        const dbStart = Date.now();
        const imageData = await Image.create({
            id: uuidv4(),
            file_name: file.originalname,
            url: data.Location,
            upload_date: new Date(),
            user_id: user.id
        });
        logDbQueryTime('ImageCreate', Date.now() - dbStart);

        logApiResponseTime('/v1/user/self/pic', Date.now() - start);
        logger.info(`Profile picture uploaded successfully for user: ${user.email}`);
        return res.status(201).json({
            file_name: imageData.file_name,
            id: imageData.id,
            url: imageData.url,
            upload_date: imageData.upload_date,
            user_id: imageData.user_id
        });
    } catch (error) {
        logger.error('Failed to upload image to S3 or save to database', error);
        logApiResponseTime('/v1/user/self/pic', Date.now() - start);
        return res.status(500).json({ error: "Failed to upload image" });
    }
}

async function getProfilePicture(req,res){
    const start = Date.now();
    logApiCall('/v1/user/self/pic');

    const user = req.user;
    try {
        const dbStart = Date.now();
        const image = await Image.findOne({ where: { user_id: user.id } }); 
        
        logDbQueryTime('FindImage', Date.now() - dbStart);

        if(!image){
            logger.warn(`Profile picture retrieval failed: No image found for user ${user.email}`);
            logApiResponseTime('/v1/user/self/pic', Date.now() - start);
            return res.status(404).json({ error: "Image not found" });

        } 

        logApiResponseTime('/v1/user/self/pic', Date.now() - start);
        logger.info(`Profile picture retrieved successfully for user: ${user.email}`);
        return res.status(200).json({
            file_name: image.file_name,
            id: image.id,
            url: image.url,
            upload_date: image.upload_date,
            user_id: image.user_id
        });
    } catch(error) {
        logger.error('Error retrieving profile picture from database', error);
        logApiResponseTime('/v1/user/self/pic', Date.now() - start);
        return res.status(500).json({ error: "Failed to get image" });
    }
}

async function deleteProfilePicture(req, res) {
    const start = Date.now();
    logApiCall('/v1/user/self/pic');

    const user = req.user;
    try {
        const dbStart = Date.now();
        const image = await Image.findOne({ where: { user_id: user.id } });
        logDbQueryTime('FindImageForDelete', Date.now() - dbStart);

        if(!image) {
            logger.warn(`Delete profile picture failed: No image found for user ${user.email}`);
            logApiResponseTime('/v1/user/self/pic', Date.now() - start);
            return res.status(404).json({ error: "Image not found" });
        }

        const fileKey = image.url.split('.com/')[1];
        const params = { Bucket : BUCKET_NAME, Key: fileKey };

        const s3Start = Date.now();
        logger.info(`Attempting to delete from S3 with fileKey: ${fileKey}`);
        await s3.deleteObject(params).promise();
        logS3OperationTime('DeleteProfilePicture', Date.now() - s3Start);

        const dbDeleteStart = Date.now();
        await image.destroy();
        logDbQueryTime('DeleteImage', Date.now() - dbDeleteStart);
        
        logApiResponseTime('/v1/user/self/pic', Date.now() - start);
        logger.info(`Profile picture deleted successfully for user: ${user.email}`);
        return res.status(204).send();
    } catch (error) {
        logger.error('Failed to delete image from S3 or database', error);
        logApiResponseTime('/v1/user/self/pic', Date.now() - start);
        return res.status(500).json({ error: "Failed to delete image" });
    }
}

module.exports = {
    uploadProfilePicture,
    getProfilePicture,
    deleteProfilePicture
};