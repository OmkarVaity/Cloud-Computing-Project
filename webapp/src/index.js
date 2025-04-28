#!/usr/bin/env node
require('dotenv').config();
const sequelize = require('./db/database.js'); 
const app = require('./app');

const PORT = process.env.PORT || 3000;

async function DatabaseConnectionVerify(){
    try{
        await sequelize.authenticate();
        console.log("Connection has been established successfully.");
        await sequelize.sync({ alter: true });
        console.log("Database has been boostrapped");
    }catch(error){
        console.error("Unable to connect to the database initially:", error);
        setTimeout(DatabaseConnectionVerify, 5000);
    }
}

DatabaseConnectionVerify();

app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);  
})

// Handle the following events for the sequelize connection manager in case of disconnection or error
sequelize.authenticate()
    .then(() => {
        console.log("Sequelize Authenticate: Connection is established successfully.");
    })
    .catch((error) => {
        console.error("Sequelize Authenticate: Error during intial connection:", error);
    });

sequelize.connectionManager.getConnection().catch(error => {
    console.error("Connection Manager : Unable to obtain a database connection:", error);
    setTimeout(DatabaseConnectionVerify, 5000);
})