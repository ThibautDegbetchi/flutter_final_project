// import 'dart:convert';
//
// import 'package:flutter/material.dart';
// import 'package:localstorage/localstorage.dart';
// import '../models/project.dart';
// import '../models/task.dart';
//
// class ProjectTaskProvider with ChangeNotifier {
//   final LocalStorage storage;
//
//   List<Project> _projects = [];
//   List<Task> _tasks = [];
//
//   List<Project> get projects => _projects;
//   List<Task> get tasks => _tasks;
//
//
//   ProjectTaskProvider(this.storage) {
//     _loadProjectFromStorage();
//   }
//
//   void _loadProjectFromStorage() {
//     var storedExpenses = storage.getItem('projectsTasks');
//     if (storedExpenses != null) {
//
//       var decodedTasks = jsonDecode(storedExpenses);
//       if (decodedTasks != null) {
//         _projects = List<Project>.from(
//           (decodedTasks as List).map((item) => Project.fromJson(item)),
//         );
//         notifyListeners();
//       }
//     }
//   }
//   void _saveProjectToStorage() {
//     storage.setItem('projectsTasks', jsonEncode(_projects.map((e) => e.toJson()).toList()));
//   }
//
//
//
//
//   void addProject(Project project) {
//     _projects.add(project);
//     _saveProjectToStorage();
//     notifyListeners();
//   }
//
//   void addTask(Task task) {
//     _tasks.add(task);
//     notifyListeners();
//   }
//
//   void deleteProject(String id) {
//     _projects.removeWhere((project) => project.id == id);
//     notifyListeners();
//   }
//
//   void deleteTask(String id) {
//     _tasks.removeWhere((task) => task.id == id);
//     notifyListeners();
//   }
// }
