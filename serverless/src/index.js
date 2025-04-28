const { sendVerificationEmail } = require('./emailVerification');

exports.handler = async (event) => {
    try {
        // Log the incoming event for debugging
        console.log('Received event:', JSON.stringify(event, null, 2));

        // Validate the event structure
        const record = event.Records && event.Records[0];
        if (!record || !record.Sns) {
            throw new Error('Invalid SNS message format');
        }

        // Parse the SNS message
        const message = JSON.parse(record.Sns.Message);
        console.log('Parsed message:', JSON.stringify(message, null, 2));

        // Validate the `action` field in the SNS message
        if (!message.action) {
            throw new Error('Missing "action" field in the message');
        }

        // Process actions
        if (message.action === 'verifyEmail') {
            const { email, verificationLink } = message.data;

            if (!email || !verificationLink) {
                throw new Error('Invalid user data for email verification');
            }

         //   const verificationLink = `https://demo.vaityorg.me/verify?token=${token}&userId=${userId}`;

         //   console.log(`Sending email verification for: ${userData.email}`);
         //   await verifyEmail(userData);
            await sendVerificationEmail(email, verificationLink);
            console.log(`Verification email sent to ${email}`);

        // } else if (message.action === 'verifyUser') {
        //     const { id, token } = message.data;

        //     if (!id || !token) {
        //         throw new Error('Invalid verification data');
        //     }

        //     console.log(`Processing user verification for user ID: ${id}`);
        //     await updateUserVerification(id, token);
        //     console.log(`User with id ${id} has been verified successfully`);

        }
         else {
            throw new Error(`Invalid action: ${message.action}`);
        }

    } catch (error) {
        console.error('Error processing SNS event:', error);
        throw new Error('Error processing SNS event');
    }
};