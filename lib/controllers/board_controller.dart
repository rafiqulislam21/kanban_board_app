import 'dart:convert';

import 'package:get/get.dart';
import 'package:kanban_board_app/models/board_model.dart';
import 'package:kanban_board_app/utils/local_storage_utils.dart';

class BoardController extends GetxController {
  final columnList = <BoardModel>[].obs;

  @override
  void onInit() {
    getColumns();
    super.onInit();
  }

  int uuid() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch;
  }

  Future addColumn({required String title}) async {
    int id = uuid();
    BoardModel column = BoardModel(id: id, title: title, tasks: []);
    columnList.add(column);
    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }

    LocalStorageUtil.write("columns", jsonEncode(columnJson));

    columnList.refresh();
  }

  Future editColumn({required String title, required BoardModel column}) async {
    // updating values
    column.title = title;

    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }
    LocalStorageUtil.write("columns", jsonEncode(columnJson));
    //
    columnList.refresh();
  }

  Future getColumns() async {
    var columnsStr = await LocalStorageUtil.read("columns");
    List columns = jsonDecode(columnsStr ?? "[]");
    print(columns);
    // List _listData = [
    //   {
    //     "id": 1,
    //     "title": "Todo",
    //     "tasks": [
    //       {
    //         "id": 1,
    //         "title": "task-1",
    //         "description": "task details here",
    //         "created_at": "2.2.2022",
    //         "updated_at": "2.2.2022",
    //         "completed_at": "3.3.2022",
    //         "duration": "5 days",
    //       },
    //       {
    //         "id": 2,
    //         "title": "task-1",
    //         "description": "task details here",
    //         "created_at": "2.2.2022",
    //         "updated_at": "2.2.2022",
    //         "completed_at": "3.3.2022",
    //         "duration": "5 days",
    //       },
    //     ]
    //   },
    //   {
    //     "id": 2,
    //     "title": "In Progress",
    //     "tasks": [
    //       {
    //         "id": 1,
    //         "title": "task-1",
    //         "description": "task details here",
    //         "created_at": "2.2.2022",
    //         "updated_at": "2.2.2022",
    //         "completed_at": "3.3.2022",
    //         "duration": "5 days",
    //       },
    //     ]
    //   },
    //   {
    //     "id": 3,
    //     "title": "Done",
    //     "tasks": [
    //       {
    //         "id": 1,
    //         "title": "task-1",
    //         "description": "task details here",
    //         "created_at": "2.2.2022",
    //         "updated_at": "2.2.2022",
    //         "completed_at": "3.3.2022",
    //         "duration": "5 days",
    //       },
    //     ]
    //   }
    // ];
    //
    for (var item in columns) {
      columnList.add(BoardModel.fromJson(item));
    }
  }

  Future deleteColumn(int id) async {
    columnList.removeWhere((element) => element.id == id);
    LocalStorageUtil.write("columns", jsonEncode(columnList));
  }

  Future addTask(
      {required String title,
      required String description,
      required BoardModel column}) async {
    int id = uuid();
    DateTime currentTime = DateTime.now();
    Tasks task = Tasks(
        id: id,
        title: title,
        description: description,
        createdAt: currentTime.toString(),
        updatedAt: currentTime.toString());

    column.tasks?.add(task);

    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }

    LocalStorageUtil.write("columns", jsonEncode(columnJson));

    columnList.refresh();
  }

  Future editTask(
      {required String title,
      required String description,
      required Tasks task}) async {
    DateTime currentTime = DateTime.now();
    //update
    task.title = title;
    task.description = description;
    task.updatedAt = currentTime.toString();

    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }

    LocalStorageUtil.write("columns", jsonEncode(columnJson));

    columnList.refresh();
  }
}
