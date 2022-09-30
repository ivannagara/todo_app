// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cookbook/config/custom_theme.dart';
import 'package:flutter_cookbook/screens/wrapper.dart';
import 'package:provider/provider.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override // Just tells us that the Widget build(...) method exists in the parent class or super class; in this case is the 'StatelessWidget' class. We override the methods of the parent class by our own codes by writing it below.
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('An error has occured'),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              StreamProvider<User?>.value(
              value: FirebaseAuth.instance.authStateChanges(),
              // 'initialData' is used so that if the user is logged in,
              // When we restarted the app, we dont see a glimpse of the 
              // login form page again.
              initialData: FirebaseAuth.instance.currentUser,
              ),

              ChangeNotifierProvider(create: (context) => CustomTheme()),
            ],
            child: Wrapper()
          );
      }
      return CircularProgressIndicator();
    },
  );
  }
}
