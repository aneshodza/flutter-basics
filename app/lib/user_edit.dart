import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/objects/user.dart';

var client = http.Client();

class EditPage extends StatefulWidget {
  final String username;
  final String userId;

  const EditPage({Key? key, required this.username, required this.userId})
      : super(key: key);

  @override
  State<EditPage> createState() => _EditPage();
}

class _EditPage extends State<EditPage> {
  final _formKey = GlobalKey<FormState>();
  late Future<User> userFuture;

  @override
  void initState() {
    super.initState();
    userFuture = _fetchUser();
  }

  Future<User> _fetchUser() async {
    final response = await client
        .get(Uri.parse('http://localhost:3000/user/${widget.userId}'));
    var data = jsonDecode(response.body);
    return User.fromMap(data['user']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.username),
        ),
        body: Center(
            child: FractionallySizedBox(
          widthFactor: 0.5,
          child: FutureBuilder<User>(
            future: userFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('No data found'));
              } else {
                User user = snapshot.data!;
                return formBuilder(user);
              }
            },
          ),
        )));
  }

  Form formBuilder(User user) {
    void updateUser(User user) async {
      final response = await client.patch(
        Uri.parse('http://localhost:3000/user/${user.userId}'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'username': user.username,
          'email': user.email,
        }),
      );

      if (response.statusCode == 200) {
        print('User updated successfully.');
      } else {
        print('Failed to update user. ${response.statusCode}');
      }
    }

    void _saveForm() {
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        _formKey.currentState!.save();
        print(
            'Username: ${user.username}, Email: ${user.email} are the new values for id ${widget.userId}');
        updateUser(user);
        // Now you can use username and email as they are populated
      }
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Username'),
                  initialValue: user.username,
                  onSaved: (value) {
                    user.username = value!;
                  },
                ),
              )),
              Expanded(
                child: TextFormField(
                  decoration: const InputDecoration(labelText: 'Email'),
                  initialValue: user.email,
                  onSaved: (value) {
                    user.email = value!;
                  },
                ),
              ),
            ],
          ),
          Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _saveForm();
                      },
                      child: const Text("Submit"))
                ],
              ))
        ],
      ),
    );
  }
}
