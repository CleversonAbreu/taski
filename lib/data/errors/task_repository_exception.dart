class TaskRepositoryException implements Exception {
  final String message;
  TaskRepositoryException(this.message);

  @override
  String toString() => "TaskRepositoryException: $message";
}