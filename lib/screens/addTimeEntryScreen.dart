import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/project.dart';
import '../models/task.dart';
import '../models/timeEntry.dart';
import '../providers/projectProvider.dart';
import '../providers/taskProvider.dart';
import '../providers/timeEntryProvider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? projectId; // Utilisez null comme valeur initiale
  String? taskId; // Utilisez null comme valeur initiale
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';
  DateTime selectedDate=DateTime.now();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    // Récupérer les listes de projets et de tâches
    List<Project> projects = projectProvider.project;
    List<Task> tasks = taskProvider.task;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('Add Time Entry',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Dropdown pour les projets
                DropdownButtonFormField<String>(
                  value: projectId,
                  onChanged: (String? newValue) {
                    setState(() {
                      projectId = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Project'),
                  items: projects.map<DropdownMenuItem<String>>((Project project) {
                    return DropdownMenuItem<String>(
                      value: project.id,
                      child: Text(project.name), // Afficher le nom du projet
                    );
                  }).toList(),
                  hint: Text('Project'), // Placeholder
                ),
                SizedBox(height: 15),
                // Dropdown pour les tâches
                DropdownButtonFormField<String>(
                  value: taskId,
                  onChanged: (String? newValue) {
                    setState(() {
                      taskId = newValue;
                    });
                  },
                  decoration: InputDecoration(labelText: 'Task'),
                  items: tasks.map<DropdownMenuItem<String>>((Task task) {
                    return DropdownMenuItem<String>(
                      value: task.id,
                      child: Text(task.name), // Afficher le titre de la tâche
                    );
                  }).toList(),
                  hint: Text('Task'), // Placeholder
                ),
                SizedBox(height: 15),
                // Bouton pour sélectionner la date
                Text('Date: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('Select Date'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                // Champ pour le temps total
                TextFormField(
                  decoration: InputDecoration(labelText: 'Total Time (hours)',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue), // Bordure bleue lorsque le champ est en focus
                    ),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter total time';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) => totalTime = double.parse(value!),
                ),
                SizedBox(
                  height: 15,
                ),
                // Champ pour les notes
                TextFormField(
                  decoration: InputDecoration(labelText: 'Notes',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue), // Bordure bleue lorsque le champ est en focus
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some notes';
                    }
                    return null;
                  },
                  onSaved: (value) => notes = value!,
                ),
                SizedBox(
                  height: 15,
                ),
                // Bouton pour sauvegarder
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      // Vérifiez que projectId et taskId ne sont pas null
                      if (projectId == null || taskId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Veuillez sélectionner un projet et une tâche.'),
                          ),
                        );
                        return;
                      }

                      // Ajoutez l'entrée de temps
                      Provider.of<TimeEntryProvider>(context, listen: false).addTimeEntry(
                        TimeEntry(
                          id: DateTime.now().toString(), // Génération simple d'un ID
                          projectId: projectId!,
                          taskId: taskId!,
                          totalTime: totalTime,
                          date: selectedDate,
                          notes: notes,
                        ),
                      );

                      // Retournez à l'écran précédent
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save TimeEntry',style: TextStyle(color: Colors.blue),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}