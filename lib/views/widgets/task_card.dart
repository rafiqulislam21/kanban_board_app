import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';
import 'package:kanban_board_app/models/board_model.dart';
import 'package:kanban_board_app/utils/helper.dart';
import 'package:kanban_board_app/views/components/delete_dialog.dart';
import 'package:kanban_board_app/views/components/task_add_edit.dart';
import 'package:kanban_board_app/views/widgets/custom_icon_button.dart';

class TaskCard extends StatefulWidget {
  TaskCard({
    super.key,
    required this.col,
    required this.task,
  });

  final BoardModel col;
  final Tasks task;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  final BoardController boardController = Get.find();
  late ConfettiController _controllerCenter;

  @override
  void initState() {
    super.initState();
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controllerCenter.dispose();
    super.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive,
                shouldLoop:
                false,
                numberOfParticles: 5,
                createParticlePath: drawStar, // define a custom shape/path.
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(
                    child: Text(
                  widget.task.title!,
                  style: const TextStyle(fontSize: 18),
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomIconButton(
                      icon: Icons.done_all_rounded,
                      color: widget.task.completedAt == null ? Colors.grey : Colors.green,
                      onPressed: () {
                        _controllerCenter.play();
                        boardController.completeTask(task: widget.task);
                      },
                    ),
                    CustomIconButton(
                      icon: Icons.edit,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return TaskAddEdit(
                              column: widget.col,
                              task: widget.task,
                            );
                          },
                        );
                      },
                    ),
                    CustomIconButton(
                      icon: Icons.delete_forever,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DeleteDialog(
                                title: "This task will deleted forever.",
                                onSuccess: () async {
                                  await boardController
                                      .deleteTask(columnId: widget.col.id!,taskId: widget.task.id!);
                                  Navigator.pop(context);
                                },
                              );
                            });
                      },
                    ),
                  ],
                )
              ],
            ),
            Text(
              widget.task.description!,
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
                        " ${Jiffy(widget.task.createdAt).fromNow()}",
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
                        " ${Jiffy(widget.task.updatedAt).fromNow()}",
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
                widget.task.completedAt == null
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
                              " ${Helper.timeDifference(start: widget.task.createdAt, end: widget.task.completedAt)}",
                              style: const TextStyle(
                                  fontSize: 10, color: Colors.grey),
                            )),
                          ],
                        ),
                      ),
                widget.task.completedAt == null
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
                              " ${Jiffy(widget.task.completedAt).fromNow()}",
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
