const { default: mongoose, mongo } = require("mongoose");
const taskSchema = new mongoose.Schema({
    userId: {
        type: String,
        required: true,
        trim: true
    },
    title: {
        type: String,
        required: true,
        trim: true
    },
    description: {
        type: String,
        default: '',
        trim: true
    },
    status: {
        type: Boolean,
        default: false
    },
    createdAt: {
        type: Date, 
        default: Date.now
    },
    ddate: {
        type: Date,
        default: Date.now
    }
})

const Task = mongoose.model("Task", taskSchema);
module.exports = {Task};