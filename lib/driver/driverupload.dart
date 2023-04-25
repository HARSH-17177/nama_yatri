import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:yatri/driver/driverpage.dart';

class DriverLive extends StatefulWidget {
  const DriverLive({super.key});

  @override
  State<DriverLive> createState() => _DriverLiveState();
}

class _DriverLiveState extends State<DriverLive> {
  Timer? timer;
  Position? currentposition;
  String? currentAddress;
  List<String> x = [];
  bool loading = false;
  var whatsapp = TextEditingController();
  String? user;
  late final DocumentReference _reference;
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser!.email.toString();
    _reference = FirebaseFirestore.instance.collection('driver').doc(user);
    super.initState();
    timer = Timer.periodic(
        const Duration(seconds: 5), (timer) => _determinePosition());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  navigation() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const DriverProfile(),
        ));
  }

  upload(String phone) async {
    Map<String, dynamic> datatosend = {
      'driverlat': currentposition!.latitude,
      'driverlong': currentposition!.longitude,
      'current address': currentAddress,
      'whatsapp': phone,
      'name': user,
      'phone': phone,
      'timestamp': DateTime.now().toString()
    };
    _reference.set(datatosend);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Captain")),
      body: Column(
        children: [
          Card(
            elevation: 5,
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                const Text(
                  "if you haven't uploaded your details please upload or update your details",
                  style: (TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: whatsapp,
                  decoration: const InputDecoration(
                      hintText: "Enter your whatsApp number"),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      Position? x = await _determinePosition();
                      if (x != null) {
                        upload(whatsapp.text);
                      }
                      whatsapp.clear();
                      loading = false;
                      navigation();
                    },
                    child: const Text("Submit")),
              ]),
            ),
          ),
          (loading) ? const CircularProgressIndicator.adaptive() : Container(),
        ],
      ),
    );
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Please Keep your location on.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'location permission is denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'location permission is denied forever');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks[0];
      setState(() {
        currentposition = position;
        currentAddress =
            "${place.locality},${place.postalCode},${place.country}";
        FirebaseFirestore.instance.collection('driver').doc(user).update({
          'driverlat': currentposition!.latitude,
          'driverlong': currentposition!.longitude,
        });
      });
    } catch (e) {
      print(e);
    }
    return currentposition;
  }
}
