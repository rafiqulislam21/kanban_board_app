import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';

class DeleteDialog extends StatelessWidget {
  DeleteDialog({
    super.key, required this.onSuccess, required this.title,
  });
  final VoidCallback onSuccess;
  final String? title;

  final BoardController boardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Are you sure?'),
      content: Text(
          title??"The item will be deleted forever."),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          color: Colors.red,
        ),
        IconButton(
          onPressed: onSuccess,
          icon: const Icon(Icons.check),
          color: Colors.green,
        ),
      ],
    );
  }
}