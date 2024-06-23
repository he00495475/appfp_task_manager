import 'package:appfp_task_manager/models/task_filter_properties.dart';

extension TaskFilterEnumExtension on TaskFilterEnum {
  String get description {
    switch (this) {
      case TaskFilterEnum.isComplete:
        return '已完成';
      case TaskFilterEnum.timeOut:
        return '逾期';
      case TaskFilterEnum.highPriority:
        return '高優先級';
    }
  }
}
