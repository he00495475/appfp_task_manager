// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:appfp_task_manager/viewModels/category_view_model.dart';
import 'package:appfp_task_manager/viewModels/sub_task_view_model.dart';
import 'package:appfp_task_manager/viewModels/task_view_model.dart';
import 'package:appfp_task_manager/views/task/date_time_categoryBar.dart';
import 'package:appfp_task_manager/views/task/task_details.dart';

class EditTaskView extends StatelessWidget {
  const EditTaskView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final subTaskViewModel = Provider.of<SubTaskViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return EditTaskViewFul(
      taskViewModel: taskViewModel,
      categoryViewModel: categoryViewModel,
      subTaskViewModel: subTaskViewModel,
    );
  }
}

class EditTaskViewFul extends StatefulWidget {
  final TaskViewModel taskViewModel;
  final SubTaskViewModel subTaskViewModel;
  final CategoryViewModel categoryViewModel;
  const EditTaskViewFul({
    super.key,
    required this.taskViewModel,
    required this.categoryViewModel,
    required this.subTaskViewModel,
  });

  @override
  State<EditTaskViewFul> createState() => _EditTaskViewState();
}

class _EditTaskViewState extends State<EditTaskViewFul> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任務詳細'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              final isEdit = widget.taskViewModel.isEdit;
              final task = widget.taskViewModel.task;
              final subTasks = widget.subTaskViewModel.subTasks;

              if (isEdit) {
                await widget.taskViewModel.updateTask(task, subTasks);
              } else {
                await widget.taskViewModel.addTask(task, subTasks);
              }

              widget.taskViewModel.fetchTasks();

              clearModelContent();
              Navigator.pop(context, '任務詳細更新成功');
            },
          ),
        ],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DateTimeCategoryBar(),
              TaskDetails(),
            ],
          ),
        ),
      ),
    );
  }

  // 新增或修改後清空model暫存
  clearModelContent() {
    widget.taskViewModel.setTask(widget.taskViewModel.task.copyWith());
    widget.subTaskViewModel.removeAllSubTask();
  }
}
