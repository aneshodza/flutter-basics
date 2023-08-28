import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

var client = http.Client();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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

  @override
  void initState() {
    super.initState();
    _fetchUserCount();
  }

  void _fetchUserCount() async {
    try {
      final response = await client.get(Uri.parse('http://localhost:3000/users/count'));

      if (response.statusCode == 200) {
        // If server returns a 200 OK response, parse the JSON.
        var data = jsonDecode(response.body);
        setState(() {
            _counter = data['users_count'];
            });
      } else {
        // If the server returns an error, throw an exception.
        print('Failed to load count');
      }
    } catch (e) {
      // Handle any exceptions thrown during the request.
      print('Error: $e');
    }
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
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
                  size: Theme.of(context).textTheme.headlineMedium!.fontSize!,
                  semanticLabel: 'Text to announce in accessibility modes',
                  ),
                )
            ],
            ),
          ],
          ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _fetchUserCount,
          tooltip: 'Increment',
          child: const Icon(Icons.cached),
          ),
      );
  }
}
