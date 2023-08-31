import 'dart:convert';

import 'package:app/objects/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/iterables.dart';

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

  Row mapUserRow(List userRow) {
    List<Widget> neededPads =
        List<Widget>.filled(3 - userRow.length, const VerticalDivider());
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: userRow
                .map((user) {
                  return userView(User.fromMap(user));
                })
                .toList()
                .cast<Widget>() +
            neededPads);
  }

  Row userView(User user) {
    return Row(children: [
      SizedBox(
        width: 64,
        height: 64,
        child: Image(image: NetworkImage(user.avatar), fit: BoxFit.contain),
      ),
      Text(user.username),
    ]);
  }

  void _fetchUserContent() async {
    _fetchUserCount();
    _fetchUserList();
  }

  void _fetchUserCount() async {
    final response =
        await client.get(Uri.parse('http://localhost:3000/users/count'));
    var data = jsonDecode(response.body);
    setState(() {
      _counter = data['users_count'];
    });
  }

  void _fetchUserList() async {
    final response = await client.get(Uri.parse('http://localhost:3000/users'));

    var data = jsonDecode(response.body);
    mapUserList(partition(data['users'], 3).toList());
  }
}
