import 'package:appfp_task_manager/models/category.dart';
import 'package:appfp_task_manager/viewModels/category_view_model.dart';
import 'package:appfp_task_manager/viewModels/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DateTimeCategoryBar extends StatelessWidget {
  const DateTimeCategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final categoryViewModel = Provider.of<CategoryViewModel>(context);
    return DateTimeCategoryBarFul(
      taskViewModel: taskViewModel,
      categoryViewModel: categoryViewModel,
    );
  }
}

class DateTimeCategoryBarFul extends StatefulWidget {
  final TaskViewModel taskViewModel;
  final CategoryViewModel categoryViewModel;
  const DateTimeCategoryBarFul(
      {super.key,
      required this.taskViewModel,
      required this.categoryViewModel});

  @override
  State<DateTimeCategoryBarFul> createState() => _DateTimeCategoryBarState();
}

class _DateTimeCategoryBarState extends State<DateTimeCategoryBarFul> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  String nowDate = ''; //日期顯示
  Category category = Category();

  @override
  void initState() {
    super.initState();

    final String dueDate = widget.taskViewModel.task.dueDate;
    final List<Category> categorys = widget.categoryViewModel.categorys;

    final int timestamp = (dueDate.isNotEmpty)
        ? int.parse(dueDate)
        : DateTime.now().millisecondsSinceEpoch ~/ 1000;
    // dueDate預設值
    selectedDate = dueDate.isEmpty
        ? DateTime.now()
        : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    selectedTime = dueDate.isEmpty
        ? TimeOfDay.now()
        : TimeOfDay.fromDateTime(selectedDate);
    nowDate = DateFormat('yyyy-MM-dd HH:mm').format(selectedDate);

    // category預設值
    final taskCategory = widget.taskViewModel.task.category;
    if (taskCategory.isNotEmpty) {
      category = widget.categoryViewModel.categorys.firstWhere(
        (category) => category.id == taskCategory,
        orElse: () {
          throw Exception('category item is not found');
        },
      );
    } else if (categorys.isNotEmpty) {
      category = widget.categoryViewModel.categorys[0];
    }

    widget.taskViewModel.task.dueDate = timestamp.toString();
    widget.categoryViewModel.setCategory(category);
    widget.taskViewModel.task.category = category.id;
  }

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: selectedTime,
      );
      if (pickedTime != null) {
        setState(() {
          final selectedDate = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          final timestamp = selectedDate.millisecondsSinceEpoch ~/ 1000;
          final dateTime =
              DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
          widget.taskViewModel.task.dueDate = timestamp.toString();
          nowDate = DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Row(
              children: [
                Text(
                  nowDate,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Center(
                  child: IconButton(
                    onPressed: () => _selectDateAndTime(context),
                    icon: const Icon(Icons.edit),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Row(
            children: [
              DropdownButton<Category>(
                items:
                    widget.categoryViewModel.categorys.map((Category category) {
                  return DropdownMenuItem<Category>(
                    value: category,
                    child: Text(category.title),
                  );
                }).toList(),
                onChanged: (Category? newValue) {
                  setState(() {
                    widget.categoryViewModel.setCategory(newValue);
                    widget.taskViewModel.task.category = newValue?.id ?? '';
                  });
                },
                value: widget.categoryViewModel.category,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
