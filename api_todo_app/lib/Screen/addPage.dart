import 'package:api_todo_app/Services/api_services.dart';
import 'package:api_todo_app/utils/snackBar_helper.dart';
import 'package:flutter/material.dart';

class AddPage extends StatefulWidget {
  final Map? todo;
  const AddPage({this.todo, super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  bool isEdit = false;

  @override
  void initState() {
    final todo = widget.todo;
    if (todo != null) {
      isEdit = true;
      final title = todo['title'];
      final descripation = todo['description'];
      titleController.text = title;
      descripationController.text = descripation;
    }
    super.initState();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descripationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "Edit Page" : "Add Todo Details"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "title"),
          ),
          TextField(
            controller: descripationController,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(hintText: "Description"),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              isEdit ? updateData() : submitButton();
            },
            child: Text(isEdit ? "Edit" : "Add"),
          ),
        ],
      ),
    );
  }

  Future<void> submitButton() async {
    final title = titleController.text;
    final description = descripationController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": true
    };

    final isSucess = await TodoServices.addTodo(body);

    if (isSucess) {
      titleController.text = '';
      descripationController.text = '';
      show();
    } else {
      showError();
    }
  }

  Future<void> updateData() async {
    final todo = widget.todo;
    if (todo == null) {
      print("you can not call updated");
      return;
    }
    final id = todo['_id'];
    final title = titleController.text;
    final description = descripationController.text;
    final body = {
      "title": title,
      "description": description,
      "is_completed": false
    };
    final isSucess = await TodoServices.updateTodo(id, body);

    if (isSucess) {
      show();
    } else {
      showError();
    }
  }

  void show() {
    showSuccessMessage(context, mgs: "Success");
  }

  void showError() {
    showSuccessMessage(context, mgs: "Not valid");
  }
}
