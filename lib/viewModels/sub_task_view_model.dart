import 'package:appfp_task_manager/models/sub_task.dart';
import 'package:appfp_task_manager/service/task_sub_service.dart';
import 'package:flutter/material.dart';

class SubTaskViewModel extends ChangeNotifier {
  final SubTaskService _subTaskService = SubTaskService();
  List<SubTask> _subTasks = [];
  List<SubTask> get subTasks => _subTasks;

  late SubTask _subTask;
  SubTask get subTask => _subTask;

  bool isLoading = false;

  SubTaskViewModel() {
    _subTasks = [];
  }

  Future<List<SubTask>> getSubTasks(String taskId) async {
    return await _subTaskService.getSubTasks(taskId);
  }

  Future<void> addSubTask(SubTask subTask) async {
    await _subTaskService.addSubTask(subTask);
  }

  Future<void> updateSubTask(SubTask subTask) async {
    await _subTaskService.updateSubTask(subTask);
  }

  Future<void> deleteSubTask(String id) async {
    await _subTaskService.deleteSubTask(id);
  }

  Future<void> deleteAllSubTask(List<SubTask> subTasks) async {
    await _subTaskService.deleteAllSubTask(subTasks);
  }

  void setSubTasks(List<SubTask> subTasks) {
    _subTasks = subTasks;
  }

  void insertSubTask(SubTask subTask) {
    _subTasks.add(subTask);
    notifyListeners();
  }

  void updateSubTaskText(int index, String text) {
    _subTasks[index].title = text;
  }

  void toggleCompletion(int index) {
    _subTasks[index].isCompleted = !_subTasks[index].isCompleted;
    notifyListeners();
  }

  void removeSubTask(int index) {
    _subTasks.removeAt(index);
    notifyListeners();
  }

  void removeAllSubTask() {
    _subTasks = [];
  }
}
