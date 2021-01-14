import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/todo_item.dart';

class DatabaseHelper {
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'task_manager.db'),
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE task ('
          'id INTEGER PRIMARY KEY,'
          'title TEXT,'
          'description TEXT'
          ')',
        );
        await db.execute(
          'CREATE TABLE todo_item ('
          'id INTEGER PRIMARY KEY,'
          'task_id INTEGER,'
          'text TEXT,'
          'is_done INTEGER'
          ')',
        );

        return db;
      },
      version: 1,
    );
  }

  Future<int> insertTask(Task task) async {
    int taskId = 0;

    final Database _db = await initDatabase();
    await _db
        .insert(
      'task',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    )
        .then((value) {
      taskId = value;
    });

    return taskId;
  }

  Future<void> updateTaskTitle(int id, String title) async {
    final Database _db = await initDatabase();
    await _db
        .rawUpdate('UPDATE task SET title = \'$title\' WHERE id = \'$id\'');
  }

  Future<void> updateTaskDescription(int id, String description) async {
    final Database _db = await initDatabase();
    await _db.rawUpdate(
        'UPDATE task SET description = \'$description\' WHERE id = \'$id\'');
  }

  Future<void> deleteTask(int id) async {
    final Database _db = await initDatabase();

    _db.rawDelete('DELETE FROM task WHERE id = \'$id\'');
    _db.rawDelete('DELETE FROM todo_item WHERE task_id = \'$id\'');
  }

  Future<List<Task>> queryTasks() async {
    final Database _db = await initDatabase();
    List<Map<String, dynamic>> taskMap = await _db.query('task');

    return List.generate(taskMap.length, (index) {
      return Task(
        id: taskMap[index]['id'],
        title: taskMap[index]['title'],
        description: taskMap[index]['description'],
      );
    });
  }

  Future<void> insertTodo(TodoItem todoItem) async {
    final Database _db = await initDatabase();
    await _db.insert(
      'todo_item',
      todoItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTodoIsDone(int id, int isDone) async {
    final Database _db = await initDatabase();
    await _db.rawUpdate(
        'UPDATE todo_item SET is_done = \'$isDone\' WHERE id = \'$id\'');
  }

  Future<List<TodoItem>> queryTodoItems(int taskId) async {
    final Database _db = await initDatabase();
    List<Map<String, dynamic>> todoItemsMap =
        await _db.rawQuery('SELECT * FROM todo_item WHERE task_id = $taskId');

    return List.generate(todoItemsMap.length, (index) {
      return TodoItem(
        id: todoItemsMap[index]['id'],
        taskId: todoItemsMap[index]['task_id'],
        text: todoItemsMap[index]['text'],
        isDone: todoItemsMap[index]['is_done'],
      );
    });
  }
}
