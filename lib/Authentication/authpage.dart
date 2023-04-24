import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:yatri/Authentication/loginwidget.dart';
import 'package:yatri/Authentication/signupwidget.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  @override
  Widget build(BuildContext context) => isLogin
      ? Loginwidget(onClickedSignUp: toggle)
      : SignUpWidget(onClickedSignedIn: toggle);
  void toggle() => setState(() {
        isLogin = !isLogin;
      });
}
