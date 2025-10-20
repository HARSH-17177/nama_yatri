import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:yatri/calculation%20page/calculation_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<dynamic> places = [];
  void placeAutocomplete(String query) async {
    final response = await http.get(Uri.parse(
        "your key"));
    // var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        places = jsonDecode(response.body.toString());
      });
    }
  }

  // final CollectionReference _reference =
  //     FirebaseFirestore.instance.collection('user');
  final user = FirebaseAuth.instance.currentUser!;
  // upload(
  //   String droplat,
  //   String droplong,
  //   String pickuplat,
  //   String pickuplong,
  // ) async {
  //   Map<String, dynamic> datatosend = {
  //     'droplat': droplat,
  //     'droplong': droplong,
  //     'pickuplat': pickuplat,
  //     'pickuplong': pickuplong,
  //     'name': user.email,
  //     'timestamp': DateTime.now().toString()
  //   };
  //   _reference.add(datatosend);
  // }

  Position? currentPosition;
  var pickup = TextEditingController();
  var drop = TextEditingController();
  String? droplat;
  String? droplong;
  String? destaddress;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User")),
      body: Column(
        children: [
          Card(
            elevation: 5,
            color: Colors.amber,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                child: Column(children: [
                  TextFormField(
                    onChanged: (value) {
                      placeAutocomplete(value);
                    },
                    controller: pickup,
                    decoration: const InputDecoration(
                        hintText: "pickup Location -default(current location)",
                        hintStyle: TextStyle(color: Colors.white70)),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      placeAutocomplete(value);
                    },
                    controller: drop,
                    decoration:
                        const InputDecoration(hintText: "drop Location"),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        Position? x = await _determinePosition();
                        // if (x != null) {
                        //   upload(x.latitude.toString(), x.longitude.toString(),
                        //       droplat.toString(), droplong.toString());
                        // }
                        loading = false;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Calculations(
                                currentlat: x!.latitude,
                                currentlon: x.longitude,
                                droplat: double.tryParse(droplat!),
                                droplon: double.tryParse(droplong!),
                                destaddress: destaddress,
                              ),
                            ));
                      },
                      child: const Text("Book ride"))
                ]),
              ),
            ),
          ),
          if (loading) Column(
            children: const [
              SizedBox(height: 20,),
              CircularProgressIndicator.adaptive(),
            ],
          ) else Container(),
          Expanded(
            child: ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) => Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 3),
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  tileColor: Colors.green[800],
                  onTap: () {
                    setState(() {
                      droplat = places[index]['lat'];
                      droplong = places[index]['lon'];
                      destaddress = places[index]['display_name'];
                      drop.text = places[index]['display_name'];
                      places.clear();
                    });
                  },
                  title: Text(places[index]['display_name'].toString()),
                ),
              ),
            ),
          )
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
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      print(e);
    }
    return currentPosition;
  }
}
