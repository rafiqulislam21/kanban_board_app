import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';
import 'package:kanban_board_app/models/board_model.dart';
import 'package:kanban_board_app/views/components/task_add_edit.dart';

class TaskCard extends StatelessWidget {
  TaskCard({
    super.key,
    required this.col,
    required this.task,
  });

  final BoardModel col;
  final Tasks task;
  final BoardController boardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Text(
                  task.title!,
                  style: const TextStyle(fontSize: 18),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(0.0),
                      width: 20.0,
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return TaskAddEdit(column: col, task: task,);
                              },
                            );
                          },
                          padding: const EdgeInsets.all(0),
                          iconSize: 16,
                          color: Colors.blue,
                          icon: const Icon(Icons.edit)),
                    ),
                    Container(
                      padding: const EdgeInsets.all(0.0),
                      width: 20.0,
                      child: IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Are you sure?'),
                                  content: const Text(
                                      "The column will be deleted forever."),
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
                                        // await boardController
                                        //     .deleteColumn(col.id!);
                                        // Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.check),
                                      color: Colors.green,
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          padding: const EdgeInsets.all(0),
                          iconSize: 16,
                          color: Colors.red,
                          icon: const Icon(Icons.delete_forever)),
                    ),
                  ],
                )
              ],
            ),
            Text(
              task.description!,
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(
                        Icons.create_new_folder_outlined,
                        size: 12,
                        color: Colors.grey,
                      ),
                      Flexible(
                          child: Text(
                        " ${Jiffy(task.createdAt).fromNow()}",
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      )),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.edit,
                        size: 12,
                        color: Colors.grey,
                      ),
                      Flexible(
                          child: Text(
                        " ${Jiffy(task.createdAt).fromNow()}",
                        style:
                            const TextStyle(fontSize: 10, color: Colors.grey),
                      )),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                task.duration == null
                    ? const SizedBox()
                    : Expanded(
                        child: Row(
                          children: [
                            const Icon(
                              Icons.watch_later_outlined,
                              size: 12,
                              color: Colors.grey,
                            ),
                            Flexible(
                                child: Text(
                              " ${task.duration ?? "-"}",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            )),
                          ],
                        ),
                      ),
                task.duration == null
                    ? const SizedBox()
                    : Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(
                              Icons.done_all_rounded,
                              size: 12,
                              color: Colors.grey,
                            ),
                            Flexible(
                                child: Text(
                              " ${Jiffy(task.completedAt).fromNow()}",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            )),
                          ],
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
