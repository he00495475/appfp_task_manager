import 'package:appfp_task_manager/extension/task_filter_enum_extension.dart';
import 'package:appfp_task_manager/models/task_filter_properties.dart';
import 'package:flutter/material.dart';

class FilterTaskView extends StatefulWidget {
  final List<TaskFilterEnum> taskFilters;
  final List<TaskFilterEnum> options;
  final ValueChanged<List<TaskFilterEnum>> onChanged;
  const FilterTaskView(
      {super.key,
      required this.options,
      required this.onChanged,
      required this.taskFilters});

  static void show({
    required BuildContext context,
    required List<TaskFilterEnum> options,
    required ValueChanged<List<TaskFilterEnum>> onChanged,
    required List<TaskFilterEnum> taskFilters,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FilterTaskView(
          options: options,
          onChanged: onChanged,
          taskFilters: taskFilters,
        );
      },
    );
  }

  @override
  State<FilterTaskView> createState() => _FilterTaskViewState();
}

class _FilterTaskViewState extends State<FilterTaskView> {
  List<TaskFilterEnum> _selectedOptions = [];
  @override
  void initState() {
    super.initState();

    _selectedOptions = List.from(widget.taskFilters);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('過濾'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.options.map((option) {
          return CheckboxListTile(
            title: Text(option.description),
            value: _selectedOptions.contains(option),
            controlAffinity: ListTileControlAffinity.leading,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  _selectedOptions.add(option);
                } else {
                  _selectedOptions.remove(option);
                }
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
            widget.onChanged(_selectedOptions);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
