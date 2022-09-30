// ignore_for_file: prefer_const_constructors, prefer_conditional_assignment

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/common/helpers/helpers.dart' as helpers;
import 'package:flutter_cookbook/common/widgets/category_icon.dart';
import 'package:flutter_cookbook/models/category.dart';
import 'package:flutter_cookbook/models/category_collection.dart';
import 'package:flutter_cookbook/models/reminder/reminder.dart';
import 'package:flutter_cookbook/screens/home/add_reminder/select_reminder_category_screen.dart';
import 'package:flutter_cookbook/screens/home/add_reminder/select_reminder_list_screen.dart';
import 'package:flutter_cookbook/services/database-service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../models/todo_list/todo_list.dart';

class AddReminderScreen extends StatefulWidget {
  const AddReminderScreen({super.key});

  @override
  State<AddReminderScreen> createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _notesTextController = TextEditingController();

  String _title = '';
  TodoList? _selectedList;
  Category _selectedCategory = CategoryCollection().categories[0];
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

    @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _titleTextController.addListener((){
      setState(() {
        _title = _titleTextController.text;
      });
    });
  }

  _updateSelectedList(TodoList todoList) {
    setState(() {
      _selectedList = todoList;
    });
  }

  _updateSelectedCategory(Category category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleTextController.dispose();
    _notesTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _todoLists = Provider.of<List<TodoList>>(context);
    User? user = Provider.of<User?>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Reminder'),
        actions: [
          TextButton(
            onPressed: 
              _title.isEmpty
              || _selectedDate == null
              || _selectedTime == null
              ? null 
              : () async {
                if (_selectedList == null) {
                  _selectedList = _todoLists[0];
                }
                // 1. add reminder to users>uid>reminders>new reminder
                // 2. update the reminder count in the list -> users>uid>todo_lists>todo_list
                
                var newReminder = Reminder(
                  id: null,
                  title: _titleTextController.text,
                  categoryId: _selectedCategory.id,
                  notes: _notesTextController.text,
                  list: _selectedList!.toJson(),
                  dueDate: _selectedDate!.millisecondsSinceEpoch,
                  dueTime: {
                    'hour': _selectedTime!.hour,
                    'minute': _selectedTime!.minute,
                  });

                try {
                  DatabaseService(uid: user!.uid).addReminder(reminder: newReminder);
                  Navigator.pop(context);
                  helpers.showSnackBar(context, "Reminder Added");
                } catch(e) {
                  helpers.showSnackBar(context, "Unable to add Reminder");
                }
              },
            child: Text(
              'Add',
              ),
            ),
          ],
        ),

      // Add reminder body section
      body: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).cardColor),
                child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    TextField(
                      controller: _titleTextController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Title',
                        border: InputBorder.none,
                        ),
                    ),
                
                    Divider(height: 1),
                
                    SizedBox(
                      height: 100,
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: _notesTextController,
                        decoration: InputDecoration(
                          hintText: 'Notes',
                          border: InputBorder.none,
                          ),
                      ),
                    ),
                  ],
                ),
              ),
        
              SizedBox(height: 20),
        
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => 
                            SelectReminderListScreen(
                              selectedList: _selectedList != null
                                ? _selectedList! 
                                : _todoLists[0],
                              todoLists: _todoLists,
                              selectListCallback: _updateSelectedList,                   
                            ),
                            fullscreenDialog: true,
                          ),
                        );
                    },
                    leading: Text(
                      'List',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryIcon(
                          bgColor: Colors.blueAccent,
                          iconData: Icons.calendar_today),
                        SizedBox(width: 10),
                        Text(_selectedList != null 
                          ? _selectedList!.title 
                          : _todoLists[0].title),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
        
              SizedBox(height: 20),
        
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                            SelectReminderCategoryScreen(
                              selectedCategory: _selectedCategory,
                              selectCategoryCallback: _updateSelectedCategory,
                              ),
                            fullscreenDialog: true,
                          ),
                      );
                    },
                    leading: Text(
                      'Category',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryIcon(
                          bgColor: _selectedCategory.icon.bgColor,
                          iconData: _selectedCategory.icon.iconData),
                        SizedBox(width: 10),
                        Text(_selectedCategory.name),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
        
              SizedBox(height: 20),
        
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () async {
                      final DateTime? _pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(), 
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                        );
                      if (_pickedDate != null) {
                        print(_pickedDate);
                        setState(() {
                          _selectedDate = _pickedDate;
                        });
                      } else {
                        print('no date was picked');
                      }
                    },
                    leading: Text(
                      'Date',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryIcon(
                          bgColor: Colors.red.shade500,
                          iconData: CupertinoIcons.calendar_badge_plus),
                        SizedBox(width: 10),
                        Text(_selectedDate != null 
                          ? DateFormat.yMMMd().format(_selectedDate!).toString()
                          : 'Select Date'),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
        
              SizedBox(height: 20),
        
              Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: () async {
                      final TimeOfDay? _pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now());
                      if (_pickedTime != null) {
                        print(_pickedTime);
                        setState(() {
                          _selectedTime = _pickedTime;
                        });
                      } else {
                        print('No time was picked');
                      }
                    },
                    leading: Text(
                      'Time',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CategoryIcon(
                          bgColor: Colors.red.shade500,
                          iconData: CupertinoIcons.time),
                        SizedBox(width: 10),
                        Text(_selectedTime != null 
                          ? _selectedTime!.format(context).toString() 
                          : 'Select Time'),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}