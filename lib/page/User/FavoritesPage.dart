import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project3/core/color.dart';
import 'package:url_launcher/url_launcher.dart';

class Lowongan {
  String kategori;
  String posisi;
  String namaKantor;
  String kualifikasi;
  String persyaratan;
  String alamatKantor;
  String email;
  String tanggalExpired;
  String catatan;
  String whatsapp;
  bool isExpanded;
  bool isFavorite;

  Lowongan({
    required this.kategori,
    required this.posisi,
    required this.namaKantor,
    required this.kualifikasi,
    required this.persyaratan,
    required this.alamatKantor,
    required this.email,
    required this.whatsapp,
    required this.tanggalExpired,
    required this.catatan,
    this.isExpanded = false,
    this.isFavorite = false,
  });

  factory Lowongan.fromJson(Map<dynamic, dynamic> json) {
    return Lowongan(
      kategori: json['kategori'] ?? '',
      posisi: json['posisi'] ?? '',
      namaKantor: json['namaKantor'] ?? '',
      kualifikasi: json['kualifikasi'] ?? '',
      persyaratan: json['persyaratan'] ?? '',
      alamatKantor: json['alamatKantor'] ?? '',
      email: json['email'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      tanggalExpired: json['tanggalExpired'] ?? '',
      catatan: json['catatan'] ?? '',
      isFavorite: json['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'kategori': kategori,
      'posisi': posisi,
      'namaKantor': namaKantor,
      'kualifikasi': kualifikasi,
      'persyaratan': persyaratan,
      'alamatKantor': alamatKantor,
      'email': email,
      'tanggalExpired': tanggalExpired,
      'catatan': catatan,
      'isExpanded': isExpanded,
      'isFavorite': isFavorite,
    };
  }
}

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final DatabaseReference _favoritesRef = FirebaseDatabase.instance
      .ref()
      .child('favorites')
      .child(FirebaseAuth.instance.currentUser!.uid);

  List<Lowongan> _favoriteLowongan = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
  }

  void _fetchFavorites() {
    _favoritesRef.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;
      if (data != null) {
        setState(() {
          _favoriteLowongan = data.values
              .map((e) => Lowongan.fromJson(e as Map<dynamic, dynamic>))
              .toList();
        });
      } else {
        setState(() {
          _favoriteLowongan = [];
        });
      }
    });
  }

  void _toggleExpansion(int index) {
    setState(() {
      _favoriteLowongan[index].isExpanded =
          !_favoriteLowongan[index].isExpanded;
    });
  }

  void _removeFavorite(String posisi) async {
    await _favoritesRef.child(posisi).remove();
    _fetchFavorites(); // Refresh the list after removal
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  Future<void> _launchMaps(String address) async {
    final Uri mapsUri = Uri(
      scheme: 'https',
      host: 'www.google.com',
      path: '/maps/search/',
      queryParameters: {'api': '1', 'query': address},
    );
    if (await canLaunchUrl(mapsUri)) {
      await launchUrl(mapsUri);
    } else {
      throw 'Could not launch $mapsUri';
    }
  }

  Future<void> _launchWhatsApp(String whatsapp) async {
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
        backgroundColor: darkBlue,
        title: Text(
          'Favorite',
          style: TextStyle(color: white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.favorite_outlined,
            color: white,
          ),
          onPressed: () {},
        ),
      ),
      body: _favoriteLowongan.isEmpty
          ? Center(child: Text('Tidak ada lowongan favorit.'))
          : ListView.builder(
              itemCount: _favoriteLowongan.length,
              itemBuilder: (context, index) {
                final lowongan = _favoriteLowongan[index];
                return GestureDetector(
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                lowongan.posisi,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _removeFavorite(lowongan.posisi);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          Text(
                            lowongan.kategori,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.0,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            lowongan.namaKantor,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Batas Lamaran: ${lowongan.tanggalExpired}',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 20),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.ease,
                            height: lowongan.isExpanded ? null : 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kualifikasi:\n${lowongan.kualifikasi}'),
                                Text('Persyaratan:\n${lowongan.persyaratan}'),
                                Text('Catatan:\n${lowongan.catatan}'),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (lowongan.email.isNotEmpty)
                                      ElevatedButton(
                                        onPressed: () {
                                          _launchEmail(lowongan.email);
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
                                    if (lowongan.alamatKantor.isNotEmpty)
                                      ElevatedButton(
                                        onPressed: () {
                                          _launchMaps(lowongan.alamatKantor);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.yellow,
                                        ),
                                        child: Text(
                                          'Lihat Lokasi',
                                          style: TextStyle(color: white),
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                if (lowongan.alamatKantor.isNotEmpty)
                                  ElevatedButton(
                                    onPressed: () {
                                      _launchWhatsApp(lowongan.whatsapp);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                    ),
                                    child: Text(
                                      'Chat Whatsapp',
                                      style: TextStyle(color: white),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _toggleExpansion(index);
                            },
                            child: Text(
                              lowongan.isExpanded
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
                  ),
                );
              },
            ),
    );
  }
}
