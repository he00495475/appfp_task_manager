import 'package:appfp_task_manager/models/task_filter_properties.dart';

extension TaskSortEnumExtension on TaskSortEnum {
  String get description {
    switch (this) {
      case TaskSortEnum.dueDateDesc:
        return '截止日期新到舊';
      case TaskSortEnum.dueDateAsc:
        return '截止日期舊到新';
      case TaskSortEnum.createDateDesc:
        return '建立日期新到舊';
      case TaskSortEnum.createDateAsc:
        return '建立日期舊到新';
      case TaskSortEnum.priorityDesc:
        return '優先高到低';
      case TaskSortEnum.priorityAsc:
        return '優先低到高';
    }
  }
}
