import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

  final TextEditingController _titleController = TextEditingController();

  bool _contentVisible = false;

  int _taskId = 0;
  String _taskTitle = '';
  String _taskDescription = '';

  @override
  void initState() {
    super.initState();

    if (widget.task != null) {
      _contentVisible = true;

      _taskId = widget.task.id;
      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
    }

    super.initState();
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
                            controller: _titleController..text = _taskTitle,
                            onChanged: (value) async {
                              if (_taskTitle != null) {
                                await _databaseHelper.updateTaskTitle(
                                  _taskId,
                                  value,
                                );
                                _taskTitle = value;
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter task title...',
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  String textFieldValue = _titleController.text;

                                  if (textFieldValue.trim() != '') {
                                    if (widget.task == null) {
                                      Task _newTask =
                                          Task(title: textFieldValue);
                                      _taskId = await _databaseHelper
                                          .insertTask(_newTask);

                                      setState(() {
                                        _contentVisible = true;
                                        _taskTitle = textFieldValue;
                                      });
                                    }
                                  }
                                },
                                icon: Visibility(
                                  visible: _contentVisible ? false : true,
                                  child: Icon(
                                    FontAwesomeIcons.arrowCircleRight,
                                    size: 28.0,
                                    color: Color(0xFF5F6368),
                                  ),
                                ),
                              ),
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
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: TextField(
                      controller: TextEditingController()
                        ..text = _taskDescription,
                      onChanged: (value) async {
                        if (value.trim() != '') {
                          if (_taskId != 0) {
                            await _databaseHelper.updateTaskDescription(
                              _taskId,
                              value,
                            );
                            _taskDescription = value;
                          }
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Enter description for the task...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 24.0),
                      ),
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
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
                            onTap: () async {
                              if (snapshot.data[index].isDone == 0) {
                                await _databaseHelper.updateTodoIsDone(
                                  snapshot.data[index].id,
                                  1,
                                );
                              } else {
                                await _databaseHelper.updateTodoIsDone(
                                  snapshot.data[index].id,
                                  0,
                                );
                              }
                              setState(() {});
                            },
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
                Visibility(
                  visible: _contentVisible,
                  child: Padding(
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
                          child: Icon(
                            Icons.done,
                            size: 15,
                            color: Color(0xF6F6F6),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            controller: TextEditingController()..text = '',
                            onSubmitted: (value) async {
                              if (value.trim() != '') {
                                if (_taskId != null) {
                                  TodoItem _newTodoItem = TodoItem(
                                    taskId: _taskId,
                                    text: value,
                                    isDone: 0,
                                  );

                                  await _databaseHelper.insertTodo(
                                    _newTodoItem,
                                  );
                                  setState(() {});
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
                ),
              ],
            ),
            Visibility(
              visible: _contentVisible,
              child: Positioned(
                bottom: 24.0,
                right: 24.0,
                child: GestureDetector(
                  onTap: () async {
                    if (_taskId != 0) {
                      await _databaseHelper.deleteTask(_taskId);
                      Navigator.pop(context);
                    }
                  },
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
            ),
          ],
        ),
      ),
    );
  }
}
