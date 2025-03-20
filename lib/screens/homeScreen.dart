import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/screens/manageProjectSecreen.dart';
import 'package:time_tracker/screens/manageTaskScreen.dart';

import '../models/timeEntry.dart';
import '../providers/timeEntryProvider.dart';
import 'addTimeEntryScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool index = true;
  String formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('MMM d, y'); // Format : nov 23, 2024
    return formatter.format(date);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        centerTitle: true,
        title: Text('Time Traching',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.teal),
              child: Text('Menu',
                  style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.folder, color: Colors.black),
              title: Text('Projects'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageProjectScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.paste_outlined, color: Colors.black),
              title: Text('Tasks'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                // Navigator.pushNamed(context, '/manage_tags');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageTaskScreen()));
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.teal,
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => index = true),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: index
                                ? Border(
                                    bottom: BorderSide(
                                        color: Colors.amber, width: 3))
                                : null,
                          ),
                          child: Text('All Entries',
                              style: TextStyle(
                                  color: index ? Colors.white : null,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => index = false),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            border: !index
                                ? Border(
                                    bottom: BorderSide(
                                        color: Colors.amber, width: 3))
                                : null,
                          ),
                          child: Text('Grouped by Projects',
                              style: TextStyle(
                                  color: !index ? Colors.white : null,
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<TimeEntryProvider>(
              builder: (context, provider, child) {
                if (provider.entries.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/sablier.png",
                        scale: 2,
                      ),
                      SizedBox(height: 15),
                      Text("No time entries yet!",
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5),
                      Text("Tap the + button to add your first entry.",
                          style: TextStyle(color: Colors.grey)),
                    ],
                  );
                }

                // Grouper les entrées par projet si l'onglet "Grouped by Projects" est sélectionné
                if (!index) {
                  // Créer une Map pour regrouper les entrées par projectId
                  final Map<String, List<TimeEntry>> groupedEntries = {};
                  for (var entry in provider.entries) {
                    if (!groupedEntries.containsKey(entry.projectId)) {
                      groupedEntries[entry.projectId] = [];
                    }
                    groupedEntries[entry.projectId]!.add(entry);
                  }

                  // Afficher les entrées groupées par projet
                  return ListView.builder(
                    itemCount: groupedEntries.length,
                    itemBuilder: (context, i) {
                      final projectId = groupedEntries.keys.elementAt(i);
                      final project = provider.findProjectById(projectId, context);
                      final entries = groupedEntries[projectId]!;

                      return Card(
                        margin: EdgeInsets.all(10),
                        elevation: 0.7,
                        child: ExpansionTile(
                          title: Text(
                            project.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal),
                          ),
                          children: entries.map((entry) {
                            final task = provider.findTaskNyId(entry.taskId, context);
                            return ListTile(
                              title: Text('${task.name}'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Total Time: ${entry.totalTime.toInt()} hours'),
                                  Text('Date: ${formatDate(entry.date)}'),
                                  Text('Note: ${entry.notes}'),
                                ],
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  provider.deleteTimeEntry(entry.id);
                                },
                                icon: Icon(Icons.delete, color: Colors.red),
                              ),
                            );
                          }).toList(),
                        ),
                      );
                    },
                  );
                }

                // Afficher toutes les entrées si l'onglet "All Entries" est sélectionné
                return ListView.builder(
                  itemCount: provider.entries.length,
                  itemBuilder: (context, index) {
                    final entry = provider.entries[index];
                    final project = provider.findProjectById(entry.projectId, context);
                    final task = provider.findTaskNyId(entry.taskId, context);
                    return Card(
                      margin: EdgeInsets.all(10),
                      elevation: 0.7,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${project.name} - ${task.name}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.teal),
                                ),
                                Text('Total Time: ${entry.totalTime.toInt()} hours'),
                                Text('Date: ${formatDate(entry.date)}'),
                                Text('Note: ${entry.notes}'),
                              ],
                            ),
                            IconButton(
                              onPressed: () {
                                provider.deleteTimeEntry(entry.id);
                              },
                              icon: Icon(Icons.delete, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.white,
        onPressed: () {
          // Navigate to the screen to add a new time entry
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Time Entry',
      ),
    );
  }
}
