import 'package:flutter/material.dart';

class EditPage extends StatelessWidget {
  const EditPage({Key? key, required this.title, required this.userId}) : super(key: key);
  final String title;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: TextButton(
          onPressed: () {},
          child: const Text('Go Back'),
        ),
      ),
    );
  }
}

