// const { DataTypes } = require('sequelize');
// const sequelize = require('../db/database'); 

// const EmailVerification = sequelize.define('EmailVerification', {
//     id: {
//         type: DataTypes.UUID, // Universally Unique Identifier for each record
//         defaultValue: DataTypes.UUIDV4,
//         primaryKey: true,
//     },
//     userId: {
//         type: DataTypes.UUID,
//         allowNull: false,
//         references: {
//             model: 'Users', // Table name of the User model
//             key: 'id',
//         },
//     },
//     verificationToken: {
//         type: DataTypes.STRING,
//         allowNull: false,
//     },
//     expiresAt: {
//         type: DataTypes.DATE,
//         allowNull: false,
//     },
//     createdAt: {
//         type: DataTypes.DATE,
//         defaultValue: DataTypes.NOW,
//     },
//     updatedAt: {
//         type: DataTypes.DATE,
//         defaultValue: DataTypes.NOW,
//     },
// });

// module.exports = EmailVerification;
