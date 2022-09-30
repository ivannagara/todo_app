// ignore_for_file: prefer_const_constructors
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/config/custom_theme.dart';
import 'package:flutter_cookbook/models/reminder/reminder.dart';
import 'package:flutter_cookbook/models/todo_list/todo_list.dart';
import 'package:flutter_cookbook/screens/auth/authenticate_screen.dart';
import 'package:flutter_cookbook/screens/home/add_list/add_list_screen.dart';
import 'package:flutter_cookbook/screens/home/add_reminder/add_reminder_screen.dart';
import 'package:flutter_cookbook/screens/home/home_screen.dart';
import 'package:flutter_cookbook/services/database-service.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);
    final customTheme = Provider.of<CustomTheme>(context);

    return MultiProvider(
      providers: [
        StreamProvider<List<TodoList>>
        .value(
          value: user != null 
            ? DatabaseService(uid: user.uid).todoListStream() 
            : null,
          initialData: []),
        StreamProvider<List<Reminder>>.value(
          value: user != null 
            ? DatabaseService(uid: user.uid).remindersStream() 
            : null,
          initialData: []),
      ],
      child: MaterialApp(
        // initialRoute: '/',
        routes: {
          // '/' : (context) => AuthenticateScreen(),
          '/home' : (context) => HomeScreen(),
          '/addList' : (context) => AddListScreen(),
          '/addReminder' : (context) => AddReminderScreen(),
        },
        home: user != null ? HomeScreen() : AuthenticateScreen(),
        theme: customTheme.lightTheme,
        darkTheme: customTheme.darkTheme,
        themeMode: customTheme.currentTheme(),
      ),
    );
  }
}