import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/projectProvider.dart';
import 'addTaskScreen.dart';

class ManageProjectScreen extends StatefulWidget {
  const ManageProjectScreen({super.key});

  @override
  State<ManageProjectScreen> createState() => _ManageProjectScreenState();
}

class _ManageProjectScreenState extends State<ManageProjectScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('Manage project',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      body: Consumer<ProjectProvider>(builder: (context, provider, child) {
        return ListView.builder(
            itemCount: provider.project.length,
            itemBuilder: (context, index) {
              final project = provider.project[index];
              return ListTile(
                  title: Text(project.name),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      provider.deleteProject(project.id);
                    },
                  ));
            });
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        onPressed: () {
          // Navigate to the screen to add a new time entry
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => AddTaskDialog(project: true,)),
          // );
          showDialogBox(true, context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add project',
      ),
    );
  }
}
