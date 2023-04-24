import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yatri/Authentication/forgotpasswordpage.dart';
import 'package:yatri/Authentication/utils.dart';
import 'package:yatri/main.dart';

class Loginwidget extends StatefulWidget {
  final VoidCallback onClickedSignUp;
  const Loginwidget({super.key, required this.onClickedSignUp});

  @override
  State<Loginwidget> createState() => _LoginwidgetState();
}

class _LoginwidgetState extends State<Loginwidget> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(children: [
        const SizedBox(
          height: 40,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 160),
          child: Image.asset(
            "assets/nammaYatrilogo.png",
          ),
        ),
        const Divider(
          color: Colors.amber,
        ),
        const SizedBox(
          height: 20,
        ),
        TextField(
          controller: emailController,
          cursorColor: Colors.white,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(labelText: 'Enter your Email'),
        ),
        const SizedBox(
          height: 4,
        ),
        TextField(
          controller: passwordController,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(labelText: 'Enter your Password'),
          obscureText: true,
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.amber),
            onPressed: signIn,
            icon: const Icon(Icons.lock_open),
            label: const Text(
              'Sign In',
              style: TextStyle(fontSize: 24),
            )),
        const SizedBox(
          height: 20,
        ),
        GestureDetector(
          child: const Text('Forgot password',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ForgotPassWordPage())),
        ),
        const SizedBox(
          height: 20,
        ),
        RichText(
            text: TextSpan(
          text: 'No Account :',
          children: [
            TextSpan(
                recognizer: TapGestureRecognizer()
                  ..onTap = widget.onClickedSignUp,
                text: "Sign up",
                style: const TextStyle(
                    color: Colors.greenAccent, fontWeight: FontWeight.bold))
          ],
        ))
      ]),
    );
  }

  Future signIn() async {
    showDialog(
        //used to show circularprocessindicator while loading
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
    }

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
