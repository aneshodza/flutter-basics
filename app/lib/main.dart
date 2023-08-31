import 'dart:convert';

import 'package:app/objects/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/iterables.dart';
import 'package:app/user_edit.dart';

void main() {
  runApp(const MyApp());
}

var client = http.Client();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User managment App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'User managment App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Widget> _users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: <Widget>[
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 2.5, left: 2.0),
                    child: Icon(
                      Icons.account_circle,
                      color: Colors.black,
                      size:
                          Theme.of(context).textTheme.headlineMedium!.fontSize!,
                      semanticLabel: 'Text to announce in accessibility modes',
                    ),
                  )
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _users),
          )
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetchUserContent,
        tooltip: 'Reload',
        child: const Icon(Icons.cached),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserContent();
  }

  void mapUserList(List chunkedUsers) {
    setState(() {
      _users = chunkedUsers
          .map(<Iterable>(userRow) {
            return mapUserRow(userRow);
          })
          .toList()
          .cast<Widget>();
    });
  }

  Container mapUserRow(List userRow) {
    List<Widget> neededPads =
        List<Widget>.filled(3 - userRow.length, const Spacer());

    return Container(
        padding: const EdgeInsets.only(top: 4.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: userRow
                    .map((user) {
                      return userView(User.fromMap(user));
                    })
                    .toList()
                    .cast<Widget>() +
                neededPads));
  }

  Expanded userView(User user) {
    return Expanded(
        flex: 1,
        child: Row(children: [
          SizedBox(
            width: 64,
            height: 64,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(2.0),
              child:
                  Image(image: NetworkImage(user.avatar), fit: BoxFit.contain),
            ),
          ),
          userViewRight(user),
        ]));
  }

  Container userViewRight(User user) {
    return Container(
        width: 150,
        padding: const EdgeInsets.only(left: 3.0),
        child: Column(children: [
          Text(user.username),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    routeToEdit(user);
                  },
                  child:
                      const Text('edit', style: TextStyle(color: Colors.blue))),
              Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: TextButton(
                      onPressed: () {
                        deleteUser(user);
                      },
                      child: const Text('delete',
                          style: TextStyle(color: Colors.red)))),
            ],
          ),
        ]));
  }

  void _fetchUserContent() async {
    _fetchUserCount();
    _fetchUserList();
  }

  void _fetchUserCount() async {
    final response =
        await client.get(Uri.parse('http://localhost:3000/user/count'));
    var data = jsonDecode(response.body);
    setState(() {
      _counter = data['users_count'];
    });
  }

  void _fetchUserList() async {
    final response =
        await client.get(Uri.parse('http://localhost:3000/user/all'));

    var data = jsonDecode(response.body);
    mapUserList(partition(data['users'], 3).toList());
  }

  void routeToEdit(User user) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return EditPage(title: user.username, userId: user.userId);
    }));
  }

  void deleteUser(User user) async {
    await client.delete(Uri.parse('http://localhost:3000/user/${user.userId}'));

    _fetchUserContent();
  }
}
