import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_io/io.dart';
import 'package:flutter/services.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  State<MyRegister> createState() => _MyRegisterState();
}

class _MyRegisterState extends State<MyRegister> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();

  String? _nameErrorText;
  String? _emailErrorText;
  String? _passwordErrorText;
  String? _confirmPasswordErrorText;

  Future<void> saveUserData() async {
    try {
      final userData = {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      };
      if (Platform.isAndroid || Platform.isIOS) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        File jsonFile = File('${appDocDir.path}/user_data.json');
        await jsonFile.writeAsString(jsonEncode(userData));
        Navigator.pushNamed(context, 'sucess');
        print('User data saved successfully to file!');
      } else if (kIsWeb) {
        html.window.localStorage['user_data'] = jsonEncode(userData);
        Navigator.pushNamed(context, 'sucess');
        print('User data saved successfully to web storage!');
      } else {
        // if for any otgher platform
      }
    } catch (e) {
      // Handle errors
      print('Error saving user data: $e');
    }
  }

  Future<void> signin() async {
    String? nameError = _validateName(nameController.text);
    String? emailError = _validateEmail(emailController.text);
    String? passwordError = _validatePassword(passwordController.text);
    String? confirmPasswordError =
        _validatePasswordConfirm(passwordConfirmController.text);

    setState(() {
      _nameErrorText = nameError;
      _emailErrorText = emailError;
      _passwordErrorText = passwordError;
      _confirmPasswordErrorText = confirmPasswordError;
    });

    if (nameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      saveUserData();
    }
  }

  String? _validateName(String? value) {
    if (value == null ||
        value.isEmpty ||
        !RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
      return 'Enter a valid name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null ||
        value.isEmpty ||
        !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
            .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    // Add your password validation logic here
    if (value == null || value.isEmpty) {
      return 'Enter a valid password';
    }
    return null;
  }

  String? _validatePasswordConfirm(String? value) {
    // Add your password confirmation validation logic here
    if (value == null || value.isEmpty || value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyle(color: Colors.purple, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 500),
            child: Center(
              child: Text(
                'Create\naccount',
                style: TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Colors.purple,
                    fontSize: 33),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 150, right: 35, left: 35),
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: _nameErrorText,
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return 'Enter a valid name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: _emailErrorText,
                    ),
                    validator: (value) {
                      if (value!.isEmpty ||
                          !RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                              .hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: _passwordErrorText,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter a valid password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    controller: passwordConfirmController,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Confirm password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      errorText: _confirmPasswordErrorText,
                    ),
                    validator: (value) {
                      if (value!.isEmpty || value != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sign-up',
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
                          onPressed: signin,
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ),
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
                          Navigator.pushNamed(context, 'login');
                        },
                        child: Text(
                          'log in',
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
          )
        ],
      ),
    );
  }
}
