const sequelize = require('../db/database');
const ApiError = require('../utils/ApiError');

const setHeaders = (res) => {    
    return res.set('Cache-Control', 'no-cache, no-store, must-revalidate')
    .set('Pragma', 'no-cache')
    .set('X-Content-Type-Options', 'nosniff');
};

async function checkDatabaseHealth(req, res, next) {
    try {
        await sequelize.authenticate();
        next();
    } catch (error) {
        if (
            error.name === 'SequelizeConnectionError' ||
            error.name === 'SequelizeConnectionRefusedError' ||
            error.name === 'SequelizeHostNotFoundError' ||
            error.name === 'SequelizeHostNotReachableError' ||
            error.name === 'SequelizeConnectionTimedOutError' ||
            error.parent?.code === 'ECONNREFUSED'
        ) {
            return setHeaders(res).status(503).send();
        }

        const apiError = new ApiError(500, 'Internal Server Error', [error.message]);
        return setHeaders(res).status(500).json(apiError);
    }
}

module.exports = checkDatabaseHealth;
