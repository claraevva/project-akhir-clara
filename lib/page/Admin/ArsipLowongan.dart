import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project3/core/color.dart';
import 'package:project3/page/Admin/LowonganUpdate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:project3/core/Lowongan.dart';

class ArsipLowongan extends StatefulWidget {
  @override
  _ArsipLowonganState createState() => _ArsipLowonganState();
}

class _ArsipLowonganState extends State<ArsipLowongan> {
  final DatabaseReference _database = FirebaseDatabase.instance
      .ref()
      .child('data')
      .child('admin')
      .child('lowongan');
  List<Lowongan> _lowongan = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() {
    setState(() {
      _isLoading = true;
    });

    _database.onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      List<Lowongan> lowongan = [];
      data.forEach((key, value) {
        Lowongan l = Lowongan.fromJson(value, key);
        if (l.isExpired) {
          lowongan.add(l);
        }
      });
      setState(() {
        _lowongan = lowongan;
        _isLoading = false;
      });
    });
  }

  void _deleteData(String key) {
    setState(() {
      _isLoading = true;
    });

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
      setState(() {
        _isLoading = false;
      });
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
                    const Text(
                      "Arsip Lowongan",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: _lowongan.length,
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
                                    _lowongan[index].posisi,
                                    style: TextStyle(
                                      color: black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _lowongan[index].kategori,
                                    style: TextStyle(
                                      color: black,
                                      fontSize: 10.0,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    _lowongan[index].namaKantor,
                                    style: TextStyle(
                                      color: black,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Batas Lamaran: ' +
                                        _lowongan[index].tanggalExpired,
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
                                        _lowongan[index].isExpanded ? null : 0,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            'Kualifikasi:\n' +
                                                _lowongan[index].kualifikasi,
                                            maxLines: null),
                                        Text(
                                            'Persyaratan:\n' +
                                                _lowongan[index].persyaratan,
                                            maxLines: null),
                                        Text(
                                            'Catatan:\n' +
                                                _lowongan[index].catatan,
                                            maxLines: null),
                                        if (_lowongan[index].email.isNotEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              _launchEmail(
                                                _lowongan[index].email,
                                              );
                                            },
                                            child: Text(
                                              'Email: ' +
                                                  _lowongan[index].email,
                                              style: TextStyle(
                                                color: red,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        if (_lowongan[index]
                                            .alamatKantor
                                            .isNotEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              _launchMaps(
                                                _lowongan[index].alamatKantor,
                                              );
                                            },
                                            child: Text(
                                              'Alamat: ' +
                                                  _lowongan[index].alamatKantor,
                                              style: TextStyle(
                                                color: darkBlue,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        if (_lowongan[index]
                                            .whatsapp
                                            .isNotEmpty)
                                          GestureDetector(
                                            onTap: () {
                                              _launchWhatsApp(
                                                _lowongan[index].whatsapp,
                                              );
                                            },
                                            child: Text(
                                              'WhatsApp: ' +
                                                  _lowongan[index].whatsapp,
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
                                                          _lowongan[index].key,
                                                      kategori: _lowongan[index]
                                                          .kategori,
                                                      namaKantor:
                                                          _lowongan[index]
                                                              .namaKantor,
                                                      posisi: _lowongan[index]
                                                          .posisi,
                                                      kualifikasi:
                                                          _lowongan[index]
                                                              .kualifikasi,
                                                      persyaratan:
                                                          _lowongan[index]
                                                              .persyaratan,
                                                      alamatKantor:
                                                          _lowongan[index]
                                                              .alamatKantor,
                                                      email: _lowongan[index]
                                                          .email,
                                                      tanggalExpired:
                                                          _lowongan[index]
                                                              .tanggalExpired,
                                                      catatan: _lowongan[index]
                                                          .catatan,
                                                      whatsapp: _lowongan[index]
                                                          .whatsapp,
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
                                                          child: Text('Batal'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                        ),
                                                        TextButton(
                                                          child: Text('Hapus'),
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                            _deleteData(
                                                                _lowongan[index]
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
                                        _lowongan[index].isExpanded =
                                            !_lowongan[index].isExpanded;
                                      });
                                    },
                                    child: Text(
                                      _lowongan[index].isExpanded
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
                    if (_isLoading) ...[
                      Center(
                        child: CircularProgressIndicator(),
                      )
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
