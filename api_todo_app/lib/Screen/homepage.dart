import 'dart:convert';

import 'package:api_todo_app/Screen/addPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isloading = true;
  List items = [];
  @override
  void initState() {
    fetchTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo REST API"),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isloading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Text("${index + 1}"),
                title: Text(item['title']),
                subtitle: Text(item['description']),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigatorToAdd();
        },
        label: Text("Add"),
      ),
    );
  }

  Future<void> fetchTodo() async {
    final url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(url);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result;
      });
    } else {
      showSuccessMessage("Not loading");
    }
    setState(() {
      isloading = false;
    });
  }

  void showSuccessMessage(String mgs) {
    final snackBar = SnackBar(
      content: Text(mgs),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void navigatorToAdd() {
    final route = MaterialPageRoute(
      builder: (context) => AddPage(),
    );

    Navigator.push(context, route);
  }
}
