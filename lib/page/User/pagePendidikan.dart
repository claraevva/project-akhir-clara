import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:project3/core/color.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class Pendidikan extends StatefulWidget {
  const Pendidikan({super.key});

  @override
  State<Pendidikan> createState() => _PendidikanState();
}

class _PendidikanState extends State<Pendidikan> {
  final firebaseReference = FirebaseDatabase.instance
      .ref()
      .child('data')
      .child('admin')
      .child('lowongan');

  List<bool> isExpandedList = [];

  // Helper function to parse the expiration date from the snapshot
  DateTime? _parseTanggalExpired(DataSnapshot snapshot) {
    final tanggalExpiredStr = snapshot.child("tanggalExpired").value.toString();
    if (tanggalExpiredStr.isNotEmpty) {
      try {
        return DateFormat('yyyy-MM-dd').parse(tanggalExpiredStr);
      } catch (e) {
        print('Error parsing tanggalExpired: $e');
        return null;
      }
    }
    return null;
  }

  // Launch email
  void _launchEmail(String email) async {
    final Uri params = Uri(
      scheme: 'mailto',
      path: email,
    );
    var url = params.toString();
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  // Launch maps
  void _launchMaps(String alamat) async {
    var url = "https://www.google.com/maps/search/?api=1&query=$alamat";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('Could not launch $url');
    }
  }

  // Launch WhatsApp
  void _launchWhatsApp(String whatsapp) async {
    final String whatsappUrl = 'https://wa.me/$whatsapp';
    final Uri whatsappUri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      throw 'Could not launch $whatsappUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        title: Text("Loker Bidang IT"),
        backgroundColor: darkBlue,
        foregroundColor: white,
      ),
      body: FirebaseAnimatedList(
        query: firebaseReference.orderByChild("kategori").equalTo("Pendidikan"),
        itemBuilder: (context, snapshot, animation, index) {
          // Get the expiration date
          DateTime? tanggalExpired = _parseTanggalExpired(snapshot);
          if (tanggalExpired != null &&
              tanggalExpired.isBefore(DateTime.now())) {
            // Skip rendering if the job listing is expired
            return Container();
          }

          if (index >= isExpandedList.length) {
            isExpandedList.add(false);
          }

          // Check if WhatsApp data exists and is valid
          String? whatsapp = snapshot.child("whatsapp").value as String?;
          bool hasWhatsapp =
              whatsapp != null && whatsapp.isNotEmpty && whatsapp != "null";

          return Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(
                    snapshot.child("posisi").value.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    snapshot.child("kategori").value.toString(),
                    style: const TextStyle(
                      color: black,
                      fontSize: 10.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    snapshot.child("namaKantor").value.toString(),
                    style: const TextStyle(
                      color: black,
                      fontSize: 15.0,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Batas Lamaran: ${snapshot.child("tanggalExpired").value.toString()}',
                    style: const TextStyle(
                      color: red,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.ease,
                    height: isExpandedList[index] ? null : 0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Kualifikasi:\n${snapshot.child("kualifikasi").value.toString()}",
                          maxLines: null,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Persyaratan:\n${snapshot.child("persyaratan").value.toString()}",
                          maxLines: null,
                        ),
                        SizedBox(height: 8),
                        if (snapshot
                            .child("catatan")
                            .value
                            .toString()
                            .isNotEmpty)
                          Text(
                            "Catatan:\n${snapshot.child("catatan").value.toString()}",
                            maxLines: null,
                          ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _launchEmail(
                                    snapshot.child("email").value.toString());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: red,
                              ),
                              child: Text(
                                'Kirim Berkas',
                                style: TextStyle(color: white),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                _launchMaps(snapshot
                                    .child("alamatKantor")
                                    .value
                                    .toString());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow,
                              ),
                              child: Text(
                                'Lihat Lokasi',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (hasWhatsapp) // Only show if WhatsApp number is provided and valid
                          ElevatedButton(
                            onPressed: () {
                              _launchWhatsApp(whatsapp!);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                            ),
                            child: Text(
                              'Chat Whatsapp',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isExpandedList[index] = !isExpandedList[index];
                      });
                    },
                    child: Text(
                      isExpandedList[index]
                          ? "Tutup Detail"
                          : "Lihat Selengkapnya",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        fontSize: 12.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
