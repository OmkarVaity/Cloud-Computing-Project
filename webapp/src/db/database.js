const { Sequelize } = require('sequelize');
require('dotenv').config();

const sequelize = new Sequelize
(process.env.DB_NAME, process.env.DB_USER, process.env.DB_PASSWORD, 
    { 
        host: process.env.DB_HOST, 
        port: process.env.DB_PORT,
        dialect: 'postgres',
        dialectOptions: {
            ssl: {
                require: true, // This will force SSL for the connection
                rejectUnauthorized: false, // For testing, you can set this to true in production
            }
        }
    }
);

module.exports = sequelize;