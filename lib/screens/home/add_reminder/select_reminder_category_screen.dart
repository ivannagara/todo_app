// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_cookbook/models/category.dart';
import 'package:flutter_cookbook/models/category_collection.dart';

class SelectReminderCategoryScreen extends StatelessWidget {
  const SelectReminderCategoryScreen({
    super.key,
    required this.selectedCategory,
    required this.selectCategoryCallback,
    });

  final Category selectedCategory;
  final Function(Category) selectCategoryCallback;

  @override
  Widget build(BuildContext context) {
    var categories = CategoryCollection().categories;
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Category'),
        ),
        body: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final item = categories[index];
            if (categories[index].id == 'all') {
              return Container();
            }
            return ListTile(
              onTap: () {
                selectCategoryCallback(item);
                Navigator.pop(context);
              },
              title: Text(item.name),
              trailing: selectedCategory == categories[index] 
                ? Icon(Icons.check) 
                : null,
            );
          },
          ),
    );
  }
}