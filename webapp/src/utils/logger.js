const AWS = require('aws-sdk');
const winston = require('winston');
const CloudWatchTransport = require('winston-aws-cloudwatch');
const fs = require('fs');
const { format } = require('path');
const { create } = require('domain');
AWS.config.update({ region: 'us-east-1' });


if(!fs.existsSync('logs')) {
  fs.mkdirSync('logs');
}

const logger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    defaultMeta: { service: 'user-service' },
    transports: [
   //     new winston.transports.File({ filename: '/var/log/csye6225_error.log', level: 'error' }),
        new winston.transports.File({ filename: '/var/log/csye6225_stdop.log' }),
        new winston.transports.Console({ format: winston.format.simple() }),
        new CloudWatchTransport({
            logGroupName: 'csye6225-webapp-log-group',
            logStreamName: `csye6225-webapp-log-stream`,
            region: 'us-east-1',
            createLogGroup: true,
            createLogStream: true,
            retentionInDays: 7,
            level: 'info'
        })
    ]
});

module.exports = logger;

