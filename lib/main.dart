import 'package:appfp_task_manager/service/localNotificationService.dart';
import 'package:appfp_task_manager/viewModels/bottom_nav_view_model.dart';
import 'package:appfp_task_manager/viewModels/category_view_model.dart';
import 'package:appfp_task_manager/viewModels/loading_view_model.dart';
import 'package:appfp_task_manager/viewModels/sub_task_view_model.dart';
import 'package:appfp_task_manager/viewModels/task_view_model.dart';
import 'package:appfp_task_manager/viewModels/user_auth.dart';
import 'package:appfp_task_manager/views/nav/bottom_nav_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Firestore 默認啟用持久化
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  await LocalNotificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavViewModel()),
        ChangeNotifierProvider(create: (_) => TaskViewModel()),
        ChangeNotifierProvider(create: (_) => CategoryViewModel()),
        ChangeNotifierProvider(create: (_) => SubTaskViewModel()),
        ChangeNotifierProvider(create: (_) => UserAuthViewModel()),
        ChangeNotifierProvider(create: (_) => LoadingViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const BottomNavView(),
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.blue),
      ),
    );
  }
}
