// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/common/helpers/helpers.dart' as helpers;
import 'package:flutter_cookbook/common/widgets/dismissible_background.dart';
import 'package:flutter_cookbook/models/category.dart';
import 'package:flutter_cookbook/models/reminder/reminder.dart';
import 'package:flutter_cookbook/services/database-service.dart';
import 'package:provider/provider.dart';

import '../../models/todo_list/todo_list.dart';

class ViewListByCategoryScreen extends StatelessWidget {

  final Category category;

  const ViewListByCategoryScreen(
    {super.key,
    required this.category,
    });

  @override
  Widget build(BuildContext context) {
    final allReminders = Provider.of<List<Reminder>>(context);
    final remindersForCategory = 
      allReminders.where((reminder) => 
        reminder.categoryId == category.id 
        || category.id == 'all').toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(category.id),
      ),
      body: ListView.builder(
        itemCount: remindersForCategory.length,
        itemBuilder: (context, index) {
          final reminder = remindersForCategory[index];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: DimissibleBackground(),
            onDismissed: (direction) async {

              final user = Provider.of<User?>(context, listen: false);
              final todoLists = Provider.of<List<TodoList>>(context, listen: false);
              // Only get the todoLists which has the 
              // same id as the list in a specific reminder
              final todoListForReminder = todoLists
                .firstWhere((todoList) => todoList.id == reminder.list['id']);

              try {
                await DatabaseService(uid: user!.uid).deleteReminder(
                reminder, todoListForReminder);
                helpers.showSnackBar(context, 'Deleted Reminder');
              } catch(e) {
                helpers.showSnackBar(context, "Unable to delete reminder");
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