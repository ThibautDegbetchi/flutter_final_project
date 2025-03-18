import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/providers/projectProvider.dart';
import 'package:time_tracker/providers/projectTaskProvider.dart';
import 'package:time_tracker/providers/taskProvider.dart';
import 'package:time_tracker/providers/timeEntryProvider.dart';
import 'package:time_tracker/screens/homeScreen.dart';
import 'package:localstorage/localstorage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initLocalStorage();
  runApp(MyApp(localStorage: localStorage));
}

class MyApp extends StatelessWidget {
  final LocalStorage localStorage;
  const MyApp({Key? key, required this.localStorage}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeEntryProvider(localStorage)),
        ChangeNotifierProvider(create: (_) => ProjectTaskProvider(localStorage)),
        ChangeNotifierProvider(create: (_) => TaskProvider(localStorage)),
        ChangeNotifierProvider(create: (_) => ProjectProvider(localStorage)),
      ],
      child:     MaterialApp(
        title: 'Time Tracker',
        home: HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}