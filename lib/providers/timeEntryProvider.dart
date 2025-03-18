import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/models/project.dart';
import 'package:time_tracker/models/task.dart';
import 'package:time_tracker/providers/projectProvider.dart';
import 'package:time_tracker/providers/taskProvider.dart';

import '../models/timeEntry.dart';

class TimeEntryProvider with ChangeNotifier {
  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;
  final LocalStorage storage;

  TimeEntryProvider(this.storage) {
    _loadTimeEntryFromStorage();
  }
  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveTimeEntryToStorage();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveTimeEntryToStorage();
    notifyListeners();
  }


  void _loadTimeEntryFromStorage() {
    var storedExpenses = storage.getItem('entries');
    if (storedExpenses != null) {
      _entries = List<TimeEntry>.from(
        (storedExpenses as List).map((item) => TimeEntry.fromJson(item)),
      );
      notifyListeners();
    }
  }
  void _saveTimeEntryToStorage() {
    storage.setItem('entries', jsonEncode(_entries.map((e) => e.toJson()).toList()));
  }

  Project findProjectById(String id,BuildContext context) {
    // Récupérer les listes de projets et de tâches
    List<Project> projects = Provider.of<ProjectProvider>(context).project;
    return projects.firstWhere(
          (project) => project.id == id,
    );
  }
  Task findTaskNyId(String id,BuildContext context){
    List<Task> tasks = Provider.of<TaskProvider>(context).task;
    return tasks.firstWhere(
          (task) => task.id == id,
    );
  }
}