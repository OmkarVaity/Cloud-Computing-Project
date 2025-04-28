const { DataTypes } = require('sequelize');
const sequelize = require('../db/database');
const { v4: uuidv4 } = require('uuid');
const { use } = require('../routes/UserRoutes');

const Image = sequelize.define('Image', {
    id: {
        type: DataTypes.UUID,
        defaultValue: uuidv4,
        primaryKey: true,
        allowNull: false
    },
    file_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    url:{
        type: DataTypes.STRING,
        allowNull: false
    },
    upload_date: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: false
    },
    user_id: {
        type: DataTypes.UUID,
        allowNull: false
    }
}, {
    timestamps: false,
    tableName: 'images'
});

module.exports = Image;