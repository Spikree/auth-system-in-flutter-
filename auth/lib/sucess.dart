import 'package:flutter/material.dart';

class Sucess extends StatefulWidget {
  const Sucess({super.key});

  @override
  State<Sucess> createState() => _SucessState();
}

class _SucessState extends State<Sucess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your app')),
      body: Stack(
        children: [
          Container(),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, 'login');
            },
            child: Text(
              'login',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontSize: 18,
                  color: Colors.grey),
            ),
          )
        ],
      ),
    );
  }
}
