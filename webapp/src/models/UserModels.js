const { DataTypes } = require('sequelize');
const sequelize = require('../db/database');
const { v4: uuidv4 } = require('uuid');

const User = sequelize.define('User', {
    id: {
        type: DataTypes.UUID,
        defaultValue: uuidv4,
        primaryKey: true,
        allowNull: false
    },
    first_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    last_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    password: {
        type: DataTypes.STRING,
        allowNull: false
    },
    email: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        validate: {
            isEmail: true
        }
    }, 
    account_created: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: false
    },
    account_updated: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: false
    },
    is_verified: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        allowNull: false
    },
    verificationToken: {
        type: DataTypes.STRING, // For storing the email verification token
        allowNull: true,
    },
    expiresAt: {
        type: DataTypes.DATE, // Expiration time for the token
        allowNull: true,
    },
}, {
    hooks: {
        beforeCreate: (user) => {
            user.account_updated = user.account_created;
        },
        beforeUpdate: (user) => {
            user.account_updated = new Date();
        }
    },
    timestamps: false,
    tableName: 'users'
});

module.exports = User;