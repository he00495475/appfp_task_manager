import 'package:appfp_task_manager/helper/user_identifier.dart';
import 'package:appfp_task_manager/models/task.dart';
import 'package:appfp_task_manager/models/task_filter_properties.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TaskService {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('task');
  User? currentUser = FirebaseAuth.instance.currentUser;

  // 新增任務
  Future<String> addTask(Task task) async {
    reloadAuth();
    task.userId = currentUser?.uid ?? '';
    task.uuid = await UserIdentifier.getUserUUID();

    try {
      final ref = await _tasksCollection.add(task.toMap());
      return ref.id;
    } catch (e) {
      print(e);
      return '';
    }
  }

  // 更新任務
  Future<bool> updateTask(Task task) async {
    reloadAuth();
    task.userId = currentUser?.uid ?? '';
    //空的在抓取
    if (task.uuid.isEmpty) {
      task.uuid = await UserIdentifier.getUserUUID();
    }

    try {
      await _tasksCollection.doc(task.id).update(task.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // 刪除任務
  Future<void> deleteTask(String id) {
    return _tasksCollection.doc(id).delete();
  }

  // 取得所有任務
  Future<List<Task>> getTasks(TaskFilterProperties filter) async {
    reloadAuth();
    try {
      Query query = _tasksCollection;
      // 三方登入userId or device uuid
      final uuid = await UserIdentifier.getUserUUID();
      final userId = currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        query = query.where('userId', isEqualTo: userId);
      } else {
        query = query.where('uuid', isEqualTo: uuid);
      }

      if (filter.category.isNotEmpty && filter.category != '0') {
        query = query.where('category', isEqualTo: filter.category);
      }
      // 過濾
      if (filter.filters.isNotEmpty) {
        final filters = filter.filters;
        int todayTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        for (var filter in filters) {
          switch (filter) {
            case TaskFilterEnum.isComplete:
              query = query.where('isCompleted', isEqualTo: false);
              break;
            case TaskFilterEnum.timeOut:
              query = query.where('dueDate',
                  isGreaterThan: todayTimestamp.toString());
              break;
            case TaskFilterEnum.highPriority:
              query = query.where('priority', isNotEqualTo: '3');
              break;
          }
        }
      }

      final querySnapshot = await query.get();

      List<Task> tasks = querySnapshot.docs
          .map(
              (doc) => Task.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      return tasks;
    } catch (e) {
      print('Error service getTasks: $e');
      return [];
    }
  }

  Future<Task> getTask(String id) async {
    reloadAuth();
    final task = await _tasksCollection.doc(id).get();
    return Task.fromMap(task.data() as Map<String, dynamic>, id);
  }

  //刷新service 抓取auth
  reloadAuth() {
    currentUser = FirebaseAuth.instance.currentUser;
  }
}
