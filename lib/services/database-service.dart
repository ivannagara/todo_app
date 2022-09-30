import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/models/reminder/reminder.dart';
import 'package:flutter_cookbook/models/todo_list/todo_list.dart';

class DatabaseService {
  final String uid;
  final FirebaseFirestore _database;
  final DocumentReference _userRef;

  DatabaseService({required this.uid}):
  _database = FirebaseFirestore.instance,
  _userRef = FirebaseFirestore.instance.collection('users').doc(uid);


  Stream<List<TodoList>> todoListStream() {
    return _userRef
        .collection('todo_lists').snapshots()
        .map((snapshot) => snapshot.docs //snapshot of the collection
          .map((todoListSnapshot) =>  // snapshot of the datas inside the collection
          TodoList.fromJson(todoListSnapshot.data(),
          ),
        ).toList(),
      );
  }

  Stream<List<Reminder>> remindersStream() {
    return _userRef
      .collection('reminders').snapshots()
      .map((remindersSnapshot) => remindersSnapshot.docs
        .map((reminderSnapshot) => 
          Reminder.fromJson(reminderSnapshot.data(),
          ),
        ).toList(), 
      );
  }

  addTodoList({required TodoList todoList}) async {
    final todoListRef = 
      _userRef
      .collection('todo_lists')
      .doc();

    todoList.id = todoListRef.id;
    
    try {
      await todoListRef.set(todoList.toJson());
      } catch (e) {
       print(e);
       rethrow;
      }
  }

  Future<void> deleteTodoList(TodoList todoList) async {
    final todoListRef = _userRef
      .collection('todo_lists').doc(todoList.id);
    
    WriteBatch batch = FirebaseFirestore.instance.batch();
    
    final remindersSnapshots = await _userRef
      .collection('reminders')
      .where('list.id', isEqualTo: todoList.id).get();
    
    remindersSnapshots.docs.forEach((reminder) { 
      // delete the reminder
      batch.delete(reminder.reference);
    });
    
    batch.delete(todoListRef);
    
      try { 
        await batch.commit();
        print('Deleted');
      } catch (e) {
        print(e);
        rethrow;
      }
  }


  Future addReminder({required Reminder reminder}) async {
    var reminderRef = 
      _userRef.collection('reminders').doc();

    reminder.id = reminderRef.id;

    var listRef = 
      _userRef.collection('todo_lists').doc(reminder.list['id']);

    WriteBatch batch = _database.batch();
      batch.set(reminderRef, reminder.toJson());
      batch.update(listRef, {
        'reminder_count': reminder.list['reminder_count'] + 1,
         });
      try {
        await batch.commit();
      } catch (e) {
        print(e);
        rethrow;
      }
  }
  

  Future<void> deleteReminder(Reminder reminder, TodoList todoListForReminder) async {
    // remindersRef used to delete the specified reminder
    final remindersRef = _userRef
      .collection('reminders').doc(reminder.id);
    
    // listRef used to update the reminderCount
    final listRef = _userRef
      .collection('todo_lists').doc(reminder.list['id']);
    
    WriteBatch batch = FirebaseFirestore.instance.batch();
    
    batch.delete(remindersRef);
    batch.update(listRef, {'reminder_count': todoListForReminder.reminderCount - 1});
    
    try {
      await batch.commit();
    } catch(e) {
      print(e);
      rethrow;
    }
  }
}

// 1. Create a variable and store firebase instance
// 2. Create reference to users node in firebase
// 3. Methods required
// - todolist stream
// - reminders stream
// - add TodoList
// - add Reminder
// - delete TodoList
// - delete Raeminder