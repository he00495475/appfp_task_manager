import 'package:appfp_task_manager/helper/tooltip_helper.dart';
import 'package:appfp_task_manager/helper/user_identifier.dart';
import 'package:appfp_task_manager/models/task_filter_properties.dart';
import 'package:appfp_task_manager/viewModels/loading_view_model.dart';
import 'package:appfp_task_manager/viewModels/task_view_model.dart';
import 'package:appfp_task_manager/views/loginOrRegister/login.dart';
import 'package:appfp_task_manager/views/task/filter_task_view.dart';
import 'package:appfp_task_manager/views/task/sort_task_view.dart';
import 'package:appfp_task_manager/views/task_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavView extends StatelessWidget {
  const BottomNavView({super.key});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context);
    final isLogin = UserIdentifier().checkLogin();
    final loadingViewModel = Provider.of<LoadingViewModel>(context);
    return BottomNavViewFul(
      taskViewModel: taskViewModel,
      isLogin: isLogin,
      loadingViewModel: loadingViewModel,
    );
  }
}

class BottomNavViewFul extends StatefulWidget {
  final TaskViewModel taskViewModel;
  final bool isLogin;
  final LoadingViewModel loadingViewModel;
  const BottomNavViewFul({
    super.key,
    required this.taskViewModel,
    required this.isLogin,
    required this.loadingViewModel,
  });

  @override
  State<BottomNavViewFul> createState() => _BottomTabViewState();
}

class _BottomTabViewState extends State<BottomNavViewFul> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLogin = false;

  @override
  void initState() {
    super.initState();

    isLogin = widget.isLogin;
  }

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

  void updatePage(bool value) {
    setState(() {
      isLogin = value;
    });
  }

  void _logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      updatePage(false);
      TooltipHelper.showLoginSuccessfulMessage(context, '登出成功!');
      Navigator.pop(context);
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void _login() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Login(
          updatePage: updatePage,
        ),
      ),
    );
  }

  Future<void> clouldSync() async {
    final tasks = widget.taskViewModel.tasks;
    final userId = _auth.currentUser!.uid;
    for (var task in tasks) {
      task.userId = userId;
      await widget.taskViewModel.updateTask(task, []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('任務清單'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                child: const Text('排序'),
                onTap: () {
                  _showSortDialog();
                },
              ),
              PopupMenuItem<String>(
                child: const Text('過濾'),
                onTap: () {
                  _showFilterDialog();
                },
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                '',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading:
                  isLogin ? const Icon(Icons.logout) : const Icon(Icons.login),
              title: isLogin ? const Text('登出') : const Text('登入'),
              onTap: isLogin ? _logOut : _login,
            ),
            Visibility(
              visible: isLogin ? true : false,
              child: ListTile(
                leading: const Icon(Icons.cloud_sync),
                title: const Text('同步'),
                onTap: () async {
                  widget.loadingViewModel.setIsLoading(true);

                  await clouldSync();
                  TooltipHelper.showLoginSuccessfulMessage(context, '同步完成');
                  widget.loadingViewModel.setIsLoading(false);
                },
                trailing: widget.loadingViewModel.isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
              ),
            ),
            // ListTile(
            //   leading: const Icon(Icons.settings),
            //   title: const Text('設定'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const SettingView(),
            //       ),
            //     );
            //   },
            // ),
          ],
        ),
      ),
      body: const TaskView(),
    );
  }
}
