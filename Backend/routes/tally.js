const express = require('express');
const crypto = require('crypto');
const catchAsyncErrors = require('../middlewares/catchAsyncErrors');
const { isAuthenticatedUser, authorizeRoles } = require('../middlewares/auth');
const DonorApplication = require('../models/donorApplication');

const router = express.Router();

router.get(
    '/admin/donor-applications',
    isAuthenticatedUser,
    authorizeRoles('Admin'),
    catchAsyncErrors(async (req, res) => {
        const applications = await DonorApplication.find()
            .sort({ submittedAt: -1 })
            .limit(100);
        res.status(200).json({ success: true, applications });
    })
);


router.post('/webhooks/tally', async (req, res) => {
    try {
        const secret = process.env.TALLY_SIGNING_SECRET;

        // Verify configuration and raw request body
        if (!secret) {
    console.error('TALLY_SIGNING_SECRET is missing.');
    return res.sendStatus(500);
}

const received = req.get('Tally-Signature');

if (!received) {
    console.error('Tally-Signature header is missing.');
    return res.sendStatus(401);
}

const expected = crypto
    .createHmac('sha256', secret)
    .update(JSON.stringify(req.body))
    .digest('base64');

       const expectedBuffer = Buffer.from(expected);
const receivedBuffer = Buffer.from(received);

if (
    expectedBuffer.length !== receivedBuffer.length ||
    !crypto.timingSafeEqual(expectedBuffer, receivedBuffer)
) {
    console.error('Invalid Tally webhook signature.');
    return res.sendStatus(401);
}

        const { eventId, eventType, data } = req.body;

        if (eventType !== 'FORM_RESPONSE') {
            return res.sendStatus(200);
        }

        if (!data?.responseId || !data?.fields) {
            return res.status(400).json({
                success: false,
                message: 'Invalid Tally response payload.',
            });
        }

        const answers = data.fields.map((field) => ({
            key: field.key,
            label: field.label,
            type: field.type,
            value: field.value,
        }));

        // Store the submission in DonorApplication
        await DonorApplication.updateOne(
            { responseId: data.responseId },
            {
                $setOnInsert: {
                    responseId: data.responseId,
                    eventId,
                    formId: data.formId,
                    submittedAt: new Date(data.createdAt),
                    answers,
                },
            },
            { upsert: true }
        );

        return res.status(200).json({
            success: true,
            message: 'Tally webhook received successfully.',
        });

    } catch (error) {
        console.error('Tally webhook error:', error);

        return res.status(500).json({
            success: false,
            message: 'Failed to process Tally webhook.',
        });
    }
});

module.exports = router;