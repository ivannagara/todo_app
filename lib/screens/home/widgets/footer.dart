  // ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_cookbook/models/todo_list/todo_list.dart';
import 'package:flutter_cookbook/screens/home/add_list/add_list_screen.dart';
import 'package:flutter_cookbook/screens/home/add_reminder/add_reminder_screen.dart';
import 'package:provider/provider.dart';

class Footer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final todoLists = Provider.of<List<TodoList>>(context);
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: todoLists.isNotEmpty ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddReminderScreen(),
                  fullscreenDialog: true,
                  ),
                );
            } : null,
            icon: Icon(Icons.add_circle),
            label: Text('New Reminder'),
            ),
          TextButton(
            onPressed: ()  {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddListScreen(),
                  fullscreenDialog: true,
                ),
              );
            },
            child: Text(
              'Add List',
              style: TextStyle(
                color: Colors.blueAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
