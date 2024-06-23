// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SubTask {
  final String id;
  String title;
  String taskId;
  bool isCompleted;
  SubTask({
    this.id = '',
    this.title = '',
    this.taskId = '',
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'taskId': taskId,
      'isCompleted': isCompleted,
    };
  }

  factory SubTask.fromMap(Map<String, dynamic> map, String id) {
    return SubTask(
      id: id,
      title: map['title'] as String,
      taskId: map['taskId'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  SubTask copyWith({
    String? id,
    String? userId,
    String? title,
    String? taskId,
    bool? isCompleted,
  }) {
    return SubTask(
      id: id ?? this.id,
      title: title ?? this.title,
      taskId: taskId ?? this.taskId,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
