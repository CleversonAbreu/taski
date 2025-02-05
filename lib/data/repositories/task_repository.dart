import 'dart:developer';
import 'package:taski/data/errors/task_repository_exception.dart';
import 'package:taski/data/datasources/local/task_database.dart';
import 'package:taski/data/models/task_model.dart';

class TaskRepository {
  TaskDatabase _taskDatabase = TaskDatabase();

  set taskDatabase(TaskDatabase taskDatabase) {
    _taskDatabase = taskDatabase;
  }

  Future<List<TaskModel>> getTasks({int limit = 10, int offset = 0}) async {
    try {
      return await _taskDatabase.getTasks(limit, offset);
    } catch (e, stackTrace) {
      log("Error retrieving tasks", error: e, stackTrace: stackTrace);
      throw TaskRepositoryException("Error retrieving tasks");
    }
  }
 
  Future<List<TaskModel>> getCompletedTasks({int limit = 10, int offset = 0}) async {
    try {
      return await _taskDatabase.getCompletedTasks(limit: limit, offset: offset);
    } catch (e, stackTrace) {
      log("Error retrieving completed tasks", error: e, stackTrace: stackTrace);
      throw TaskRepositoryException("Error retrieving completed tasks");
    }
  }

  Future<void> addTask(TaskModel task) async {
    try {
      await _taskDatabase.insertTask(task);
    } catch (e, stackTrace) {
      log("Error adding task", error: e, stackTrace: stackTrace);
      throw TaskRepositoryException("Error adding task");
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _taskDatabase.updateTask(task);
    } catch (e, stackTrace) {
      log("Error updating task", error: e, stackTrace: stackTrace);
      throw TaskRepositoryException("Error updating task");
    }
  }
 
  Future<void> deleteTask(String id) async {
    try {
      await _taskDatabase.deleteTask(id);
    } catch (e, stackTrace) {
      log("Error deleting task", error: e, stackTrace: stackTrace);
      throw TaskRepositoryException("Error deleting task");
    }
  }
  
  Future<List<TaskModel>> searchTasks(String query) async {
    try {
      return await _taskDatabase.searchTasks(query);
    } catch (e, stackTrace) {
      log("Error searching tasks", error: e, stackTrace: stackTrace);
      throw TaskRepositoryException("Error searching tasks");
    }
  }
  
  Future<int> getTotalTasks() async {
    try {
      return await _taskDatabase.getTotalTasks();
    } catch (e, stackTrace) {
      log("Error retrieving total task count", error: e, stackTrace: stackTrace);
      return 0; 
    }
  }

  Future<void> clearAllTasks() async {
    try {
      await _taskDatabase.clearTasks();
    } catch (e, stackTrace) {
      log("Error clearing all tasks", error: e, stackTrace: stackTrace);
      throw TaskRepositoryException("Error clearing all tasks");
    }
  }
}
