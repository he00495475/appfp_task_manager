import 'package:appfp_task_manager/models/sub_task.dart';
import 'package:appfp_task_manager/viewModels/sub_task_view_model.dart';
import 'package:appfp_task_manager/viewModels/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskDetails extends StatelessWidget {
  const TaskDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final subTaskViewModel = Provider.of<SubTaskViewModel>(context);
    return TaskDetailsFul(
      taskViewModel: taskViewModel,
      subTaskViewModel: subTaskViewModel,
    );
  }
}

class TaskDetailsFul extends StatefulWidget {
  final TaskViewModel taskViewModel;
  final SubTaskViewModel subTaskViewModel;
  const TaskDetailsFul({
    super.key,
    required this.taskViewModel,
    required this.subTaskViewModel,
  });

  @override
  State<TaskDetailsFul> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetailsFul> {
  List<Map<String, dynamic>> prioritys = [
    {'id': '1', 'title': '低'},
    {'id': '2', 'title': '中'},
    {'id': '3', 'title': '高'},
  ];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final title = widget.taskViewModel.task.title;
    final descript = widget.taskViewModel.task.description;
    if (widget.taskViewModel.isEdit) {
      _titleController.text = title.isNotEmpty ? title : '';
      _descriptController.text = descript.isNotEmpty ? descript : '';
    } else {
      widget.taskViewModel.task.copyWith();
    }

    //優先順序 初始值
    final taskPriority = widget.taskViewModel.task.priority;
    if (taskPriority.isEmpty) {
      widget.taskViewModel.task.priority = prioritys[0]['id'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          priority(), // 優先順序
          taskTitle(), // 標題
          taskDescriot(), // 描述
          subTaskList(), // 子任務
        ],
      ),
    );
  }

  // 優先順序
  Widget priority() {
    return Column(
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('優先順序'),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: prioritys.map((range) {
            return Expanded(
              child: ListTile(
                title: Text(range["title"]),
                leading: Radio<String>(
                  value: range["id"],
                  groupValue: widget.taskViewModel.task.priority,
                  onChanged: (String? value) {
                    setState(() {
                      widget.taskViewModel.task.priority = value!;
                    });
                  },
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 標題
  Widget taskTitle() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(labelText: '標題'),
      onChanged: (value) {
        setState(() {
          widget.taskViewModel.task.title = value;
        });
      },
    );
  }

  // 描述
  Widget taskDescriot() {
    return TextField(
      controller: _descriptController,
      maxLines: 5,
      decoration: const InputDecoration(labelText: '描述'),
      onChanged: (value) {
        setState(() {
          widget.taskViewModel.task.description = value;
        });
      },
    );
  }

  // 子任務
  Widget subTaskList() {
    return Consumer<SubTaskViewModel>(
      builder: (context, viewModel, child) {
        return Column(
          children: [
            const SizedBox(height: 16.0),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('子任務'),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: viewModel.subTasks.length,
              itemBuilder: (context, index) {
                final subTask = viewModel.subTasks[index];
                return ListTile(
                  leading: Checkbox(
                    value: subTask.isCompleted,
                    onChanged: (value) {
                      viewModel.toggleCompletion(index);
                    },
                  ),
                  title: TextField(
                    controller: TextEditingController(text: subTask.title),
                    onChanged: (value) {
                      viewModel.updateSubTaskText(index, value);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      viewModel.removeSubTask(index);
                    },
                  ),
                );
              },
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                child: const Text(
                  "+ 新增子任務",
                ),
                onPressed: () {
                  setState(() {
                    final subTask = SubTask();
                    viewModel.subTasks.add(subTask);
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
