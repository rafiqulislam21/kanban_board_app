import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';
import 'package:kanban_board_app/models/board_model.dart';
import 'package:kanban_board_app/views/widgets/custom_textfield.dart';

class TaskAddEdit extends StatefulWidget {
  final BoardController boardController = Get.find();
  final BoardModel column;
  final Tasks? task;

  TaskAddEdit({super.key, this.task, required this.column});

  @override
  State<TaskAddEdit> createState() => _TaskAddEditState();
}

class _TaskAddEditState extends State<TaskAddEdit> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController taskTitleController;
  late TextEditingController taskDescriptionController;

  @override
  void initState() {
    taskTitleController = TextEditingController(text: widget.task?.title);
    taskDescriptionController = TextEditingController(text: widget.task?.description);
    super.initState();
  }

  @override
  void dispose() {
    taskTitleController.dispose();
    taskDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.task == null ? 'Add Task' : ' Edit Task'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              hintText: "Task title",
              controller: taskTitleController,
              required: true,
            ),
            CustomTextField(
              hintText: "Task description",
              controller: taskDescriptionController,
              maxLines: 2,
              required: false,
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.close),
          color: Colors.red,
        ),
        IconButton(
          onPressed: () async {
            // Validate returns true if the form is valid, or false otherwise.
            if (_formKey.currentState!.validate()) {
              if (widget.task == null) {
                await widget.boardController
                    .addTask(title: taskTitleController.text, description: taskDescriptionController.text, column: widget.column);
              } else {
                await widget.boardController
                    .editTask(title: taskTitleController.text, description: taskDescriptionController.text, task: widget.task!);
              }
              taskTitleController.clear();
              Navigator.pop(context);
            }
          },
          icon: const Icon(Icons.check),
          color: Colors.green,
        ),
      ],
    );
  }
}
