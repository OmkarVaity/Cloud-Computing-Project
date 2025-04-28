const request = require('supertest');
const app = require('../app');

describe('Health Check API', () => {
    beforeEach(async() => await new Promise((resolve) => setTimeout(resolve, 2000)));

    test('should return HTTP 200 for GET /healthz and should never fail', async() => {
        const response = await request(app).get('/healthz');
        expect(response.status).toBe(200);
        expect(response.headers['cache-control']).toBe('no-cache, no-store, must-revalidate');
    });

    test('should return HTTP 405 Method not allowed for all other methods except GET', async() => {
        const methods = ['put', 'post', 'delete', 'patch', 'head', 'options'];
        for(const method of methods){
            const response = await request(app)[method]('/healthz');
            expect(response.status).toBe(405);
            expect(response.headers['cache-control']).toBe('no-cache, no-store, must-revalidate');
        }
    });

    test('should return HTTP 400 Bad Request for a request with query params', async() => {
        const response = await request(app).get('/healthz?abc=123');
        expect(response.status).toBe(400);
        expect(response.headers['cache-control']).toBe('no-cache, no-store, must-revalidate');
    });

    test('should have an empty response body for GET /healthz', async() => {
        const response = await request(app).get('/healthz');
        expect(response.status).toBe(200);
        expect(response.headers['cache-control']).toBe('no-cache, no-store, must-revalidate');
        expect(response.body).toEqual({});
    });

    test('should return HTTP 400 for /healthz with non-empty JSON request body', async() => {
        const requestBody = {
            test: "name"
        };
        const response = await request(app).get('/healthz').set('Content-Type', 'application/json').send(requestBody);
        expect(response.status).toBe(400);
        expect(response.headers['cache-control']).toBe('no-cache, no-store, must-revalidate');
    });
})