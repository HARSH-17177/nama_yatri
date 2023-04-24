import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yatri/Authentication/utils.dart';

class ForgotPassWordPage extends StatefulWidget {
  const ForgotPassWordPage({super.key});

  @override
  State<ForgotPassWordPage> createState() => _ForgotPassWordPageState();
}

class _ForgotPassWordPageState extends State<ForgotPassWordPage> {
  final formkey = GlobalKey<FormState>();
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Reset Pasword"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
              key: formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Receive an Email to\nReset your Password',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(labelText: 'Email'),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        email != null && !EmailValidator.validate(email)
                            ? 'Enter a valid email'
                            : null,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50)),
                      onPressed: resetPassword,
                      icon: const Icon(Icons.email),
                      label: const Text(
                        'Reset Password',
                        style: TextStyle(fontSize: 24),
                      )),
                ],
              )),
        ),
      );

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      Utils.showSnackBar('Password Reset Email sent');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}
