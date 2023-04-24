import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriverProfile extends StatefulWidget {
  const DriverProfile({super.key});

  @override
  State<DriverProfile> createState() => _DriverProfileState();
}

class _DriverProfileState extends State<DriverProfile> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('driver')
          .doc(FirebaseAuth.instance.currentUser!.email.toString())
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        var userDocument = snapshot.data;

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5,
              color: Colors.amber,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Your Email : ${userDocument!['name']}"),
                      Text("Your contact number : ${userDocument['phone']}"),
                      Text(
                          "Your current location  ${userDocument['current address']}")
                    ]),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    
                  FirebaseAuth.instance.signOut();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  });
                  
                },
                child: const Text("Logout"))
          ],
        );
      },
    );
  }
}
