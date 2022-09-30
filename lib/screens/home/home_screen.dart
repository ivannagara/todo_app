// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/config/custom_theme.dart';
import 'package:flutter_cookbook/models/category_collection.dart';
import 'package:flutter_cookbook/screens/home/widgets/footer.dart';
import 'package:flutter_cookbook/screens/home/widgets/grid_view_items.dart';
import 'package:flutter_cookbook/screens/home/widgets/list_view_items.dart';
import 'package:flutter_cookbook/screens/home/widgets/todolists.dart';
import 'package:provider/provider.dart';



class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CategoryCollection categoryCollection = CategoryCollection();

  String layoutType = 'grid';

  @override
  Widget build(BuildContext context) {
          return Scaffold(
          appBar: AppBar(actions: [
            IconButton(
              onPressed: (){
                final customTheme = Provider.of<CustomTheme>(context, listen: false);
                customTheme.toggleTheme();
              },
              icon: Icon(Icons.wb_sunny),
              ),


            IconButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
                // navigate user back to auth screen
              },
              icon: Icon(Icons.logout)),

            TextButton(
              onPressed: () {
                if (layoutType == 'grid') {
                  setState(() {
                    layoutType = 'list';
                  });
                } else {
                  setState(() {
                    layoutType = 'grid';
                  });
                }
              },
            child: Text(
              layoutType == 'grid' ? 'Edit' : 'Done',
              // style: TextStyle(color: Colors.white),
                ),
              ),
            ]),
          body: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    AnimatedCrossFade(
                      duration: Duration(milliseconds: 300),
                      crossFadeState: layoutType == 'grid' ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                      firstChild: GridViewItems(categories: categoryCollection.selectedCategories),
                      secondChild: ListViewItems(categoryCollection: categoryCollection),
                      ),
                    TodoLists(),
                  ],
                ),
              ),
              Footer(),
            ],
          ),
        );
      }
    }


