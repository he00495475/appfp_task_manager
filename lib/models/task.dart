// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:appfp_task_manager/models/sub_task.dart';

enum Recurrence { none, daily, weekly, monthly, custom }

class Task {
  final String id;
  String userId;
  String uuid;
  String createDate;
  String title; // 標題
  String description; // 描述
  String dueDate; // 到期日
  List<SubTask> subTasks; // 子任務
  String priority; // 優先順序
  String category; // 任務類別
  bool isCompleted; // 是否完成
  bool isDeleted; // 是否假刪除
  // Recurrence recurrence; // 任務循環每日,每週
  Task({
    // this.recurrence = Recurrence.none,
    this.id = '',
    this.userId = '',
    this.uuid = '',
    this.createDate = '',
    this.title = '',
    this.description = '',
    this.dueDate = '',
    this.subTasks = const [],
    this.priority = '',
    this.category = '',
    this.isCompleted = false,
    this.isDeleted = false,
  });

  Task copyWith({
    String? id,
    String? userId,
    String? uuid,
    String? createDate,
    String? title,
    String? description,
    String? dueDate,
    List<SubTask>? subTasks,
    String? priority,
    String? category,
    bool? isCompleted,
    bool? isDeleted,
    // Recurrence? recurrence,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      uuid: uuid ?? this.uuid,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      subTasks: subTasks ?? this.subTasks.map((e) => e.copyWith()).toList(),
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      createDate: createDate ?? this.createDate,
      // recurrence: recurrence ?? this.recurrence,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'uuid': uuid,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'category': category,
      'isCompleted': isCompleted,
      'isDeleted': isDeleted,
      'createDate': createDate,
      // 'recurrence': recurrence,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      userId: map['userId'],
      uuid: map['uuid'],
      title: map['title'],
      description: map['description'],
      dueDate: map['dueDate'],
      subTasks: (map['subTasks'] != null)
          ? List<SubTask>.from(
              (map['subTasks']).map<SubTask>(
                (x) => SubTask.fromMap(
                    x as Map<String, dynamic>, x['id'].toString()),
              ),
            )
          : [],
      priority: map['priority'],
      category: map['category'],
      isCompleted: map['isCompleted'],
      isDeleted: map['isDeleted'],
      createDate: map['createDate'],
      // recurrence: map['recurrence'],
    );
  }

  String toJson() => json.encode(toMap());
}
