// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../models/project.dart';
// import '../models/task.dart';
// import '../providers/projectTaskProvider.dart';
//
// class ProjectTaskManagementScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manage Projects and Tasks'),
//       ),
//       body: Consumer<ProjectTaskProvider>(
//         builder: (context, provider, child) {
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: provider.projects.length,
//                   itemBuilder: (context, index) {
//                     final project = provider.projects[index];
//                     return ListTile(
//                       title: Text(project.name),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () {
//                           provider.deleteProject(project.id);
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: provider.tasks.length,
//                   itemBuilder: (context, index) {
//                     final task = provider.tasks[index];
//                     return ListTile(
//                       title: Text(task.name),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () {
//                           provider.deleteTask(task.id);
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showAddDialog(context);
//         },
//         child: Icon(Icons.add),
//         tooltip: 'Add Project/Task',
//       ),
//     );
//   }
//
//   void _showAddDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         String name = '';
//         bool isProject = true;
//
//         return AlertDialog(
//           title: Text('Add Project or Task'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 decoration: InputDecoration(labelText: 'Name'),
//                 onChanged: (value) => name = value,
//               ),
//               Row(
//                 children: [
//                   Text('Is Project?'),
//                   Switch(
//                     value: isProject,
//                     onChanged: (value) {
//                       isProject = value;
//                     },
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 if (name.isNotEmpty) {
//                   final provider = Provider.of<ProjectTaskProvider>(context, listen: false);
//                   if (isProject) {
//                     provider.addProject(Project(id: DateTime.now().toString(), name: name));
//                   } else {
//                     provider.addTask(Task(id: DateTime.now().toString(), name: name));
//                   }
//                   Navigator.pop(context);
//                 }
//               },
//               child: Text('Add'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }