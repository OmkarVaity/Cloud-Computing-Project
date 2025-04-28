// const { DataTypes } = require('sequelize');
// const sequelize = require('../config/sequelize');

// const EmailTracking = sequelize.define('Email_Tracking', {
//     userId: {
//         type: DataTypes.UUID,
//         allowNull: false,
//         references: {
//             model: 'Users',
//             key: 'id'
//         },
//     },
//     email: {
//         type: DataTypes.STRING,
//         allowNull: false,
//         unique: true,
//     },
//     verificationLink: {
//         type: DataTypes.STRING,
//         allowNull: false,
//     },
//     verificationToken: {
//         type: DataTypes.STRING,
//         allowNull: false,
//         unique: true,
//     },
//     expiresAt: {
//         type: DataTypes.DATE,
//         allowNull: false,
//     },
// });

// module.exports = EmailTracking;