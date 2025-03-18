import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';
import 'package:time_tracker/models/project.dart';

class ProjectProvider with ChangeNotifier {
  List<Project> _project = [];
  List<Project> get project => _project;

  final LocalStorage storage;
  ProjectProvider(this.storage) {
    _loadProjects();
  }

  void _loadProjects() {
    var projectStored = storage.getItem('projects');
    if (projectStored != null) {
      var decodedProjects = jsonDecode(projectStored);
      if (decodedProjects != null) {
        _project = List<Project>.from(
          (decodedProjects as List).map((item) => Project.fromJson(item)),
        );
        notifyListeners();
      }
    }
  }

  void _saveProjecToStorage() {
    storage.setItem('projects', jsonEncode(_project.map((e) => e.toJson()).toList()));
  }

  void addProject(Project project) {
    _project.add(project);
    _saveProjecToStorage();
    notifyListeners();
  }

  void deleteProject(String id) {
    _project.removeWhere((project) => project.id == id);
    notifyListeners();
  }
}
