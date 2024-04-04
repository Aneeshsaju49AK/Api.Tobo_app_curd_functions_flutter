import 'package:api_todo_app/Screen/addPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo REST API"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigatorToAdd();
        },
        label: Text("Add"),
      ),
    );
  }

  void navigatorToAdd() {
    final route = MaterialPageRoute(
      builder: (context) => AddPage(),
    );

    Navigator.push(context, route);
  }
}
