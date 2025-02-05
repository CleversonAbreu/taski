import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:taski/data/datasources/local/task_database.dart';
import 'package:taski/data/models/task_model.dart';
import 'package:taski/data/repositories/task_repository.dart';


import 'task_repository_test.mocks.dart';

@GenerateMocks([TaskDatabase])
void main() {
  late TaskRepository taskRepository;
  late MockTaskDatabase mockTaskDatabase;
 

  setUp(() {
    mockTaskDatabase = MockTaskDatabase();
    taskRepository = TaskRepository();
    taskRepository = TaskRepository()..taskDatabase = mockTaskDatabase;
  });

  test('getTasks should return a list of tasks', () async {
    final tasks = [
      TaskModel(id: '1', title: 'Task 1', isCompleted: false, description: 'Desc 1'),
      TaskModel(id: '2', title: 'Task 2', isCompleted: false, description: 'Desc 2'),
    ];

    when(mockTaskDatabase.getTasks(any, any)).thenAnswer((_) async => tasks);

    final result = await taskRepository.getTasks();

    expect(result, tasks);
    verify(mockTaskDatabase.getTasks(10, 0)).called(1);
  });

  test('addTask should insert a task into the database', () async {
    final task = TaskModel(id: '1', title: 'Test Task', isCompleted: false, description: 'Description');

    when(mockTaskDatabase.insertTask(task)).thenAnswer((_) async {});

    await taskRepository.addTask(task);

    verify(mockTaskDatabase.insertTask(task)).called(1);
  });

  test('deleteTask should remove a task from the database', () async {
    const taskId = '1';

    when(mockTaskDatabase.deleteTask(taskId)).thenAnswer((_) async {});

    await taskRepository.deleteTask(taskId);

    verify(mockTaskDatabase.deleteTask(taskId)).called(1);
  });

  test('updateTask should update a task in the database', () async {
    final task = TaskModel(id: '1', title: 'Updated Task', isCompleted: true, description: 'Updated Desc');

    when(mockTaskDatabase.updateTask(task)).thenAnswer((_) async {});

    await taskRepository.updateTask(task);

    verify(mockTaskDatabase.updateTask(task)).called(1);
  });

  test('getTotalTasks should return the total number of tasks', () async {
    when(mockTaskDatabase.getTotalTasks()).thenAnswer((_) async => 5);

    final totalTasks = await taskRepository.getTotalTasks();

    expect(totalTasks, 5);
    verify(mockTaskDatabase.getTotalTasks()).called(1);
  });
}
