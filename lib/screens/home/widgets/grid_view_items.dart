// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_cookbook/models/category.dart';
import 'package:flutter_cookbook/models/reminder/reminder.dart';
import 'package:flutter_cookbook/screens/view_list/view_list_by_category_screen.dart';
import 'package:provider/provider.dart';


class GridViewItems extends StatelessWidget {
  const GridViewItems({required this.categories});

  final List<Category> categories; // list of 4 categories

  @override
  Widget build(BuildContext context) {
    final allReminders = Provider.of<List<Reminder>>(context);
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 2,
      childAspectRatio: 16/9,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      padding: EdgeInsets.all(10),
      children: categories.map( // Use children because there are ore than one categories
        (category) => InkWell(
          onTap: getCategoryCount(id: category.id, allReminders: allReminders) > 0 ? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => 
                  ViewListByCategoryScreen(category: category),
                  ),
                );
          } : null,
          child: Ink(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(10),
              ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      category.icon,
                      Text(
                        getCategoryCount(
                          id: category.id,
                          allReminders: allReminders)
                          .toString(),
                        style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.headline5,
                    ),
                ],
              ),
            ),
          ),
        ),
      ).toList(), // Convert to list because 'children' only accepts list type '[]'
    );
  }
  
  int getCategoryCount({required String id, required List<Reminder>? allReminders}) {
    if (id == 'all' && allReminders != null) {
      return allReminders.length;
    } 

    final categories = allReminders?.where((reminder) => reminder.categoryId == id);

    if (categories != null) {
      return categories.length;
    }
    return 0;
  }
}
