import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project3/core/color.dart';
import 'package:intl/intl.dart'; // Pastikan menambahkan intl ke pubspec.yaml

class LowonganUpdate extends StatefulWidget {
  final String keyLowongan;
  final String kategori;
  final String namaKantor;
  final String posisi;
  final String kualifikasi;
  final String persyaratan;
  final String alamatKantor;
  final String email;
  final String tanggalExpired;
  final String catatan;
  final String whatsapp;

  LowonganUpdate({
    required this.keyLowongan,
    required this.kategori,
    required this.namaKantor,
    required this.posisi,
    required this.kualifikasi,
    required this.persyaratan,
    required this.alamatKantor,
    required this.email,
    required this.tanggalExpired,
    required this.catatan,
    required this.whatsapp,
  });

  @override
  _LowonganUpdateState createState() => _LowonganUpdateState();
}

class _LowonganUpdateState extends State<LowonganUpdate> {
  final DatabaseReference _database = FirebaseDatabase.instance
      .ref()
      .child('data')
      .child('admin')
      .child('lowongan');

  late TextEditingController _namaKantorController;
  late TextEditingController _posisiController;
  late TextEditingController _kualifikasiController;
  late TextEditingController _persyaratanController;
  late TextEditingController _emailController;
  late TextEditingController _alamatKantorController;
  late TextEditingController _tanggalExpiredController;
  late TextEditingController _catatanController;
  late TextEditingController _whatsappController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.kategori;
    _namaKantorController = TextEditingController(text: widget.namaKantor);
    _posisiController = TextEditingController(text: widget.posisi);
    _kualifikasiController = TextEditingController(text: widget.kualifikasi);
    _persyaratanController = TextEditingController(text: widget.persyaratan);
    _emailController = TextEditingController(text: widget.email);
    _alamatKantorController = TextEditingController(text: widget.alamatKantor);
    _tanggalExpiredController =
        TextEditingController(text: widget.tanggalExpired);
    _catatanController = TextEditingController(text: widget.catatan);
    _whatsappController = TextEditingController(text: widget.whatsapp);
  }

  void _updateLowongan() {
    final Map<String, dynamic> updateData = {
      'kategori': _selectedCategory,
      'namaKantor': _namaKantorController.text,
      'posisi': _posisiController.text,
      'kualifikasi': _kualifikasiController.text,
      'persyaratan': _persyaratanController.text,
      'tanggalExpired': _tanggalExpiredController.text,
      'catatan': _catatanController.text,
    };

    // Update hanya jika field tidak kosong
    if (_emailController.text.isNotEmpty) {
      updateData['email'] = _emailController.text;
    }
    if (_alamatKantorController.text.isNotEmpty) {
      updateData['alamatKantor'] = _alamatKantorController.text;
    }
    if (_whatsappController.text.isNotEmpty) {
      updateData['whatsapp'] = _whatsappController.text;
    }

    _database.child(widget.keyLowongan).update(updateData).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data berhasil diperbarui')),
      );
      Navigator.of(context).pop(); // Kembali ke halaman sebelumnya
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui data: $error')),
      );
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.tryParse(_tanggalExpiredController.text) ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        picked != DateTime.tryParse(_tanggalExpiredController.text)) {
      setState(() {
        _tanggalExpiredController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: Text('Edit Lowongan'),
        foregroundColor: white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pilih kategori pekerjaan:',
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<String>(
              value: _selectedCategory,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
              items: <String>['IT', 'Pendidikan', 'Restoran', 'Hotel']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _namaKantorController,
              decoration: InputDecoration(labelText: 'Nama Kantor'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _posisiController,
              decoration: InputDecoration(labelText: 'Posisi Pekerjaan'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _kualifikasiController,
              decoration: InputDecoration(labelText: 'Kualifikasi'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _persyaratanController,
              decoration: InputDecoration(labelText: 'Persyaratan'),
              maxLines: 3,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email Kantor'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _alamatKantorController,
              decoration: InputDecoration(labelText: 'Alamat Kantor'),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _tanggalExpiredController,
              decoration: InputDecoration(
                labelText: 'Tanggal Expired',
                hintText: 'YYYY-MM-DD',
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _catatanController,
              decoration: InputDecoration(labelText: 'Catatan'),
              maxLines: 5,
            ),
            TextFormField(
              controller: _whatsappController,
              decoration: InputDecoration(
                labelText: 'Nomor WhatsApp',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) {
                  return 'Nomor WhatsApp harus diisi';
                }
                if (!RegExp(r'^\d+$').hasMatch(value!)) {
                  return 'Nomor WhatsApp harus berupa angka';
                }
                return null;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateLowongan,
              child: Text('Perbarui'),
            ),
          ],
        ),
      ),
    );
  }
}
