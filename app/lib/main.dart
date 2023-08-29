import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quiver/iterables.dart';

var client = http.Client();

void main() {
  runApp(const MyApp());
}

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
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Widget> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUserContent();
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

  void mapUserList(List chunkedUsers) {
    setState(() {
      _users = chunkedUsers
          .map(<Iterable>(userRow) {
            List neededPads = List<Widget>.filled((3 - userRow.length) as int, VerticalDivider());
            return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: userRow.map((user) {
                  return Column(children: [Text(user['name'])]);
                }).toList().cast<Widget>() + neededPads);
          })
          .toList()
          .cast<Widget>();
    });
  }

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
}
