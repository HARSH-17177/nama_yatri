import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:yatri/Authentication/utils.dart';
import 'package:yatri/homepage.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  @override
  void initState() {
    super.initState();
    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if (!isEmailVerified) {
      sendVerificationEmail();

      //to check if we have verified or not(checking in every 3 seconds that email is verified or not)
      timer = Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerified());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  }

  Future sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user
          .sendEmailVerification(); //verification code send to current user stored in user

      setState(() {
        canResendEmail = false;
      });
      await Future.delayed(Duration(seconds: 5));
      setState(() {
        canResendEmail = true;
      });
    } catch (e) {
      Utils.showSnackBar(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const Homepage()
      : Scaffold(
          appBar: AppBar(title: Text('Verify Email')),
          body: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'A verification email is sent to your number',
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 24,
                ),
                ElevatedButton.icon(
                    onPressed: canResendEmail ? sendVerificationEmail : null, //can resend email is used here as on ce the reset button is pressed and the email is send no one can again press it for 5 seconds 
                    icon: const Icon(
                      Icons.email,
                      size: 32,
                    ),
                    label: const Text(
                      'Reset Email',
                      style: TextStyle(fontSize: 24),
                    )),
                    const SizedBox(
                  height: 24,
                ),
               TextButton(
                  
                    onPressed: ()=>FirebaseAuth.instance.signOut(), //can resend email is used here as on ce the reset button is pressed and the email is send no one can again press it for 5 seconds 
                  
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontSize: 24,color: Colors.greenAccent,fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        );
}
