import 'package:appfp_task_manager/models/task_filter_properties.dart';
import 'package:appfp_task_manager/models/sub_task.dart';
import 'package:appfp_task_manager/models/task.dart';
import 'package:appfp_task_manager/service/localNotificationService.dart';
import 'package:appfp_task_manager/service/task_service.dart';
import 'package:appfp_task_manager/viewModels/sub_task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskViewModel extends ChangeNotifier {
  final SubTaskViewModel subTaskViewModel = SubTaskViewModel();
  final TaskService _taskService = TaskService();
  List<Task> _tasks = [];
  List<Task> get tasks => _tasks;

  late Task _task;
  Task get task => _task;

  bool isEdit = false;
  bool isLoading = false;

  late TaskFilterProperties _filterProperties;
  TaskFilterProperties get filterProperties => _filterProperties;

  final LocalNotificationService _notificationService =
      LocalNotificationService();

  TaskViewModel() {
    _task = Task().copyWith();
    _filterProperties = TaskFilterProperties().copyWith();

    fetchTasks();
  }

  Future<void> fetchTasks() async {
    List<Task> tasks = await _taskService.getTasks(filterProperties);

    _tasks = tasks;
    sortTasks(); //_tasks排序
    notifyListeners();
  }

  Future<Task> getTask(String id) async {
    Task task = await _taskService.getTask(id);

    List<SubTask> subTasks = await SubTaskViewModel().getSubTasks(task.id);
    task.subTasks = subTasks;

    setTask(task.copyWith());
    notifyListeners();
    return task;
  }

  Future<void> addTask(Task task, List<SubTask> subTasks) async {
    task.createDate = DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());

    final refId = await _taskService.addTask(task);
    //nosql 所以要把task id帶入子項目
    if (refId.isNotEmpty && subTasks.isNotEmpty) {
      for (var subTask in subTasks) {
        subTask.taskId = refId;
        SubTaskViewModel().addSubTask(subTask);
      }
    }
    notifyListeners();

    final now = DateTime.now();
    final dueDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(task.dueDate) * 1000);

    if (dueDate.isAfter(now)) {
      _notificationService.showNotification(dueDate, task.title);
    }
  }

  Future<void> updateTask(Task task, List<SubTask> subTasks) async {
    final taskId = task.id;
    final taskRef = await _taskService.updateTask(task);
    //子任務部分
    if (subTasks.isNotEmpty && taskRef) {
      final oldSubTasks = task.subTasks;
      final newSubTasks = subTasks;

      // 新增子任務
      final addItems =
          newSubTasks.where((newItem) => newItem.taskId.isEmpty).toList();
      for (var addItem in addItems) {
        addItem.taskId = taskId;
        await subTaskViewModel.addSubTask(addItem);
      }
      // 刪除子任務
      final List<SubTask> delItems = oldSubTasks
          .where((oldItem) =>
              !newSubTasks.any((newItem) => oldItem.id == newItem.id))
          .toList();

      for (var delItem in delItems) {
        await subTaskViewModel.deleteSubTask(delItem.id);
      }
      // 修改子任務
      final updateSubTasks =
          newSubTasks.where((element) => element.id.isNotEmpty).toList();
      for (var subTask in updateSubTasks) {
        var oldItem = oldSubTasks.firstWhere((item) => item.id == subTask.id);
        if (oldItem != subTask) {
          await subTaskViewModel.updateSubTask(subTask);
        }
      }
    }
    notifyListeners();

    final now = DateTime.now();
    final dueDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(task.dueDate) * 1000);

    if (dueDate.isAfter(now)) {
      _notificationService.showNotification(dueDate, task.title);
    }
  }

  Future<void> deleteTask(String id) async {
    await _taskService.deleteTask(id);
    notifyListeners();
  }

  void setTask(Task task) {
    _task = task;
  }

  sortTasks() {
    switch (filterProperties.sort) {
      case TaskSortEnum.dueDateDesc:
        _tasks.sort((a, b) => b.dueDate.compareTo(a.dueDate));
        break;
      case TaskSortEnum.dueDateAsc:
        _tasks.sort((a, b) => a.dueDate.compareTo(b.dueDate));
        break;
      case TaskSortEnum.createDateDesc:
        _tasks.sort((a, b) {
          int createCompare = b.createDate.compareTo(a.createDate);
          if (createCompare != 0) {
            return createCompare;
          }

          int dueCompare = b.dueDate.compareTo(a.dueDate);
          return dueCompare;
        });
        break;
      case TaskSortEnum.createDateAsc:
        _tasks.sort((a, b) {
          int createCompare = a.createDate.compareTo(b.createDate);
          if (createCompare != 0) {
            return createCompare;
          }
          int dueCompare = b.dueDate.compareTo(a.dueDate);
          return dueCompare;
        });
        break;
      case TaskSortEnum.priorityDesc:
        _tasks.sort((a, b) {
          int priorityCompare = b.priority.compareTo(a.priority);
          if (priorityCompare != 0) {
            return priorityCompare;
          }

          int dueCompare = b.dueDate.compareTo(a.dueDate);
          return dueCompare;
        });
        break;
      case TaskSortEnum.priorityAsc:
        _tasks.sort((a, b) {
          int priorityCompare = a.priority.compareTo(b.priority);
          if (priorityCompare != 0) {
            return priorityCompare;
          }

          int dueCompare = b.dueDate.compareTo(a.dueDate);
          return dueCompare;
        });
        break;
    }
  }
}
