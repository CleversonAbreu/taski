import 'package:flutter/material.dart';
import 'package:taski/data/models/task_model.dart';
import 'package:taski/data/repositories/task_repository.dart';

class FindTaskProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final TaskRepository _taskRepository = TaskRepository();
  String? _errorMessage;
  
  List<TaskModel> _filteredTasks = [];
  bool _isSearching = false;

  List<TaskModel> get filteredTasks => _filteredTasks;
  bool get isSearching => _isSearching;
  String? get errorMessage => _errorMessage;

  FindTaskProvider() {
    searchController.addListener(() {
      filterTasks(searchController.text);
    });
  }

  Future<void> filterTasks(String query) async {
    try {
      _isSearching = query.isNotEmpty;
      _errorMessage = null; 
      notifyListeners();

      if (query.isEmpty) {
        _filteredTasks = [];
      } else {
        _filteredTasks = await _taskRepository.searchTasks(query);
      }
      
      notifyListeners();
    } catch (e) {
      _errorMessage = "errorLoadTasks";
      notifyListeners();
    }
  }

  void clearSearch() {
    searchController.clear();
    _filteredTasks = [];
    _isSearching = false;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(TaskModel task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _taskRepository.updateTask(updatedTask);
      filterTasks(searchController.text);
    } catch (e) {
      _errorMessage = "errorUpdateTask";
      notifyListeners();
    }
  }

  void clearErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
