import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'YukNonton',
          style: TextStyle(
            color: Colors.red,
            fontFamily: 'Poppins',
            fontSize: 24.0,
          ),
        ),
      ),
      body: Center(
        child: Text('Welcome to YukNonton'),
      ),
    );
  }
}
