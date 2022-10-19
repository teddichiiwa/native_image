import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// [MyApp]
class MyApp extends StatefulWidget {
  /// Constructor
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Native Image Plugin example'),
        ),
        body: const Center(
          child: Text('...'),
        ),
      ),
    );
  }
}
