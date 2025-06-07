const { Task } = require("../models/Task");
const createTask = async (req, res) => {
  try {
    const { title, description } = req.body;
    const userId = req.body.userId; // Assuming userId is set in req.user by authentication middleware --> What is authentication middleware?

    const newTask = new Task({
      userId: userId, 
      title: title,
      description: description || '',});
    return res.status(201).json(newTask);
  } catch (err) {
    return res.status(500).json({ error: 'Failed to create task', details: err.message });
  }
};

const getTasks = async (req, res) => {
  try {
    const userId = req.body.userId;
    const tasks = await Task.find({ userId }).sort({ createdAt: -1 });
    return res.status(200).json(tasks);
  } catch (err) {
    return res.status(500).json({ error: 'Failed to fetch tasks', details: err.message });
  }
};

const updateTask = async (req, res) => {
  try {
    const { taskId, title, description, status } = req.body;

    const updatedTask = await Task.findByIdAndUpdate(
      taskId,
      { title, description, status },
      { new: true }
    );

    if (!updatedTask) return res.status(404).json({ error: 'Task not found' });

    res.status(200).json(updatedTask);
  } catch (err) {
    res.status(500).json({ error: 'Failed to update task', details: err.message });
  }
};

module.exports = {
  createTask,
  getTasks,
  updateTask
}; 
