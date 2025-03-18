import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/providers/projectProvider.dart';
import 'package:time_tracker/providers/taskProvider.dart';

import '../models/task.dart';
class AddTaskDialog extends StatefulWidget {
  final bool project;
  AddTaskDialog({required this.project});
  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}
class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.project?'Add project':'Add Task'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: widget.project?'Add project':'Task Name'),
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
              widget.project?
              Provider.of<ProjectProvider>(context, listen: false).addProject(
                Project(
                    id: DateTime.now().toString(), // Génération simple d'un ID
                    name: tagName
                ),
              )
                  : Provider.of<TaskProvider>(context, listen: false).addTask(
                Task(
                  id: DateTime.now().toString(), // Génération simple d'un ID
                  name: tagName
                ),
              );
              Navigator.of(context).pop(tagName);
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}