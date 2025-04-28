const checkVerification = (req, res, next) => {
    if(!req.user.is_verified) {
        return res.status(403).json({
            error: "Your account is not verified. Please verify your email to access this resource.",
        });
    }
    next();
};

module.exports = checkVerification;