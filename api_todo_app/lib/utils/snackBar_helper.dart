import 'package:flutter/material.dart';

void showSuccessMessage(BuildContext context, {required String mgs}) {
  final snackBar = SnackBar(
    content: Text(mgs),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
