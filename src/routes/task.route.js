const express = require('express');
const TaskRouter = express.Router();
const taskController = require('../controllers/task.controller');

TaskRouter.post('/create', taskController.createTask);
TaskRouter.get('/all', taskController.getTasks);
TaskRouter.put('/update', taskController.updateTask);
TaskRouter.delete('/delete', taskController.deleteTask);
TaskRouter.get('/get/:id', taskController.getTaskById);

module.exports = { TaskRouter };

