import 'package:appfp_task_manager/helper/tooltip_helper.dart';
import 'package:appfp_task_manager/viewModels/loading_view_model.dart';
import 'package:appfp_task_manager/viewModels/task_view_model.dart';
import 'package:appfp_task_manager/viewModels/user_auth.dart';
import 'package:appfp_task_manager/views/loginOrRegister/register.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

class Login extends StatelessWidget {
  final Function(bool) updatePage;

  const Login({super.key, required this.updatePage});

  @override
  Widget build(BuildContext context) {
    final taskViewModel = Provider.of<TaskViewModel>(context, listen: false);
    final userAuthViewModel = Provider.of<UserAuthViewModel>(context);
    final loadingViewModel = Provider.of<LoadingViewModel>(context);
    return LoginFul(
      updatePage: updatePage,
      taskViewModel: taskViewModel,
      userAuthViewModel: userAuthViewModel,
      loadingViewModel: loadingViewModel,
    );
  }
}

class LoginFul extends StatefulWidget {
  final Function(bool) updatePage;
  final TaskViewModel taskViewModel;
  final UserAuthViewModel userAuthViewModel;
  final LoadingViewModel loadingViewModel;
  const LoginFul(
      {super.key,
      required this.updatePage,
      required this.taskViewModel,
      required this.userAuthViewModel,
      required this.loadingViewModel});

  @override
  State<LoginFul> createState() => _LoginState();
}

class _LoginState extends State<LoginFul> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<User?> _signInWithGoogle() async {
    widget.loadingViewModel.setIsLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      widget.loadingViewModel.setIsLoading(false);
      return userCredential.user;
    } catch (e) {
      print(e);

      widget.loadingViewModel.setIsLoading(false);
      return null;
    }
  }

  Future<User?> _signInWithFacebook() async {
    widget.loadingViewModel.setIsLoading(true);

    try {
      final LoginResult result = await FacebookAuth.instance.login();
      final AuthCredential credential =
          FacebookAuthProvider.credential(result.accessToken!.tokenString);
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      widget.loadingViewModel.setIsLoading(false);
      return userCredential.user;
    } catch (e) {
      print(e);
      widget.loadingViewModel.setIsLoading(false);
      return null;
    }
  }

  Future<User?> _signInWithEmailAndPassword() async {
    widget.loadingViewModel.setIsLoading(true);

    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      widget.loadingViewModel.setIsLoading(false);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        TooltipHelper.showLoginSuccessfulMessage(context, '找不到email');
      } else if (e.code == 'wrong-password') {
        TooltipHelper.showLoginSuccessfulMessage(context, '密碼錯誤');
      } else {
        TooltipHelper.showLoginSuccessfulMessage(context, '登入失敗');
      }

      print('登入錯誤 ${e.code}');
      widget.loadingViewModel.setIsLoading(false);
      return null;
    }
  }

  void loginResult(re) async {
    if (re != null) {
      final tasks = widget.taskViewModel.tasks;
      final userId = _auth.currentUser!.uid;
      for (var task in tasks) {
        task.userId = userId;
        await widget.taskViewModel.updateTask(task, []);
      }
      widget.taskViewModel.fetchTasks(); //更新任務清單畫面

      TooltipHelper.showLoginSuccessfulMessage(context, '登入成功!');
      widget.updatePage(true);
    } else {
      TooltipHelper.showLoginSuccessfulMessage(context, '登入失敗!');
      widget.updatePage(false);
    }
    Navigator.pop(context);
  }

  void registerFinish(User? user) {
    _emailController.text = user?.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Consumer<LoadingViewModel>(
        builder: (context, viewModel, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Register(registerFinish: registerFinish)),
                        );
                      },
                      child: const Text('註冊'),
                    ),
                    const SizedBox(width: 30),
                    ElevatedButton(
                      onPressed: () async {
                        final re = await _signInWithEmailAndPassword();
                        if (re != null) {
                          loginResult(re);
                        }
                      },
                      child: const Text('登入'),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () async {
                          final re = await _signInWithGoogle();
                          if (re != null) {
                            loginResult(re);
                          }
                        },
                        icon: Image.asset('assets/images/google.png'),
                      ),
                    ),
                    // SizedBox(
                    //   height: 60,
                    //   width: 60,
                    //   child: IconButton(
                    //     onPressed: () async {
                    //       await _signInWithFacebook()
                    //           .then((value) => loginResult(value));
                    //     },
                    //     icon: Image.asset('assets/images/facebook.png'),
                    //   ),
                    // ),
                  ],
                ),
                viewModel.isLoading
                    ? const CircularProgressIndicator()
                    : const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}
