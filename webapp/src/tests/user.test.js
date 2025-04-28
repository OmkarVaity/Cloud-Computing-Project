const request = require('supertest');
const app = require('../app');
const bcrypt = require('bcrypt');
const User = require('../models/UserModels');
const sequelize = require('../db/database');

const username = 'omkar@gmail.com';
const password = 'test123';

describe('User API', () => {
    beforeAll(async() => {
        await sequelize.sync({ force: true });
        await User.create({
            first_name: 'Onkar',
            last_name: 'Patil',
            email: username,
            password: await bcrypt.hash(password, 10),
            is_verified: true,
        });
    });

    afterAll(async() => {
        await User.destroy({ where: { email: username } });
          await sequelize.close();
    });

    // test('Create an account', async() => {
    //     const uniqueEmail = `test${Date.now()}@gmail.com`;
    //     const response = await request(app).post('/v1/user').send({
    //         email: uniqueEmail,
    //         password: 'xyz123',
    //         first_name: 'xyz',
    //         last_name: 'lmn'
    //     });
    //     console.log(response.body);
    //     expect(response.status).toBe(201);
    //     expect(response.body).toHaveProperty('id');
    //     expect(response.body).toHaveProperty('email', uniqueEmail);
    //     expect(response.body).toHaveProperty('first_name', 'xyz');
    //     expect(response.body).toHaveProperty('last_name', 'lmn');
    // });

    test('Get User Details', async() => {
        const response = await request(app).get('/v1/user/self')
            .set('Authorization', `Basic ${Buffer.from(`${username}:${password}`).toString('base64')}`);
        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('email', username);
        expect(response.body).toHaveProperty('first_name', 'Onkar');
        expect(response.body).toHaveProperty('last_name', 'Patil');
    });

    test('Update User Account', async() => {
        const updateResponse = await request(app).put('/v1/user/self')
            .set('Authorization', `Basic ${Buffer.from(`${username}:${password}`).toString('base64')}`)
            .send({
                first_name: 'UpdateNameDone',
            });

    expect(updateResponse.status).toBe(204);

        const getResponse = await request(app).get('/v1/user/self')
            .set('Authorization', `Basic ${Buffer.from(`${username}:${password}`).toString('base64')}`);

        expect(getResponse.status).toBe(200);
        expect(getResponse.body).toHaveProperty('first_name', 'UpdateNameDone');
    });

    test('should return 400 Bad Request on trying to update email', async() => {
        const response = await request(app).put('/v1/user/self')
            .set('Authorization', `Basic ${Buffer.from(`${username}:${password}`).toString('base64')}`)
            .send({
                email: 'newemail@gmail.com'
            });
            expect(response.status).toBe(400);
    });

}) 