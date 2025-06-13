const { Task } = require("../models/Task");
const createTask = async (req, res) => {
  try {
    const { title, description, ddate } = req.body;
    const userId = req.body.userId; 
    const existingTask = await Task.findOne({ title: title, userId: userId });
    if(existingTask){
            return res.status(400).json({
                status: 400,
                message: "Task already exists",
                data: [],
                error: "Task already exists"
            });
        }
    const newTask = new Task({
      userId: userId, 
      title: title || 'New Task', 
      description: description || '',
      ddate: ddate || Date.now(),
      });
      await newTask.save();
    return res.status(201).json(newTask);
  } catch (err) {
    return res.status(500).json({ error: 'Failed to create task', details: err.message });
  }
};

const getTasks = async (req, res) => {
  try {
    const userId = req.query.userId;
    const tasks = await Task.find({userId: userId}).sort({ createdAt: 1 });
    return res.status(200).json(tasks);
    
  } catch (err) {
    return res.status(500).json({ error: 'Failed to fetch tasks', details: err.message });
  }
};

const updateTask = async (req, res) => {
  try {
    const { taskId, title, description, status, ddate } = req.body;
    const updatedTask = await Task.findByIdAndUpdate(
      taskId,
      { title, description, status, ddate},
      { new: true }
    );

    if (!updatedTask) return res.status(404).json({ error: 'Task not found' });

    res.status(200).json(updatedTask);
  } catch (err) {
    res.status(500).json({ error: 'Failed to update task', details: err.message });
  }
};

const deleteTask = async (req, res) => {
  try {
    const { taskId } = req.body;
    const deletedTask = await Task.findByIdAndDelete(taskId);

    if (!deletedTask) return res.status(404).json({ error: 'Task not found' });

    res.status(200).json({ message: 'Task deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: 'Failed to delete task', details: err.message });
  }
}

module.exports = {
  createTask,
  getTasks,
  updateTask,
  deleteTask
}; 
