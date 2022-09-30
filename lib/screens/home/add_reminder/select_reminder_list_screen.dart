// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../../../models/todo_list/todo_list.dart';

// Use stateless widget bcs it only displays the list, and
// to select the selected list, we use a method from the parent
// file which is the 'add_reminder_screen.dart'.
class SelectReminderListScreen extends StatelessWidget {
  
  final List<TodoList> todoLists;
  final TodoList selectedList;
  final Function(TodoList) selectListCallback;

  const SelectReminderListScreen({
    Key? key, 
    required this.todoLists,
    required this.selectListCallback,
    required this.selectedList,
  }) : super (key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select List'),
      ),
      body: ListView.builder(
        itemCount: todoLists.length,
        itemBuilder: (context, index) {
        final item = todoLists[index];
        return ListTile(
          onTap: ((){
            selectListCallback(item);
            Navigator.pop(context);
          }),
          title: Text(item.title),
          trailing: item.title == selectedList.title 
            ? Icon(Icons.check) 
            : null,
        );
      }),
    );
  }
}