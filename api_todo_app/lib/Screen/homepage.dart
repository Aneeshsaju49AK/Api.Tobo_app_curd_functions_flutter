import 'package:api_todo_app/Screen/addPage.dart';
import 'package:api_todo_app/Services/api_services.dart';
import 'package:api_todo_app/utils/snackBar_helper.dart';
import 'package:api_todo_app/widget/todo_card.dart';
import 'package:flutter/material.dart';

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
        title: const Text("Todo REST API"),
        centerTitle: true,
      ),
      body: Visibility(
        visible: isloading,
        child: Center(child: CircularProgressIndicator()),
        replacement: RefreshIndicator(
          onRefresh: fetchTodo,
          child: Visibility(
            visible: items.isNotEmpty,
            replacement: const Center(
              child: Text("No data"),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];

                return TodoCard(
                  index: index,
                  item: item,
                  navigationEdit: navigatorToEdit,
                  deleteById: deleteById,
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          navigatorToAdd();
        },
        label: const Text("Add"),
      ),
    );
  }

  Future<void> fetchTodo() async {
    final response = await TodoServices.fetchTodo();

    if (response != null) {
      setState(() {
        items = response;
      });
    } else {
      showSuccessMessage(context, mgs: "something went wrong");
    }
    setState(() {
      isloading = false;
    });
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

  Future<void> deleteById(String id) async {
    final isSuccess = await TodoServices.deleteById(id);
    if (isSuccess) {
      final filltered = items.where((element) => element['_id'] != id).toList();
      setState(() {
        items = filltered;
      });
    } else {
      showSuccessMessage(context, mgs: "Not deleted");
    }
  }
}
