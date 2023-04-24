import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class Calculations extends StatefulWidget {
  double? currentlat;
  double? currentlon;
  double? droplat;
  double? droplon;
  String? destaddress;
  Calculations(
      {super.key,
      required this.currentlat,
      required this.currentlon,
      required this.droplat,
      required this.droplon,
      required this.destaddress});

  @override
  State<Calculations> createState() => _CalculationsState();
}

class _CalculationsState extends State<Calculations> {
  List<Captains> x = [];
  Stream<QuerySnapshot>? _stream;
  @override
  void initState() {
    final Query<Map<String, dynamic>> _reference = FirebaseFirestore.instance
        .collection('driver')
        .orderBy('timestamp', descending: true);
    _stream = _reference.snapshots();

    super.initState();
    x.clear();
  }

  calculate(List<Map> items) {
    for (int i = 0; i < items.length; i++) {
      if (GeolocatorPlatform.instance.distanceBetween(
              widget.currentlat!,
              widget.currentlon!,
              items[i]['driverlat'],
              items[i]['driverlong']) <=
          10000) {
        x.add(Captains(
            name: items[i]['name'],
            phone: items[i]['phone'],
            distance: GeolocatorPlatform.instance.distanceBetween(
                widget.currentlat!,
                widget.currentlon!,
                items[i]['driverlat'],
                items[i]['driverlong'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Captains")),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Some error occurred ${snapshot.error}'),
            );
          }
          if (snapshot.hasData) {
            QuerySnapshot? querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> documents = querySnapshot!.docs;
            List<Map> items = documents.map((e) => e.data() as Map).toList();

            calculate(items);
            return ListView.builder(
                itemCount: x.length,
                itemBuilder: (context, index) {
                  var thisItems = x[index];
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12.0, top: 2.0, bottom: 2.0),
                    child: Card(
                      color: Colors.amber,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, right: 10.0, top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Captain id :",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text(thisItems.name.toString(),
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black)),
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "Distance :",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Text("${thisItems.distance!.toStringAsFixed(2)} Km",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.black)),
                            const Divider(
                              color: Colors.black,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await launch(
                                        'tel:+91${thisItems.phone.toString()}');
                                  },
                                  icon: const Icon(
                                    FontAwesomeIcons.phone,
                                    color: Colors.blue,
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await launch(
                                        "https://wa.me/${thisItems.phone.toString()}?text=Hello ,This user\n\nCurrent location :\n http://www.google.com/maps/place/${widget.currentlat},${widget.currentlon}\n\nhas requested for a trip to this location\n\n${widget.destaddress}\n http://www.google.com/maps/place/${widget.droplat},${widget.droplon}");
                                  },
                                  icon: const Icon(FontAwesomeIcons.whatsapp,
                                      color: Colors.green),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Captains {
  String? name;
  String? phone;

  double? distance;
  Captains({required this.name, required this.phone, required this.distance});
}
