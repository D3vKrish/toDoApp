const express = require('express');
const TaskRouter = express.Router();
const taskController = require('../controllers/task.controller');

TaskRouter.post('/create', taskController.createTask);
TaskRouter.get('/all', taskController.getTasks);
TaskRouter.put('/update', taskController.updateTask);

module.exports = { TaskRouter };

