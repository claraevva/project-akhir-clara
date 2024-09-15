import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project3/core/color.dart';
import 'package:project3/page/Admin/LowonganUpdate.dart';
import 'package:project3/page/Admin/SlideAdmin.dart';
import 'package:url_launcher/url_launcher.dart';
import 'ArsipLowongan.dart'; // Import ArsipLowongan
import 'package:project3/core/Lowongan.dart';

class HomePageAdmin extends StatefulWidget {
  @override
  _HomePageAdminState createState() => _HomePageAdminState();
}

class _HomePageAdminState extends State<HomePageAdmin> {
  final DatabaseReference _database = FirebaseDatabase.instance
      .ref()
      .child('data')
      .child('admin')
      .child('lowongan');
  List<Lowongan> _lowongan = [];
  List<Lowongan> _filteredLowongan = [];

  int currentSlide = 0;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    setState(() {});

    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      List<Lowongan> lowongan = [];
      data.forEach((key, value) {
        Lowongan l = Lowongan.fromJson(value, key);
        if (l.isFuture || l.isToday) {
          lowongan.add(l);
        }
      });
      setState(() {
        _lowongan = lowongan;
        _filterLowongan(); // Filter setelah data diambil
      });
    });
  }

  void _filterLowongan() {
    setState(() {
      _filteredLowongan = _lowongan.where((l) {
        final lowerQuery = _searchQuery.toLowerCase();
        return l.posisi.toLowerCase().contains(lowerQuery) ||
            l.namaKantor.toLowerCase().contains(lowerQuery) ||
            l.kategori.toLowerCase().contains(lowerQuery);
      }).toList();
    });
  }

  void _deleteData(String key) {
    setState(() {});

    _database.child(key).remove().then((_) {
      _getData();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil dihapus')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $error')),
      );
    }).whenComplete(() {
      setState(() {});
    });
  }

  void _launchWhatsApp(String whatsapp) async {
    final url = 'https://wa.me/$whatsapp';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tidak dapat membuka WhatsApp')),
      );
    }
  }

  void _launchMaps(String alamatKantor) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=$alamatKantor';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void _launchEmail(String email) async {
    final url = 'mailto:$email';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

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
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SlideAdmin(
                      onChange: (value) {
                        setState(() {
                          currentSlide = value;
                        });
                      },
                      currentSlide: currentSlide,
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                          _filterLowongan();
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Cari Lowongan..',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Data Lowongan Aktif",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArsipLowongan(),
                              ),
                            );
                          },
                          child: Text(
                            "Lihat Arsip",
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (_filteredLowongan.isEmpty) ...[
                      Center(
                        child: Text(
                          'Data Kosong',
                          style: TextStyle(fontSize: 18, color: Colors.black54),
                        ),
                      )
                    ] else ...[
                      ListView.builder(
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
                                    Text(
                                      _filteredLowongan[index].posisi,
                                      style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
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
                                    SizedBox(height: 4),
                                    Text(
                                      'Batas Lamaran: ' +
                                          _filteredLowongan[index]
                                              .tanggalExpired,
                                      style: TextStyle(
                                          color: red,
                                          fontSize: 12.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 20),
                                    AnimatedContainer(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                      height:
                                          _filteredLowongan[index].isExpanded
                                              ? null
                                              : 0,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Kualifikasi:\n' +
                                                  _filteredLowongan[index]
                                                      .kualifikasi,
                                              maxLines: null),
                                          Text(
                                              'Persyaratan:\n' +
                                                  _filteredLowongan[index]
                                                      .persyaratan,
                                              maxLines: null),
                                          Text(
                                              'Catatan:\n' +
                                                  _filteredLowongan[index]
                                                      .catatan,
                                              maxLines: null),
                                          if (_filteredLowongan[index]
                                              .email
                                              .isNotEmpty)
                                            GestureDetector(
                                              onTap: () {
                                                _launchEmail(
                                                  _filteredLowongan[index]
                                                      .email,
                                                );
                                              },
                                              child: Text(
                                                'Email: ' +
                                                    _filteredLowongan[index]
                                                        .email,
                                                style: TextStyle(
                                                  color: red,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          if (_filteredLowongan[index]
                                              .alamatKantor
                                              .isNotEmpty)
                                            GestureDetector(
                                              onTap: () {
                                                _launchMaps(
                                                  _filteredLowongan[index]
                                                      .alamatKantor,
                                                );
                                              },
                                              child: Text(
                                                'Alamat: ' +
                                                    _filteredLowongan[index]
                                                        .alamatKantor,
                                                style: TextStyle(
                                                  color: darkBlue,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          if (_filteredLowongan[index]
                                              .whatsapp
                                              .isNotEmpty)
                                            GestureDetector(
                                              onTap: () {
                                                _launchWhatsApp(
                                                  _filteredLowongan[index]
                                                      .whatsapp,
                                                );
                                              },
                                              child: Text(
                                                'WhatsApp: ' +
                                                    _filteredLowongan[index]
                                                        .whatsapp,
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                            ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          LowonganUpdate(
                                                        keyLowongan:
                                                            _filteredLowongan[
                                                                    index]
                                                                .key,
                                                        kategori:
                                                            _filteredLowongan[
                                                                    index]
                                                                .kategori,
                                                        namaKantor:
                                                            _filteredLowongan[
                                                                    index]
                                                                .namaKantor,
                                                        posisi:
                                                            _filteredLowongan[
                                                                    index]
                                                                .posisi,
                                                        kualifikasi:
                                                            _filteredLowongan[
                                                                    index]
                                                                .kualifikasi,
                                                        persyaratan:
                                                            _filteredLowongan[
                                                                    index]
                                                                .persyaratan,
                                                        alamatKantor:
                                                            _filteredLowongan[
                                                                    index]
                                                                .alamatKantor,
                                                        email:
                                                            _filteredLowongan[
                                                                    index]
                                                                .email,
                                                        tanggalExpired:
                                                            _filteredLowongan[
                                                                    index]
                                                                .tanggalExpired,
                                                        catatan:
                                                            _filteredLowongan[
                                                                    index]
                                                                .catatan,
                                                        whatsapp: _filteredLowongan[
                                                                index]
                                                            .whatsapp, // Kirim catatan ke LowonganUpdate
                                                      ),
                                                    ),
                                                  ).then((_) {
                                                    _getData();
                                                  });
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.edit,
                                                      color: darkBlue,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 5),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                            'Konfirmasi Hapus'),
                                                        content: Text(
                                                            'Apakah Anda yakin ingin menghapus data ini?'),
                                                        actions: [
                                                          TextButton(
                                                            child:
                                                                Text('Batal'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                          ),
                                                          TextButton(
                                                            child:
                                                                Text('Hapus'),
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              _deleteData(
                                                                  _filteredLowongan[
                                                                          index]
                                                                      .key);
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.delete,
                                                      color: red,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _filteredLowongan[index].isExpanded =
                                              !_filteredLowongan[index]
                                                  .isExpanded;
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
