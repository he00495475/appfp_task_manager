import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserIdentifier {
  static const String _uuidKey = 'user_uuid';
  static final Uuid _uuid = Uuid();

  User? user = FirebaseAuth.instance.currentUser;

  checkLogin() {
    bool isLogin = false;
    if (user != null) {
      isLogin = true;
    }

    return isLogin;
  }

  static Future<String> getUserUUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userUUID = prefs.getString(_uuidKey);

    if (userUUID == null) {
      userUUID = _uuid.v4();
      await prefs.setString(_uuidKey, userUUID);
    }

    return userUUID;
  }
}
