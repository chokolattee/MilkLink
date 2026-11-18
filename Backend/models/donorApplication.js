
const mongoose = require('mongoose');

const donorApplicationSchema = new mongoose.Schema(
    {
        responseId: {
            type: String,
            required: true,
            unique: true,
        },

        eventId: {
            type: String,
        },

        formId: {
            type: String,
        },

        submittedAt: {
            type: Date,
            default: Date.now,
        },

        // Store Tally answers as objects, not strings
        answers: [
            {
                _id: false,
                key: {
                    type: String,
                },
                label: {
                    type: String,
                },
                type: {
                    type: String,
                },
                value: {
                    type: mongoose.Schema.Types.Mixed,
                },
            },
        ],
    },
    {
        timestamps: true,
    }
);

module.exports = mongoose.model(
    'DonorApplication',
    donorApplicationSchema
);
