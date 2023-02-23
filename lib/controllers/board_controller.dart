import 'dart:convert';

import 'package:get/get.dart';
import 'package:kanban_board_app/models/board_model.dart';
import 'package:kanban_board_app/utils/local_storage_utils.dart';
import 'package:to_csv/to_csv.dart' as exportCSV;

class BoardController extends GetxController {
  final columnList = <BoardModel>[].obs;
  final String dbName = "columns";

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

    LocalStorageUtil.write(dbName, jsonEncode(columnJson));

    columnList.refresh();
  }

  Future editColumn({required String title, required BoardModel column}) async {
    // updating values
    column.title = title;

    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }
    LocalStorageUtil.write(dbName, jsonEncode(columnJson));
    //
    columnList.refresh();
  }

  Future getColumns() async {
    var columnsStr = await LocalStorageUtil.read(dbName);
    List columns = jsonDecode(columnsStr ?? "[]");
    for (var item in columns) {
      columnList.add(BoardModel.fromJson(item));
    }
  }

  Future deleteColumn(int id) async {
    columnList.removeWhere((element) => element.id == id);
    LocalStorageUtil.write(dbName, jsonEncode(columnList));
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

    LocalStorageUtil.write(dbName, jsonEncode(columnJson));

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

    LocalStorageUtil.write(dbName, jsonEncode(columnJson));

    columnList.refresh();
  }

  Future deleteTask({required int columnId, required int taskId}) async {
    columnList
        .firstWhere((col) => col.id == columnId)
        .tasks
        ?.removeWhere((element) => element.id == taskId);
    LocalStorageUtil.write(dbName, jsonEncode(columnList));
    columnList.refresh();
  }

  Future completeTask({required Tasks task}) async {
    DateTime currentTime = DateTime.now();
    //update
    task.completedAt = currentTime.toString();

    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }

    LocalStorageUtil.write(dbName, jsonEncode(columnJson));

    columnList.refresh();
  }

  Future updateColumnPosition({int? listIndex, int? oldListIndex}) async {
    //Update our local list data
    var list = columnList[oldListIndex!];
    columnList.removeAt(oldListIndex);
    columnList.insert(listIndex!, list);

    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }

    LocalStorageUtil.write(dbName, jsonEncode(columnJson));
    columnList.refresh();
  }

  Future updateTaskPosition(
      {int? listIndex,
      int? itemIndex,
      int? oldListIndex,
      int? oldItemIndex}) async {
    //Used to update our local item data
    var item = columnList[oldListIndex!].tasks![oldItemIndex!];
    columnList[oldListIndex].tasks!.removeAt(oldItemIndex);
    columnList[listIndex!].tasks!.insert(itemIndex!, item);

    List columnJson = [];
    for (BoardModel item in columnList) {
      columnJson.add(item.toJson());
    }

    LocalStorageUtil.write(dbName, jsonEncode(columnJson));
    columnList.refresh();
  }

  Future exportCsv({required int columnId}) async {
    BoardModel currentColumn = columnList.firstWhere((element) => element.id == columnId);
    Map currentColumnJson = currentColumn.toJson();

      List<String> headers = [];
      List<List<String>> listOfLists = [];
      if (currentColumnJson["tasks"]?.length > 0) {
        for (var tsk in currentColumnJson["tasks"]) {
          headers = tsk.keys.toList();
          List<String> singleValues = tsk.values.toString().replaceAll("(", "").replaceAll(")", "").split(",");
          listOfLists.add(singleValues);
        }
        await exportCSV.myCSV(headers, listOfLists);
      }
  }
}
