import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yatri/driver/driverupload.dart';
import 'package:yatri/user/userpage.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yatri"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout)),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: Colors.amber,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DriverLive(),
                      ));
                },
                icon: const Icon(Icons.electric_rickshaw),
                label: const Text(
                  "Proceed as Captain",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                )),
            ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UserPage(),
                      ));
                },
                style: ElevatedButton.styleFrom(primary: Colors.green[800]),
                icon: const Icon(Icons.man),
                label: const Text(
                  "Proceed as User",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ))
          ],
        ),
      ),
    );
  }
}
