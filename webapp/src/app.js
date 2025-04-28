const express = require("express");
require("dotenv").config();

const healthRoutes = require("./routes/health");
const userRoutes = require("./routes/UserRoutes");
const publicRoutes = require("./routes/PublicRoutes");

const app = express();

app.use(express.json());

app.use('/healthz', healthRoutes);
//app.use('/cicd', healthRoutes);
app.use(publicRoutes);
app.use(userRoutes);  

module.exports = app;