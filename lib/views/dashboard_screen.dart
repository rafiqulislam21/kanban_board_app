import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';
import 'package:kanban_board_app/views/components/column_add_edit.dart';
import 'package:kanban_board_app/views/components/delete_dialog.dart';
import 'package:kanban_board_app/views/components/task_add_edit.dart';
import 'package:kanban_board_app/views/widgets/custom_app_bar.dart';
import 'package:kanban_board_app/views/widgets/custom_drawer.dart';
import 'package:kanban_board_app/views/widgets/custom_icon_button.dart';
import 'package:kanban_board_app/views/widgets/task_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  BoardViewController boardViewController = BoardViewController();
  final boardController = Get.put(BoardController());

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Please confirm!'),
      content: const Text('Do you want to exit?'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            'no',
            style: TextStyle(color: Get.theme.primaryColor),
          ),
        ),
        TextButton(
          onPressed: () => SystemNavigator.pop(),
          child: Text(
            'yes',
            style: TextStyle(color: Get.theme.primaryColor),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () => _onWillPop(context),
        child: Scaffold(
          appBar: const CustomAppBar(),
          endDrawer: const CustomDrawer(),
          body: Obx(
            () => BoardView(
              scrollbar: true,
              lists: boardController.columnList
                  .map((col) => BoardList(
                        // onStartDragList: (int? listIndex) {},
                        // onTapList: (int? listIndex) async {},
                        onDropList: (int? listIndex, int? oldListIndex) {
                          boardController.updateColumnPosition(
                              listIndex: listIndex, oldListIndex: oldListIndex);
                        },
                        headerBackgroundColor:
                            Get.theme.primaryColor.withOpacity(0.15),
                        backgroundColor:
                            Get.theme.primaryColor.withOpacity(0.10),
                        header: [
                          Expanded(
                              child: Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Text(
                                    col.title!,
                                    // overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 20),
                                  ))),
                          CustomIconButton(
                            icon: Icons.add,
                            height: 30,
                            width: 30,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return TaskAddEdit(column: col);
                                },
                              );
                            },
                          ),
                          CustomIconButton(
                            icon: Icons.edit,
                            height: 30,
                            width: 30,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ColumnAddEdit(
                                    column: col,
                                  );
                                },
                              );
                            },
                          ),
                          CustomIconButton(
                            icon: Icons.delete_forever,
                            height: 30,
                            width: 30,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return DeleteDialog(
                                    title:
                                        "This column will deleted forever including tasks.",
                                    onSuccess: () async {
                                      await boardController
                                          .deleteColumn(col.id!);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                        items: col.tasks
                            ?.map<BoardItem>((task) => BoardItem(
                                // onStartDragItem: (int? listIndex,
                                //     int? itemIndex, BoardItemState? state) {},
                                // onTapItem: (int? listIndex, int? itemIndex,
                                //     BoardItemState? state) async {},
                                onDropItem: (int? listIndex,
                                    int? itemIndex,
                                    int? oldListIndex,
                                    int? oldItemIndex,
                                    BoardItemState? state) {
                                  boardController.updateTaskPosition(
                                      itemIndex: itemIndex,
                                      listIndex: listIndex,
                                      oldItemIndex: oldItemIndex,
                                      oldListIndex: oldListIndex);
                                },
                                item: TaskCard(
                                  col: col,
                                  task: task,
                                )))
                            .toList(),
                        footer: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomIconButton(
                            icon: Icons.add,
                            height: 30,
                            width: 30,
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return TaskAddEdit(column: col);
                                },
                              );
                            },
                          ),
                        ),
                      ))
                  .toList(),
              boardViewController: boardViewController,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: "Add column",
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ColumnAddEdit();
                },
              );
            },
            child: const Icon(Icons.add),
          ),
        ));
  }
}
