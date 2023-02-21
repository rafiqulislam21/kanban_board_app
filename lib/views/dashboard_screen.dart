import 'package:boardview/board_item.dart';
import 'package:boardview/board_list.dart';
import 'package:boardview/boardview.dart';
import 'package:boardview/boardview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jiffy/jiffy.dart';
import 'package:get/get.dart';
import 'package:kanban_board_app/controllers/board_controller.dart';
import 'package:kanban_board_app/views/components/column_add_edit.dart';
import 'package:kanban_board_app/views/components/task_add_edit.dart';
import 'package:kanban_board_app/views/widgets/custom_app_bar.dart';
import 'package:kanban_board_app/views/widgets/custom_drawer.dart';
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
                        onStartDragList: (int? listIndex) {},
                        onTapList: (int? listIndex) async {},
                        onDropList: (int? listIndex, int? oldListIndex) {
                          //Update our local list data
                          var list = boardController.columnList[oldListIndex!];
                          boardController.columnList.removeAt(oldListIndex);
                          boardController.columnList.insert(listIndex!, list);
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
                          IconButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return TaskAddEdit(column: col);
                                  },
                                );
                              },
                              color: Colors.green,
                              icon: const Icon(Icons.add)),
                          IconButton(
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
                              color: Colors.blue,
                              icon: const Icon(Icons.edit)),
                          IconButton(
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
                                            await boardController
                                                .deleteColumn(col.id!);
                                            Navigator.pop(context);
                                          },
                                          icon: const Icon(Icons.check),
                                          color: Colors.green,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              color: Colors.red,
                              icon: const Icon(Icons.delete_forever)),
                        ],
                        items: col.tasks
                            ?.map<BoardItem>((task) => BoardItem(
                                onStartDragItem: (int? listIndex,
                                    int? itemIndex, BoardItemState? state) {},
                                onDropItem: (int? listIndex,
                                    int? itemIndex,
                                    int? oldListIndex,
                                    int? oldItemIndex,
                                    BoardItemState? state) {
                                  //Used to update our local item data
                                  var item = boardController
                                      .columnList[oldListIndex!]
                                      .tasks![oldItemIndex!];
                                  boardController
                                      .columnList[oldListIndex].tasks!
                                      .removeAt(oldItemIndex);
                                  boardController.columnList[listIndex!].tasks!
                                      .insert(itemIndex!, item);
                                },
                                onTapItem: (int? listIndex, int? itemIndex,
                                    BoardItemState? state) async {},
                                item: TaskCard(
                                  col: col,
                                  task: task,
                                )))
                            .toList(),
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
