// ignore_for_file: public_member_api_docs, sort_constructors_first
enum TaskSortEnum {
  dueDateDesc,
  dueDateAsc,
  createDateDesc,
  createDateAsc,
  priorityDesc,
  priorityAsc
}

enum TaskFilterEnum {
  isComplete, // 已完成
  timeOut, // 超時
  highPriority // 高優先
}

class TaskFilterProperties {
  String category; // 分類
  TaskSortEnum sort; // 排序
  List<TaskFilterEnum> filters; // 過濾
  TaskFilterProperties({
    this.category = '',
    this.sort = TaskSortEnum.dueDateDesc,
    this.filters = const [],
  });

  TaskFilterProperties copyWith({
    String? category,
    TaskSortEnum? sort,
    List<TaskFilterEnum>? filters,
  }) {
    return TaskFilterProperties(
      category: category ?? this.category,
      sort: sort ?? this.sort,
      filters: filters ?? this.filters,
    );
  }
}
