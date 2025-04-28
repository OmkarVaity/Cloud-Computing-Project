const express = require('express');
const UserController = require('../controllers/UserController');
const checkDatabaseHealth = require('../middleware/checkDatabaseHealth');
const ApiError = require('../utils/ApiError');
const multer = require('multer');   
const upload = multer({ storage: multer.memoryStorage() });
const UserProfileController = require('../controllers/UserProfileController');
const checkVerification = require('../middleware/checkVerification');

const router = express.Router();

const setHeaders = (res) => {    
    return res.set('Cache-Control', 'no-cache, no-store, must-revalidate')
    .set('Pragma', 'no-cache')
    .set('X-Content-Type-Options', 'nosniff');
};

// router.use('/v1/user/self', (req, res, next) => {
//     const allowedMethods = ['GET', 'PUT'];
//     if (!allowedMethods.includes(req.method)) {
//         return setHeaders(res).status(405).send();
//     }
//     next();
// });

const handleHeadRequest = (req, res, next) => {
    if (req.method === 'HEAD') {
        return setHeaders(res).status(405).send();
    }
    next();
};

router.post('/v1/user', checkDatabaseHealth,handleHeadRequest, UserController.createUser);

router.put('/v1/user/self', checkDatabaseHealth, handleHeadRequest,  UserController.authenticate, checkVerification, UserController.updateUser);

router.get('/v1/user/self', checkDatabaseHealth, handleHeadRequest,  UserController.authenticate, checkVerification, UserController.getUser);

// router.all('/v1/user/self', (req, res) => {
//     return setHeaders(res).status(405).send();
// });

router.all('/v1/user', (req, res) => {
    return setHeaders(res).status(405).send();
});

router.post('/v1/user/self/pic', handleHeadRequest, UserController.authenticate, upload.single('profilePic'), UserProfileController.uploadProfilePicture);
router.get('/v1/user/self/pic', handleHeadRequest, UserController.authenticate, UserProfileController.getProfilePicture);
router.delete('/v1/user/self/pic', handleHeadRequest, UserController.authenticate, UserProfileController.deleteProfilePicture);

router.all('/v1/user/self/pic', (req, res) => {
    return setHeaders(res).status(405).send();
});

module.exports = router;
