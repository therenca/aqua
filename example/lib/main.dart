import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aqua Usage',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AquaUsage(),
    );
  }
}

class AquaUsage extends StatefulWidget {
  @override
  AquaUsageState createState() => AquaUsageState();
}

class AquaUsageState extends State<AquaUsage> {
  Widget _buildAquaUsage(BuildContext context) {
    return ListView(
      children: [],
    );
  }

  @override
  Widget build(BuildContext context) => _buildAquaUsage(context);
}
