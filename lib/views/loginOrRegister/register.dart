import 'package:appfp_task_manager/helper/tooltip_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Register extends StatelessWidget {
  final Function(User?) registerFinish;

  const Register({super.key, required this.registerFinish});

  @override
  Widget build(BuildContext context) {
    return LoginFul(
      registerFinish: registerFinish,
    );
  }
}

class LoginFul extends StatefulWidget {
  final Function(User?) registerFinish;
  const LoginFul({
    super.key,
    required this.registerFinish,
  });

  @override
  State<LoginFul> createState() => _LoginState();
}

class _LoginState extends State<LoginFul> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _secondPasswordController =
      TextEditingController();

  Future<User?> _signInWithEmailAndPassword() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        TooltipHelper.showLoginSuccessfulMessage(context, '此信箱已被使用!');
      } else if (e.code == 'weak-password') {
        TooltipHelper.showLoginSuccessfulMessage(context, '密碼最少六碼');
      } else {
        TooltipHelper.showLoginSuccessfulMessage(context, '建立帳號失敗');
        print('建立帳號失敗: $e');
      }
      return null;
    }
  }

  register() async {
    if (!checkPassWord()) {
      TooltipHelper.showLoginSuccessfulMessage(context, '密碼不一致!');
      return;
    }

    final User? user = await _signInWithEmailAndPassword();
    if (user != null) {
      widget.registerFinish(user);
      TooltipHelper.showLoginSuccessfulMessage(context, '註冊成功!');
      Navigator.pop(context);
    }
  }

  //密碼確認
  bool checkPassWord() {
    bool isPass = false;

    final pwd = _passwordController.text;
    final pwdSec = _secondPasswordController.text;
    if (pwd == pwdSec) {
      isPass = true;
    }

    return isPass;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: '密碼'),
              obscureText: true,
            ),
            TextField(
              controller: _secondPasswordController,
              decoration: const InputDecoration(labelText: '確認密碼'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: register,
              child: const Text('註冊'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
