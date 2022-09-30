// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_cookbook/models/category_collection.dart';

const LIST_VIEW_HEIGHT = 70.0;

class ListViewItems extends StatefulWidget {
  final CategoryCollection categoryCollection;

  ListViewItems({required this.categoryCollection});

  @override
  State<ListViewItems> createState() => _ListViewItemsState();
}

class _ListViewItemsState extends State<ListViewItems> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.categoryCollection.categories.length * LIST_VIEW_HEIGHT + LIST_VIEW_HEIGHT,
      child: ReorderableListView(
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {
            newIndex = newIndex - 1;
          }

          final item = widget.categoryCollection.removeItem(oldIndex);
          setState(() {
            widget.categoryCollection.insert(newIndex, item);
          });
        },


        children: widget.categoryCollection.categories.map(
          (category) => SizedBox(
            key: UniqueKey(),
            height: LIST_VIEW_HEIGHT,
            child: ListTile(
              onTap: () {
                // toggle checkbox
                setState(() {
                  category.toggleCheckbox();
                });
              },
              tileColor: Theme.of(context).cardColor,
              leading: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: category.isChecked
                    ? Colors.blueAccent
                    : Colors.grey,
                  ),
                  color: category.isChecked
                  ? Colors.blueAccent
                  : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(2),
                child: Icon(
                  Icons.check,
                  color: category.isChecked 
                  ? Colors.white 
                  : Colors.transparent),
                ),
              title: Row(
                children: [
                  category.icon,
                  SizedBox(width: 10),
                  Text(category.name),
                ],
              ),
              trailing: Icon(Icons.reorder),
              ),
          ),
          ).toList(),
      ),
    );
  }
}