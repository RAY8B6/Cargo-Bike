import 'package:flutter/material.dart';

class AlertDialogWidget extends StatefulWidget {
  const AlertDialogWidget(
      {Key? key, required this.title, required this.content})
      : super(key: key);

  final String title;
  final String content;

  @override
  State<AlertDialogWidget> createState() => _AlertDialogWidgetState();
}

class _AlertDialogWidgetState extends State<AlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("uu"),
      content: const Text("Incorrect email or password"),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context, "Ok"),
            child: const Text("Ok"))
      ],
    );
  }
}
