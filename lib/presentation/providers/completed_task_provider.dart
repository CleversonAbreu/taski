import 'package:flutter/material.dart';
import 'package:taski/data/models/task_model.dart';
import 'package:taski/data/repositories/task_repository.dart';

class CompletedTaskProvider with ChangeNotifier {
  final TaskRepository _repository;
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  bool _isDeletingAll = false;
  final bool _hasMore = true;
  String? _errorMessage;

  CompletedTaskProvider(this._repository);

  List<TaskModel> get tasks => _tasks;
  bool get isLoading => _isLoading;
  bool get isDeletingAll => _isDeletingAll;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  Future<void> loadTasks({bool isRefresh = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final offset = isRefresh ? 0 : _tasks.length;
      final newTasks =
          await _repository.getCompletedTasks(limit: 12, offset: offset);

      if (isRefresh) {
        _tasks = newTasks;
      } else {
        _tasks.addAll(newTasks);
      }
    } catch (e) {
      _errorMessage = "errorLoadTasks";
    } finally {
      _isLoading = false;
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

  Future<void> deleteAllTasks() async {
    if (_isDeletingAll) return;

    _isDeletingAll = true;
    notifyListeners();

    try {
      await _repository.clearAllTasks();
      _tasks.clear();
    } catch (e) {
      _errorMessage = "errorDeleteTask";
      notifyListeners();
    } finally {
      _isDeletingAll = false;
      notifyListeners();
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}
