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
          return const Center(
            child: SizedBox(
                height: 150,
                width: 150,
                child: CircularProgressIndicator.adaptive()),
          );
        }
        var userDocument = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Live Location updation"),
          ),
          body: Column(
            children: [
              Card(
                elevation: 5,
                color: Colors.amber,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Please Dont close this screen if you want to live location to be updated\n\nYour details :\n",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          "Your Email :",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "${userDocument!['name']}\n",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                        const Text("Your contact number :",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          "${userDocument['phone']}\n",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                        const Text("Your current location :",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Text(
                          "${userDocument['current address']}\n",
                          style: const TextStyle(
                              color: Colors.black, fontSize: 16),
                        ),
                        const Text("Your current coordinates :",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Text("Latitude : ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              "${userDocument['driverlat']}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text("Longitude : ",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(
                              "${userDocument['driverlong']}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 18),
                            ),
                          ],
                        )
                      ]),
                ),
              ),
              // ElevatedButton(
              //     onPressed: () {
              //       setState(() {
              //         FirebaseAuth.instance.signOut();
              //         Navigator.pop(context);
              //         Navigator.pop(context);
              //       });
              //     },
              //     child: const Text("Logout"))
            ],
          ),
        );
      },
    );
  }
}
