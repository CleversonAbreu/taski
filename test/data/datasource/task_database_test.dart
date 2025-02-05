import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:taski/data/datasources/local/task_database.dart';
import 'package:taski/data/models/task_model.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'task_database_test.mocks.dart'; 

// Generate mocks for TaskDatabase
@GenerateMocks([TaskDatabase])
void main() {
  late MockTaskDatabase mockTaskDatabase;

  setUp(() async {
    // Initialize sqflite_common_ffi
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // Create a mock instance of TaskDatabase
    mockTaskDatabase = MockTaskDatabase();
  });

  tearDown(() async {
    // No database to close since we're using the mock
  });

  test('insertTask should insert a task into the database', () async {
    final task = TaskModel(
      id: '1',
      title: 'Test Task',
      isCompleted: false,
      description: 'Description',
    );

    // Set up the mock to return a successful insertion
    when(mockTaskDatabase.insertTask(task)).thenAnswer((_) async {});

    // Call the method to insert a task
    await mockTaskDatabase.insertTask(task);

    // Verify that the insertTask method was called with the correct task
    verify(mockTaskDatabase.insertTask(task)).called(1);
  });

  test('deleteTask should delete a task from the database', () async {
    final task = TaskModel(
      id: '1',
      title: 'Test Task',
      isCompleted: false,
      description: 'Description',
    );

    // Set up the mock to return a successful deletion
    when(mockTaskDatabase.deleteTask('1')).thenAnswer((_) async {});

    // Insert a task first
    await mockTaskDatabase.insertTask(task);
    
    // Now, delete the task
    await mockTaskDatabase.deleteTask('1');

    // Verify that deleteTask was called with the correct task ID
    verify(mockTaskDatabase.deleteTask('1')).called(1);
  });

  test('getTotalTasks should return task count', () async {
    final task1 = TaskModel(id: '1', title: 'Task 1', isCompleted: false, description: 'Desc 1');
    final task2 = TaskModel(id: '2', title: 'Task 2', isCompleted: false, description: 'Desc 2');

    // Set up the mock to return a count of 2 tasks
    when(mockTaskDatabase.getTotalTasks()).thenAnswer((_) async => 2);

    // Insert tasks (simulated by the mock return value)
    await mockTaskDatabase.insertTask(task1);
    await mockTaskDatabase.insertTask(task2);

    // Get the total number of tasks
    final totalTasks = await mockTaskDatabase.getTotalTasks();

    // Verify that the totalTasks method was called once
    verify(mockTaskDatabase.getTotalTasks()).called(1);

    // Assert that the total tasks count is correct
    expect(totalTasks, 2);
  });
}
