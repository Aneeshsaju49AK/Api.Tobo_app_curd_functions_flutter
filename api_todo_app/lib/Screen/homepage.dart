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
              final id = item['_id'];
              return ListTile(
                leading: CircleAvatar(child: Text("${index + 1}")),
                title: Text(item['title']),
                subtitle: Text(item['description']),
                trailing: PopupMenuButton(
                  onSelected: (value) {
                    if (value == "Edit") {
                      navigatorToEdit(item);
                    } else if (value == "Delete") {
                      delteteById(id);
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text("Edit"),
                        value: "Edit",
                      ),
                      PopupMenuItem(
                        child: Text("Delete"),
                        value: "Delete",
                      ),
                    ];
                  },
                ),
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

  Future<void> navigatorToEdit(Map item) async {
    final route = MaterialPageRoute(
      builder: (context) => AddPage(todo: item),
    );

    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

  Future<void> navigatorToAdd() async {
    final route = MaterialPageRoute(
      builder: (context) => AddPage(),
    );

    await Navigator.push(context, route);
    setState(() {
      isloading = true;
    });
    fetchTodo();
  }

  Future<void> delteteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      showSuccessMessage("delete");
      final filtterd = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filtterd;
      });
    } else {
      showSuccessMessage("Not deleted");
    }
  }
}
