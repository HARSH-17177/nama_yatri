import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:yatri/main.dart';
import 'package:email_validator/email_validator.dart';

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignedIn;

  const SignUpWidget({super.key, required this.onClickedSignedIn});

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
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
      child: Form(
        key: formKey,
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
          TextFormField(
            controller: emailController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Enter your Email'),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (email) =>
                email != null && !EmailValidator.validate(email)
                    ? 'Enter a valid email'
                    : null,
          ),
          const SizedBox(
            height: 4,
          ),
          TextFormField(
            controller: passwordController,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Enter your Password'),
            obscureText: true,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: ((value) => value != null && value.length < 6
                ? 'Enter min 6 characters'
                : null),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.amber),
              onPressed: SignUp,
              icon: const Icon(Icons.arrow_right),
              label: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24),
              )),
          const SizedBox(
            height: 20,
          ),
          RichText(
              text: TextSpan(
            text: 'Already Have account :',
            children: [
              TextSpan(
                  recognizer: TapGestureRecognizer()
                    ..onTap = widget.onClickedSignedIn,
                  text: "Sign In",
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.bold,
                  ))
            ],
          ))
        ]),
      ),
    );
  }

  Future SignUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        //used to show circularprocessindicator while loading
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {}

    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
