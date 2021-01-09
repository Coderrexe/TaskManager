import 'package:flutter/material.dart';

import 'package:task_manager/helper/database_helper.dart';
import 'package:task_manager/models/task.dart';
import 'package:task_manager/models/todo_item.dart';
import 'package:task_manager/widgets.dart';

class TaskPage extends StatefulWidget {
  final Task task;

  TaskPage({@required this.task});

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  int _taskId = 0;
  String _taskTitle = '';

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _taskId = widget.task.id;
      _taskTitle = widget.task.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 24.0,
                    bottom: 6.0,
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(40.0),
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Icon(
                            Icons.arrow_back_ios,
                            size: 24.0,
                            color: Color(0xFF5F6368),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 24.0),
                          child: TextField(
                            controller: TextEditingController()
                              ..text = _taskTitle,
                            onSubmitted: (value) async {
                              if (value != '') {
                                if (widget.task == null) {
                                  DatabaseHelper _databaseHelper =
                                      DatabaseHelper();

                                  Task _newTask = Task(title: value);
                                  await _databaseHelper.insertTask(_newTask);

                                  Navigator.pop(context);
                                } else {
                                  print('update');
                                }
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter task title...',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter description for the task...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                    ),
                  ),
                ),
                FutureBuilder(
                  future: _databaseHelper.queryTodoItems(_taskId),
                  initialData: [],
                  builder: (context, snapshot) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: TodoItemWidget(
                              text: snapshot.data[index].text,
                              isDone: snapshot.data[index].isDone == 0
                                  ? false
                                  : true,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Container(
                        width: 20.0,
                        height: 20.0,
                        margin: EdgeInsets.only(right: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6.0),
                          border: Border.all(
                            color: Color(0xFF86829D),
                            width: 1.5,
                          ),
                        ),
                        child: Image(
                          image: AssetImage('assets/images/check_icon.png'),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          onSubmitted: (value) async {
                            if (value != '') {
                              if (widget.task != null) {
                                DatabaseHelper _databaseHelper =
                                    DatabaseHelper();

                                TodoItem _newTodoItem = TodoItem(
                                  taskId: widget.task.id,
                                  text: value,
                                  isDone: 0,
                                );

                                await _databaseHelper.insertTodo(
                                  _newTodoItem,
                                );
                                setState(() {});
                              } else {
                                print('task doesnt exist');
                              }
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter a new To-Do...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 24.0,
              right: 24.0,
              child: GestureDetector(
                child: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: Color(0xFFFE3577),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(
                    Icons.delete_forever,
                    size: 28.0,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
