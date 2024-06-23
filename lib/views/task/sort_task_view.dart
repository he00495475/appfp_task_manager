import 'package:appfp_task_manager/extension/task_sort_enum_extension.dart';
import 'package:appfp_task_manager/models/task_filter_properties.dart';
import 'package:flutter/material.dart';

class SortTaskView extends StatefulWidget {
  final TaskSortEnum taskSortEnum;
  final List<TaskSortEnum> options;
  final ValueChanged<TaskSortEnum> onSelected;
  const SortTaskView(
      {super.key,
      required this.options,
      required this.onSelected,
      required this.taskSortEnum});

  static void show({
    required BuildContext context,
    required List<TaskSortEnum> options,
    required ValueChanged<TaskSortEnum> onSelected,
    required TaskSortEnum taskSortEnum,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SortTaskView(
          options: options,
          onSelected: onSelected,
          taskSortEnum: taskSortEnum,
        );
      },
    );
  }

  @override
  State<SortTaskView> createState() => _SortTaskViewState();
}

class _SortTaskViewState extends State<SortTaskView> {
  TaskSortEnum? _selectedOption;
  @override
  void initState() {
    super.initState();

    _selectedOption = widget.taskSortEnum;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('排序'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.options.map((option) {
          return RadioListTile<TaskSortEnum>(
            title: Text(option.description),
            value: option,
            groupValue: _selectedOption,
            onChanged: (TaskSortEnum? value) {
              setState(() {
                _selectedOption = value;
              });
            },
          );
        }).toList(),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('取消'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('確認'),
          onPressed: () {
            if (_selectedOption != null) {
              widget.onSelected(_selectedOption!);
            }
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
