import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseAuth get auth => _auth;

  User? _currentUser;
  User? get currentUser => _currentUser;

  UserAuthViewModel() {}
}
