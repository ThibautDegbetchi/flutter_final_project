import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/providers/projectProvider.dart';
import 'package:time_tracker/providers/taskProvider.dart';

import '../models/task.dart';


void showDialogBox(bool project, BuildContext context) {
  final TextEditingController _nameController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(project ? 'Add project' : 'Add Task'),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: project ? 'Project Name' : 'Task Name'),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final tagName = _nameController.text;
              if (tagName.isNotEmpty) {
                project
                    ? Provider.of<ProjectProvider>(context, listen: false).addProject(
                  Project(
                    id: DateTime.now().toString(), // Génération simple d'un ID
                    name: tagName,
                  ),
                )
                    : Provider.of<TaskProvider>(context, listen: false).addTask(
                  Task(
                    id: DateTime.now().toString(), // Génération simple d'un ID
                    name: tagName,
                  ),
                );
                Navigator.of(context).pop(tagName);
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}