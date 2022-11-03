import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:to_do/db/db_helper.dart';

import '../models/task.dart';

class TaskController extends GetxController {
  final taskList = <Task>[].obs;
  addTask({required Task task}) {
    return DBHelper.insert(task);
  } 
  
  
  getTasks() async {
    final tasks = await DBHelper.query();
    taskList.assignAll(
      tasks
          .map(
            (data) =>  Task.fromJson(data),
          )
          .toList(),
    );
  }

  deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }
  
  deleteAllTask() async {
    await DBHelper.deleteAll();
    getTasks();
  }

  markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
