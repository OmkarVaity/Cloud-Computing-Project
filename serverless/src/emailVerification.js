require('dotenv').config();
const { v4: uuidv4 } = require('uuid');
const EmailTracking = require('./model/emailTracking');
const sgMail = require('@sendgrid/mail');
const { send } = require('process');
const { SecretsManager } = require('@aws-sdk/client-secrets-manager');
const secretsManager = new SecretsManager({
    region: 'us-east-1'
});


const data = await secretsManager.getSecretValue({ SecretId: process.env.EMAIL_SERVICE_SECRET_ARN });
console.log('Secret data:', data);
const secret = JSON.parse(data.SecretString);
const credentials = secret.sendgrid_api_key;
sgMail.setApiKey(credentials);

// async function verifyEmail(userData) {
//     const { userId, email } = userData;

//     if (!userId || !email) {
//         console.error('Invalid user data:', userData);
//         throw new Error('Invalid user data for email verification');
//     }

//     const token = uuidv4();
//     const verificationLink = `demo.vaityorg.me/verify?token=${token}&userId=${userId}`;
//     const expiresAt = new Date(Date.now() + 2 * 60 * 1000);

//     console.log('Generated token:', token);
//     console.log('Generated verificationLink:', verificationLink);
//     console.log('Tracking email...');


//     await trackEmail(userId, email, verificationLink, token, expiresAt);
//     console.log('Email tracking completed.');

//     console.log('Sending verification email...');
//     await sendVerificationEmail(email, verificationLink);
//     console.log(`Verification email sent to ${email}`);
    
// }

async function sendVerificationEmail(email, verificationLink) {
    const msg = {
        to: email,
        from: `WebApp <no-reply@${process.env.SENDGRID_DOMAIN}>`,
        subject: 'Action Required: Verify your email',
        html:`
            <div style="font-family: Arial, sans-serif; line-height: 1.6; color: #333;">
                <table style="width: 100%; max-width: 600px; margin: auto; border: 1px solid #ddd; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);">
                    <tr>
                        <td>
                            <h2 style="color: #555;">Welcome to WebApp!</h2>
                            <p>
                                Hello
                            </p>
                            <p>
                                Thank you for signing up with WebApp. To complete your registration and get started, please verify your email address by clicking the button below:
                            </p>
                            <div style="text-align: center; margin: 20px 0;">
                                <a href="${verificationLink}" style="background-color: #4CAF50; color: white; text-decoration: none; padding: 10px 20px; border-radius: 5px; font-size: 16px;">Verify My Email</a>
                            </div>
                            <p style="color: #999; font-size: 14px;">
                            This link will expire in 2 minutes. For any issues, contact our support team at <a href="mailto:support@vaityorg.me">support@vaityorg.me</a>.
                            </p>
                        </td>
                    </tr>
                </table>
            </div>                               
            `,
    };

    try{
        console.log('Sending email with SendGrid:', msg);
        await sgMail.send(msg);
        console.log('Email sent successfully.');
    } catch(error){
        console.error('Error sending email:', error);
        throw new Error('Error sending email');
    }
}

// async function trackEmail(userId, email, verificationLink, verificationToken, expiresAt) {
//     try {
//         console.log('Inserting into EmailTracking:', {
//             userId,
//             email,
//             verificationLink,
//             verificationToken,
//             expiresAt,
//         });
//         await EmailTracking.create({
//             userId,
//             email,
//             verificationLink,
//             verificationToken,
//             expiresAt,
//         }); 
//         console.log('Email tracked successfully.');
//     } catch (error) {
//         console.error('Error tracking email:', error);
//         throw new Error('Error tracking email');
//     }
// }

// async function updateUserVerification(userId, token){
//     try{
//         const emailRecord = await EmailTracking.findOne({ where: { userId, verificationToken: token } });

//         if(!emailRecord){
//             throw new Error('Verification token not found');
//         }

//         if(new Date() > emailRecord.expiresAt){
//             throw new Error('Verification token expired');
//         }

//         await User.update({ is_verified: true }, { where: { id: userId } });

//         console.log(`User with id {userId} has been verified successfully`);
        
//     } catch(error) {
//         console.error('Error updating user verification:', error);
//         throw new Error('Error updating user verification');
//     }
// }

module.exports = {
    sendVerificationEmail
};