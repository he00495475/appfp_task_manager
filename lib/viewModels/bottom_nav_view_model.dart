import 'package:appfp_task_manager/models/bottom_nav.dart';
import 'package:flutter/material.dart';

class BottomNavViewModel extends ChangeNotifier {
  final BottomNav _counterModel = BottomNav(0);

  int get counter => _counterModel.counter;

  void increment() {
    _counterModel.counter++;
    notifyListeners();
  }

  void decrement() {
    _counterModel.counter--;
    notifyListeners();
  }
}
