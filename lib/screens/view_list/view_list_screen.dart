// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/common/widgets/dismissible_background.dart';
import 'package:flutter_cookbook/models/reminder/reminder.dart';
import 'package:flutter_cookbook/models/todo_list/todo_list.dart';
import 'package:flutter_cookbook/services/database-service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cookbook/common/helpers/helpers.dart' as helpers;

class ViewListScreen extends StatelessWidget {

  final TodoList todoList;

  const ViewListScreen(
    {
      super.key,
      required this.todoList,
    });

  @override
  Widget build(BuildContext context) {
    final allReminders = Provider.of<List<Reminder>>(context);
    final remindersForList = allReminders.where((reminder) => 
      reminder.list['id'] == todoList.id).toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(todoList.title),
      ),
      body: ListView.builder(
        itemCount: remindersForList.length,
        itemBuilder: (context, index) {
          final reminder = remindersForList[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: DimissibleBackground(),

            onDismissed: (direction) async {

              final user = Provider.of<User?>(context, listen: false);

              
              try {
                await DatabaseService(uid: user!.uid).deleteReminder(reminder, todoList);
                helpers.showSnackBar(context, 'Reminder Deleted');
              } catch(e) {
                helpers.showSnackBar(context, 'Unable to delete reminder');
              }
            },
            
            child: Card(
              child: ListTile(
                title: Text(reminder.title),
                subtitle: reminder.notes != null ? Text(reminder.notes!) : null,
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(helpers.formatDate(reminder.dueDate)),
                    Text(helpers.formatTime(
                      context,
                      reminder.dueTime['hour'],
                      reminder.dueTime['minute'],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
      }),
    );
  }
}