import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descripationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Todo Details"),
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(hintText: "title"),
          ),
          TextField(
            controller: descripationController,
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 8,
            decoration: InputDecoration(hintText: "Description"),
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              submitButton();
            },
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  void showSuccessMessage(String mgs) {
    final snackBar = SnackBar(
      content: Text(mgs),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> submitButton() async {
    final title = titleController.text;
    final description = descripationController.text;

    final body = {
      "title": title,
      "description": description,
      "is_completed": true
    };
    final url = "https://api.nstack.in/v1/todos";

    final uri = Uri.parse(url);
    final respone = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );

    if (respone.statusCode == 201) {
      titleController.text = '';
      descripationController.text = '';
      showSuccessMessage("Success");
    } else {
      showSuccessMessage("Not valid");
    }
  }
}
