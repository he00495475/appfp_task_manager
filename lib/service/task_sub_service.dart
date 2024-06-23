import 'package:appfp_task_manager/models/sub_task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SubTaskService {
  final CollectionReference _subTasksCollection =
      FirebaseFirestore.instance.collection('subTask');
  final User? currentUser = FirebaseAuth.instance.currentUser;

  // 添加子任務
  addSubTask(SubTask subTask) async {
    try {
      _subTasksCollection.add(subTask.toMap());
    } catch (e) {
      print(e);
    }
  }

  // 更新子任務
  updateSubTask(SubTask subTask) {
    try {
      _subTasksCollection.doc(subTask.id).update(subTask.toMap());
    } catch (e) {
      print(e);
    }
  }

  // 刪除子任務
  deleteSubTask(String id) {
    try {
      _subTasksCollection.doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  // 刪除所有子任務
  deleteAllSubTask(List<SubTask> subTasks) {
    try {
      for (var subTask in subTasks) {
        _subTasksCollection.doc(subTask.id).delete();
      }
    } catch (e) {
      print(e);
    }
  }

  // 所有子任務
  Future<List<SubTask>> getSubTasks(String taskId) async {
    try {
      final querySnapshot =
          await _subTasksCollection.where('taskId', isEqualTo: taskId).get();

      return querySnapshot.docs
          .map((doc) =>
              SubTask.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      print('Error service getSubTasks: $e');
      return [];
    }
  }
}
