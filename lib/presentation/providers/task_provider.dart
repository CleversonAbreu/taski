import 'package:flutter/material.dart';
import 'package:taski/data/models/task_model.dart';
import 'package:taski/data/repositories/task_repository.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _repository;
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  final bool _hasMore = true;
  int totalTasks = 0;
  String? _errorMessage;

  TaskProvider(this._repository);

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  Future<void> loadTasks({bool isRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final offset = isRefresh ? 0 : _tasks.length;
      final newTasks = await _repository.getTasks(limit: 12, offset: offset);

      if (isRefresh) {
        _tasks = newTasks;
      } else {
        _tasks.addAll(newTasks);
        totalTasks = tasks.length;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = "errorLoadTasks";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTask(
      String title, String description, bool isCompleted) async {
    try {
      final newTask = TaskModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        isCompleted: isCompleted,
      );

      await _repository.addTask(newTask);

      if (!newTask.isCompleted) {
        _tasks.insert(0, newTask);
        totalTasks++;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = "errorAddTask";
      notifyListeners();
    }
  }

  Future<void> updateTask(TaskModel task) async {
    try {
      await _repository.updateTask(task);
      totalTasks++;
      loadTasks(isRefresh: true);
    } catch (e) {
      _errorMessage = "errorUpdateTask";
      notifyListeners();
    }
  }

  Future<void> toggleTask(String id) async {
    try {
      final task = _tasks.firstWhere((task) => task.id == id);
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);

      await _repository.updateTask(updatedTask);
      totalTasks--;
      loadTasks(isRefresh: true);
    } catch (e) {
      _errorMessage = "errorUpdateTask";
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _repository.deleteTask(id);
      loadTasks(isRefresh: true);
    } catch (e) {
      _errorMessage = "errorDeleteTask";
      notifyListeners();
    }
  }

  Future<void> getTotalTasks() async {
    try {
      totalTasks = await _repository.getTotalTasks();
      notifyListeners();
    } catch (e) {
      _errorMessage = "errorDeleteTask";
      notifyListeners();
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
