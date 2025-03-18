import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _task = [];
  List<Task> get task => _task;

  final LocalStorage storage;
  TaskProvider(this.storage) {
    _loadTasks();
  }

  void _loadTasks() {
    try {
      var taskStored = storage.getItem('tasks');
      if (taskStored != null) {
        var decodedTasks = jsonDecode(taskStored);
        if (decodedTasks != null) {
          _task = List<Task>.from(
            (decodedTasks as List).map((item) => Task.fromJson(item)),
          );
          notifyListeners();
        }
      }
    } catch (e) {
      print("Erreur lors du chargement des tâches: $e");
      // Vous pouvez également initialiser _task avec une liste vide en cas d'erreur
      _task = [];
      notifyListeners();
    }
  }

  void _saveTaskToStorage() {
    storage.setItem('tasks', jsonEncode(_task.map((e) => e.toJson()).toList()));
  }

  void addTask(Task task) {
    _task.add(task);
    _saveTaskToStorage();
    notifyListeners();
  }

  void deleteTask(String id) {
    _task.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}
