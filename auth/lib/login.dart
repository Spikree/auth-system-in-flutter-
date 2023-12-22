import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_io/io.dart' as io;
import 'dart:html' as html;

class MyLogin extends StatefulWidget {
  const MyLogin({super.key});

  @override
  State<MyLogin> createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _emailError;
  String? _passwordError;
  String? _errorMessage;

  Future<Map<String, dynamic>> retrieveUserData() async {
    try {
      if (io.Platform.isIOS || io.Platform.isAndroid) {
        final directory = await getApplicationDocumentsDirectory();
        final file = File('${directory.path}/user_data.json');
        final contents = await file.readAsString();
        return jsonDecode(contents);
      } else if (kIsWeb) {
        if (html.window != null && html.window.localStorage != null) {
          final data = html.window.localStorage['user_data'];
          return jsonDecode(data ?? '{}');
        }
      }
    } catch (e) {
      // Handle errors
      print('Error retrieving user data: $e');
    }

    // Return an empty map if there's an error
    return {};
  }

  Future<void> login() async {
    final userData = await retrieveUserData();
    final enteredEmail = _emailController.text;
    final enteredPassword = _passwordController.text;

    print('Entered email: $enteredEmail');
    print('Stored email: ${userData['email']}');
    print('Entered password: $enteredPassword');
    print('Stored password: ${userData['password']}');

    if (userData['email'] == enteredEmail &&
        userData['password'] == enteredPassword) {
      Navigator.pushNamed(context, 'sucess');
    } else {
      setState(() {
        _errorMessage = 'Incorrect email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 400),
            child: Center(
              child: Text(
                'Welcome\n back',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Colors.purple,
                  fontSize: 33,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 250, right: 35, left: 35),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: _emailError,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(
                              r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                          .hasMatch(value)) {
                        return 'Invalid email format';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: _passwordError,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 8) {
                        return 'The password must be more than 8 characters';
                      }
                      return null;
                    },
                  ),
                  if (_errorMessage != null)
                    Text(
                      _errorMessage!,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          color: Colors.purple,
                        ),
                      ),
                      CircleAvatar(
                        radius: 27,
                        backgroundColor: Colors.purple,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: login,
                          icon: Icon(Icons.arrow_forward),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'register');
                        },
                        child: Text(
                          'Sign up',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, 'forgot');
                        },
                        child: Text(
                          'Forgot password',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 18,
                            color: Colors.purple,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
