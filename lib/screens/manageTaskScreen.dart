import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/providers/taskProvider.dart';
import 'package:time_tracker/screens/addTaskScreen.dart';

import '../models/task.dart';

class ManageTaskScreen extends StatefulWidget {
  const ManageTaskScreen({super.key});

  @override
  State<ManageTaskScreen> createState() => _ManageTaskScreenState();
}

class _ManageTaskScreenState extends State<ManageTaskScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('Manage Tasks',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: Consumer<TaskProvider>(builder: (context, provider, child) {
        return ListView.builder(
            itemCount: provider.task.length,
            itemBuilder: (context, index) {
              final task = provider.task[index];
              return ListTile(
                  title: Text(task.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      provider.deleteTask(task.id);
                    },
                  ));
            });
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        onPressed: () {
          // Navigate to the screen to add a new time entry
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskDialog(project: false,)),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}
