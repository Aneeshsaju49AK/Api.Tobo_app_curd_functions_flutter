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
            onPressed: () {},
            child: Text("Add"),
          ),
        ],
      ),
    );
  }

  Future<void> submitButton() async {
    final title = titleController.text;
    final description = descripationController.text;

    final url = "https://api.nstack.in/v1/todos?page=1&limit=10";

    final uri = Uri.parse(url);
    final respone = await http.post(uri);
  }
}
