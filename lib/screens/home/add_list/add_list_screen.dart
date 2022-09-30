// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/common/helpers/helpers.dart' as helpers;
import 'package:flutter_cookbook/models/common/custom_color.dart';
import 'package:flutter_cookbook/models/common/custom_color_collection.dart';
import 'package:flutter_cookbook/models/common/custom_icon.dart';
import 'package:flutter_cookbook/models/common/custom_icon_collection.dart';
import 'package:flutter_cookbook/models/todo_list/todo_list.dart';
import 'package:flutter_cookbook/services/database-service.dart';
import 'package:provider/provider.dart';

class AddListScreen extends StatefulWidget {
  @override
  _AddListScreenState createState() => _AddListScreenState();
}

class _AddListScreenState extends State<AddListScreen> {

  CustomColor _selectedColor = CustomColorCollection().colors.first;
  CustomIcon _selectedIcon = CustomIconCollection().icons.first;

  String _listName = '';

  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _textController.addListener((){
      setState(() {
        _listName = _textController.text;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _textController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New List'),
        actions: 
        [
          TextButton(
            onPressed: _listName.isEmpty ? null : () async {
              if(_textController.text.isNotEmpty){
                final user = Provider.of<User?>(context, listen: false);
                 //id of the list
                
                final newTodoList = TodoList(
                    id: null,
                    title: _textController.text,
                    icon: {"id": _selectedIcon.id, "color":_selectedColor.id},
                    reminderCount: 0,
                    );
                try { 
                  DatabaseService(uid: user!.uid)
                    .addTodoList(todoList: newTodoList);
                    helpers.showSnackBar(context, "List Added");
                } catch(e) {
                  helpers.showSnackBar(context, "Unable to delete list");
                }

                Navigator.pop(context);
              } else {
                print('Please input a name');
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
      
            // Container for Result Icon
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _selectedColor.color,
              ),
              padding: EdgeInsets.all(10),
              child: Icon(_selectedIcon.icon, size: 75),
            ),
      
            // Give spacing between previous and after container
            SizedBox(height: 20),
      
            // Container for TextField
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                ),
              child: TextField(
                controller: _textController,
                autofocus: true,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
                // Decorations for text field
                decoration: InputDecoration(
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    onPressed: () {
                      _textController.clear();
                    },
                    icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).primaryColor,
                        ),
                      // 'x' clear icon inside the textfield box
                      child: Icon(Icons.clear),
                      ),
                  ),
                  ),
              ),
            ),
      
            // Used to space the previous and next widget
            SizedBox(height: 10),
      
            // Used to contain the circular color choices
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for (final customColor in CustomColorCollection().colors)
                // Logic to change Resulting Icon's color when tapped
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedColor = customColor;
                    });
                  },
                  // Logic to display all of the colors inside of the collection
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      border: _selectedColor.id == customColor.id
                        ? Border.all(color: Colors.grey[300]!,
                        width: 5) : null,
                      shape: BoxShape.circle,
                      color: customColor.color,
                    ),
                  ),
                )
              ],
            ),
      
            SizedBox(height: 10),
      
            // Used to contain the circular icons
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                for(final customIcon in CustomIconCollection().icons)
                GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedIcon = customIcon;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: _selectedIcon.id == customIcon.id 
                        ? Border.all(color: Colors.grey[300]!,
                        width: 5) : null,
                      shape: BoxShape.circle,
                      color: Theme.of(context).cardColor,
                    ), 
                    child: Icon(customIcon.icon),
                  ),
                ),
              ],
              ),
          ],
        ),
      ),
    );
  }
}