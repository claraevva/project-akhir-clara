import 'package:flutter/material.dart';
import 'package:project3/page/User/LoginUser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project3/core/color.dart';
import 'package:project3/page/User/KategoriBar.dart';
import 'package:project3/page/User/SlideUser.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    required this.tanggalExpired,
    required this.catatan,
    required this.whatsapp,
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
      tanggalExpired: json['tanggalExpired'] ?? '',
      catatan: json['catatan'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
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
      'whatsapp': whatsapp,
      'isExpanded': isExpanded,
      'isFavorite': isFavorite,
    };
  }
}

class HomePageUser extends StatefulWidget {
  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  final ScrollController _scrollController = ScrollController();
  final DatabaseReference _database = FirebaseDatabase.instance
      .ref()
      .child('data')
      .child('admin')
      .child('lowongan');
  final DatabaseReference _favoritesRef = FirebaseDatabase.instance
      .ref()
      .child('favorites')
      .child(FirebaseAuth.instance.currentUser!.uid);

  List<Lowongan> _lowongan = [];
  List<Lowongan> _filteredLowongan = [];
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int currentSlide = 0;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _getData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
        _filterLowongan();
      });
    });
  }

  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('loggedIn');
    if (loggedIn == null || !loggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginUser()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void _getData() {
    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      List<Lowongan> lowongan = [];
      data.forEach((key, value) {
        Lowongan item = Lowongan.fromJson(value);
        DateTime? expiredDate =
            DateFormat('yyyy-MM-dd').parse(item.tanggalExpired, true);
        DateTime today = DateTime.now();
        if (expiredDate.isAfter(today) || expiredDate.isAtSameMomentAs(today)) {
          lowongan.add(item);
        }
      });
      _updateFavorites(lowongan);
    });
  }

  void _updateFavorites(List<Lowongan> lowongan) async {
    DataSnapshot snapshot = await _favoritesRef.get();
    Map<dynamic, dynamic> favoritesData =
        snapshot.value as Map<dynamic, dynamic>? ?? {};
    setState(() {
      _lowongan = lowongan.map((l) {
        l.isFavorite = favoritesData
            .containsKey(l.posisi); // Assuming `posisi` as the unique key
        return l;
      }).toList();
      _filteredLowongan = _lowongan;
    });
  }

  void _filterLowongan() {
    setState(() {
      _filteredLowongan = _lowongan.where((lowongan) {
        return lowongan.posisi.toLowerCase().contains(_searchQuery) ||
            lowongan.kategori.toLowerCase().contains(_searchQuery) ||
            lowongan.namaKantor.toLowerCase().contains(_searchQuery);
      }).toList();
    });
  }

  void _toggleFavorite(Lowongan lowongan) async {
    if (lowongan.isFavorite) {
      await _favoritesRef.child(lowongan.posisi).remove();
    } else {
      await _favoritesRef.child(lowongan.posisi).set(lowongan.toJson());
    }

    setState(() {
      lowongan.isFavorite = !lowongan.isFavorite;
    });
  }

  void _launchEmail(String email) async {
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

  void _launchMaps(String address) async {
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

  void _launchWhatsApp(String whatsapp) async {
    final String whatsappUrl = 'https://wa.me/$whatsapp';
    final Uri whatsappUri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri);
    } else {
      throw 'Could not launch $whatsappUri';
    }
  }

  void _scrollToLowongan() {
    // Scroll to the position where the "Lowongan Tersedia" section starts
    _scrollController.animateTo(
      250, // Adjust this value based on your layout
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        backgroundColor: darkBlue,
        leading: const SizedBox(),
        leadingWidth: 0,
        centerTitle: false,
        title: Image.asset(
          "assets/images/logoapk.png",
          height: 80,
          width: 100,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideUser(
                  onChange: (value) {
                    setState(() {
                      currentSlide = value;
                    });
                  },
                  currentSlide: currentSlide,
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Cari Lowongan..',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                KategoriBar(onCategorySelected: _scrollToLowongan),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Lowongan Tersedia",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                ListView.builder(
                  controller: _scrollController,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _filteredLowongan.length,
                  itemBuilder: (context, index) {
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    _filteredLowongan[index].posisi,
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _filteredLowongan[index].isFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: _filteredLowongan[index].isFavorite
                                          ? Colors.red
                                          : null,
                                    ),
                                    onPressed: () {
                                      _toggleFavorite(_filteredLowongan[index]);
                                    },
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text(
                                _filteredLowongan[index].kategori,
                                style: TextStyle(
                                  color: black,
                                  fontSize: 10.0,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _filteredLowongan[index].namaKantor,
                                style: TextStyle(
                                  color: black,
                                  fontSize: 15.0,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                'Batas Lamaran: ${_filteredLowongan[index].tanggalExpired}',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 500),
                                curve: Curves.ease,
                                height: _filteredLowongan[index].isExpanded
                                    ? null
                                    : 0,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        'Kualifikasi:\n${_filteredLowongan[index].kualifikasi}'),
                                    Text(
                                        'Persyaratan:\n${_filteredLowongan[index].persyaratan}'),
                                    Text(
                                        'Catatan:\n${_filteredLowongan[index].catatan}'),
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        if (_filteredLowongan[index]
                                            .email
                                            .isNotEmpty)
                                          ElevatedButton(
                                            onPressed: () {
                                              _launchEmail(
                                                  _filteredLowongan[index]
                                                      .email);
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
                                        if (_filteredLowongan[index]
                                            .alamatKantor
                                            .isNotEmpty)
                                          ElevatedButton(
                                            onPressed: () {
                                              _launchMaps(
                                                  _filteredLowongan[index]
                                                      .alamatKantor);
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.yellow,
                                            ),
                                            child: Text(
                                              'Lihat Lokasi',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    if (_filteredLowongan[index]
                                        .whatsapp
                                        .isNotEmpty)
                                      ElevatedButton(
                                        onPressed: () {
                                          _launchWhatsApp(
                                              _filteredLowongan[index]
                                                  .whatsapp);
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
                                    _filteredLowongan[index].isExpanded =
                                        !_filteredLowongan[index].isExpanded;
                                  });
                                },
                                child: Text(
                                  _filteredLowongan[index].isExpanded
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
