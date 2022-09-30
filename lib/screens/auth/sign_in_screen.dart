// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_cookbook/screens/home/home_screen.dart';
import 'package:flutter_cookbook/services/auth_service.dart';
import 'package:lottie/lottie.dart';

class SignInScreen extends StatefulWidget {
  final VoidCallback toggleView;

  const SignInScreen({super.key, required this.toggleView});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton.icon(
            onPressed: () {
              widget.toggleView();
            },
            icon: Icon(Icons.person),
            label: Text('Sign Up'),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset('assets/images/calendar.json', width: 175),
            Text(
              'Yet Another Todo List',
              style: Theme.of(context).textTheme.headline6,
              ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  // The reason we use Column is 
                  //we want multiple form fields
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Enter email',
                      ),
                      validator: (value) => 
                        value == null || !value.contains('@') 
                        ? 'Enter an email address' 
                        : null,
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Enter password',
                      ),
                      validator: (value) => value!.length < 6
                        ? 'Enter password of 6 characters minimum' 
                        : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: (() async {
                        if (_formKey.currentState!.validate()) {
                          final user = await AuthService().signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text,
                            );
                          if (user != null) {
                            // Navigate user to home screen
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(builder: (context)=>HomeScreen()));
                          }
                        }
                      }),
                      child: Text('Sign In')),
                  ],
                 ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}