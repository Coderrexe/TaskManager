import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:task_manager/views/home.dart';

void main() {
  runApp(TaskManager());
}

class TaskManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        textTheme: GoogleFonts.nunitoSansTextTheme(Theme.of(context).textTheme),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
