const AWS = require('aws-sdk');
const cloudwatch = new AWS.CloudWatch({ region: process.env.REGION });

const NAMESPACE = 'UserServiceMetrics';
const SERVICE_NAME = 'UserService';

function logMetric(name, unit, value) {
    const params = {
        MetricData: [
            {
                MetricName: name,
                Dimensions: [
                    { Name: 'ServiceName', Value: SERVICE_NAME }
                ],
                Unit: unit,
                Value: value
            }
        ],
        Namespace: NAMESPACE
    };
    cloudwatch.putMetricData(params).promise()
        .catch(error => console.error('Error logging metric:', error));
}

function logApiCall(endpoint) {
    logMetric(`${endpoint} Call Count`, 'Count', 1);
}

function logApiResponseTime(endpoint, timeInMs) {
    logMetric(`${endpoint} Response Time`, 'Milliseconds', timeInMs);
}

function logDbQueryTime(queryName, timeInMs) {
    logMetric(`${queryName} Query Time`, 'Milliseconds', timeInMs);
}

function logS3OperationTime(operation, timeInMs) {
    logMetric(`${operation} S3 Operation Time`, 'Milliseconds', timeInMs);
}

module.exports = {
    logApiCall,
    logApiResponseTime,
    logDbQueryTime,
    logS3OperationTime
};
