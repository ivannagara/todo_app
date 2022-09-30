// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/common/helpers/helpers.dart' as helpers;
import 'package:flutter_cookbook/common/widgets/category_icon.dart';
import 'package:flutter_cookbook/common/widgets/dismissible_background.dart';
import 'package:flutter_cookbook/models/common/custom_color_collection.dart';
import 'package:flutter_cookbook/models/common/custom_icon_collection.dart';
import 'package:flutter_cookbook/models/todo_list/todo_list.dart';
import 'package:flutter_cookbook/screens/view_list/view_list_screen.dart';
import 'package:flutter_cookbook/services/database-service.dart';
import 'package:provider/provider.dart';

class TodoLists extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final todoLists = Provider.of<List<TodoList>>(context);
    final user = Provider.of<User?>(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text('My Lists', style: Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(fontWeight: FontWeight.bold)
            ),
          SizedBox(height: 10),
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: todoLists.length,
              itemBuilder: (context, index) {
              return Dismissible(
                onDismissed: (direction) async {
                  try {
                  await DatabaseService(uid: user!.uid)
                    .deleteTodoList(todoLists[index]);
                  helpers.showSnackBar(context, "List Deleted"); 
                  } catch (e) {
                    helpers.showSnackBar(context, "Unable to delete List");
                  }
                  
                },
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                background: DimissibleBackground(),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    onTap: todoLists[index].reminderCount > 0 ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => 
                          ViewListScreen(todoList: todoLists[index]),
                          ),
                        );
                    } : null,
                    leading: CategoryIcon(
                      bgColor: (CustomColorCollection().findColorById(
                        todoLists[index].icon['color']).color),
                      iconData: (CustomIconCollection().findIconById(
                        todoLists[index].icon['id']).icon),
                      ),
                    title: Text(todoLists[index].title),
                    trailing: Text(
                      todoLists[index].reminderCount.toString(),
                      style: Theme.of(context)
                        .textTheme.bodyText2!
                        .copyWith(fontWeight: FontWeight.bold),
                      ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
