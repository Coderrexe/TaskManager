import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:task_manager/helper/database_helper.dart';
import 'package:task_manager/views/task_page.dart';
import 'package:task_manager/widgets.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                        top: 32.0,
                        bottom: 32.0,
                      ),
                      child: Image(image: AssetImage('assets/images/logo.png')),
                    ),
                    Expanded(
                      child: FutureBuilder(
                        future: _databaseHelper.queryTasks(),
                        initialData: [],
                        builder: (context, snapshot) {
                          return ScrollConfiguration(
                            behavior: DisableScrollGlow(),
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskPage(
                                          task: snapshot.data[index],
                                        ),
                                      ),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: TaskCard(
                                    title: snapshot.data[index].title,
                                    description:
                                        snapshot.data[index].description,
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 24.0,
                  right: 0.0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskPage(task: null),
                        ),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: Icon(
                        Icons.add,
                        size: 32.0,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
