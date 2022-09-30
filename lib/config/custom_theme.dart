import 'package:flutter/material.dart';

class CustomTheme extends ChangeNotifier {
  
  bool _isDarkTheme = true;

  ThemeMode currentTheme() {
    if(_isDarkTheme) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  void toggleTheme(){
    _isDarkTheme = !_isDarkTheme;
    notifyListeners();
  }


  ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(color: Colors.black),
      brightness: Brightness.dark,
      textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.blueAccent,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        ),
      ),
      // iconTheme: IconThemeData(
      // color: Colors.white,
      // ),
      accentColor: Colors.white,
      cardColor: Color(0xFF1A191D),
      dividerColor: Colors.grey[600],
  );


  ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Color(0xFFeeeeee),
      appBarTheme: AppBarTheme(
        color: Color(0xFFeeeeee),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        ),
      primaryColor: Color(0xFFeeeeee),
      iconTheme: IconThemeData(color: Colors.black),
      brightness: Brightness.light,
      textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: Colors.blueAccent,
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: StadiumBorder(),
        ),
      ),
      // iconTheme: IconThemeData(color: Colors.white),
      accentColor: Colors.black,
  );
}