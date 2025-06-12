const { default: mongoose, mongo } = require("mongoose");
const formatDate = () => {
  const now = new Date();
  const dd = String(now.getDate()).padStart(2, '0');
  const mm = String(now.getMonth() + 1).padStart(2, '0');
  const yyyy = now.getFullYear();
  return `${dd}-${mm}-${yyyy}`;
};
const taskSchema = new mongoose.Schema({
    userId: {
        type: String,
        required: true,
        unique: true,
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
        type: String, 
        default: formatDate
    },
    ddate: {
        type: String,
        default: formatDate
    }
})

const Task = mongoose.model("Task", taskSchema);
module.exports = {Task};