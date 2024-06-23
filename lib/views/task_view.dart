import 'package:appfp_task_manager/models/task.dart';
import 'package:appfp_task_manager/models/task_filter_properties.dart';
import 'package:appfp_task_manager/viewModels/category_view_model.dart';
import 'package:appfp_task_manager/viewModels/sub_task_view_model.dart';
import 'package:appfp_task_manager/viewModels/task_view_model.dart';
import 'package:appfp_task_manager/views/edit_task_view.dart';
import 'package:appfp_task_manager/views/task/filter_task_view.dart';
import 'package:appfp_task_manager/views/task/sort_task_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskView extends StatelessWidget {
  const TaskView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final subTaskViewModel = Provider.of<SubTaskViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);

    return TaskViewFul(
      taskViewModel: taskViewModel,
      subTaskViewModel: subTaskViewModel,
      categoryViewModel: categoryViewModel,
    );
  }
}

class TaskViewFul extends StatefulWidget {
  final TaskViewModel taskViewModel;
  final SubTaskViewModel subTaskViewModel;
  final CategoryViewModel categoryViewModel;
  const TaskViewFul(
      {super.key,
      required this.taskViewModel,
      required this.categoryViewModel,
      required this.subTaskViewModel});

  @override
  State<TaskViewFul> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskViewFul> {
  void _showSortDialog() {
    SortTaskView.show(
      context: context,
      options: [
        TaskSortEnum.dueDateDesc,
        TaskSortEnum.dueDateAsc,
        TaskSortEnum.createDateDesc,
        TaskSortEnum.createDateAsc,
        TaskSortEnum.priorityDesc,
        TaskSortEnum.priorityAsc
      ],
      onSelected: (TaskSortEnum value) {
        setState(() {
          widget.taskViewModel.filterProperties.sort = value;
          widget.taskViewModel.fetchTasks();
        });
      },
      taskSortEnum: widget.taskViewModel.filterProperties.sort,
    );
  }

  void _showFilterDialog() {
    FilterTaskView.show(
      context: context,
      options: [
        TaskFilterEnum.isComplete,
        TaskFilterEnum.timeOut,
        TaskFilterEnum.highPriority,
      ],
      onChanged: (List<TaskFilterEnum> value) {
        setState(() {
          widget.taskViewModel.filterProperties.filters = value;
          widget.taskViewModel.fetchTasks();
        });
      },
      taskFilters: widget.taskViewModel.filterProperties.filters,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          categoryView(),
          taskListView(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final task = Task().copyWith();
          widget.taskViewModel.setTask(task);
          widget.taskViewModel.isEdit = false;
          widget.subTaskViewModel.setSubTasks([]);
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EditTaskView(),
            ),
          );
          if (result != null) {
            widget.taskViewModel.fetchTasks();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget categoryView() {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categoryViewModel.filterCategorys.length,
        itemBuilder: (context, index) {
          String category = widget.taskViewModel.filterProperties.category;
          if (category.isEmpty) {
            category = '0';
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: (int.parse(category) == index)
                    ? Colors.white
                    : Colors.black,
                backgroundColor:
                    (int.parse(category) == index) ? Colors.blue : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ), // 文字的颜色
              ),
              onPressed: () {
                final selectItem =
                    widget.categoryViewModel.filterCategorys[index];
                widget.taskViewModel.filterProperties.category = selectItem.id;
                widget.taskViewModel.fetchTasks();
              },
              child:
                  Text(widget.categoryViewModel.filterCategorys[index].title),
            ),
          );
        },
      ),
    );
  }

  Widget taskListView(BuildContext context) {
    return Consumer<TaskViewModel>(
      builder: (context, viewModel, child) {
        return Expanded(
          child: ListView.builder(
            itemCount: viewModel.tasks.length,
            itemBuilder: (BuildContext context, int index) {
              final task = viewModel.tasks[index];
              final timestamp = int.parse(task.dueDate);
              final dueDate =
                  DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
              final dueDateString =
                  DateFormat('yyyy-MM-dd HH:mm').format(dueDate);

              bool isCompleted = task.isCompleted;
              bool isDeleted = task.isDeleted;

              return Dismissible(
                key: Key(task.id.toString()),
                background: Container(
                  color: isCompleted ? Colors.grey : Colors.green,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Icon(
                        isCompleted
                            ? Icons.check
                            : Icons.check_box_outline_blank,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                secondaryBackground: Container(
                  color: Colors.red,
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Row(
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isDeleted
                                ? Colors.grey
                                : isCompleted
                                    ? Colors.grey
                                    : Colors.black,
                          ),
                        ),
                        if (isDeleted)
                          const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '建立日期：${task.createDate}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        Text(
                          '截止日期：$dueDateString',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () async {
                            final reTask =
                                await widget.taskViewModel.getTask(task.id);
                            widget.taskViewModel.isEdit = true;

                            //子任務深拷貝
                            final subTasks = reTask.subTasks
                                .map((e) => e.copyWith())
                                .toList();
                            widget.subTaskViewModel.setSubTasks(subTasks);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const EditTaskView()),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                      ],
                    ),
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    // Delete
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('是否刪除'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "否",
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                task.isDeleted = true;
                                await widget.taskViewModel
                                    .updateTask(task, []); //軟刪除
                                widget.taskViewModel.fetchTasks();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "是",
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (direction == DismissDirection.startToEnd) {
                    // 標記已完成
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('是否標記已完成'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "否",
                              ),
                            ),
                            TextButton(
                              onPressed: () async {
                                task.isCompleted = true;
                                await viewModel.updateTask(task, []);
                                viewModel.fetchTasks();
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "是",
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  }
                  return false;
                },
              );
            },
          ),
        );
      },
    );
  }
}
