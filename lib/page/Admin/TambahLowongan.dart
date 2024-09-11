import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project3/core/color.dart';
import 'package:intl/intl.dart';

class TambahLowongan extends StatefulWidget {
  @override
  _TambahLowonganState createState() => _TambahLowonganState();
}

final DatabaseReference database =
    FirebaseDatabase.instance.ref().child('data').child('admin');
int counter = 1;

class _TambahLowonganState extends State<TambahLowongan> {
  final _formKey = GlobalKey<FormState>();
  String selectedCategory = 'IT';
  TextEditingController _namaKantorController = TextEditingController();
  TextEditingController _posisiController = TextEditingController();
  TextEditingController _kualifikasiController = TextEditingController();
  TextEditingController _persyaratanController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _alamatKantorController = TextEditingController();
  TextEditingController _tanggalExpiredController = TextEditingController();
  TextEditingController _catatanController = TextEditingController();
  TextEditingController _whatsappController = TextEditingController();

  DateTime? _tanggalExpired;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _tanggalExpired) {
      setState(() {
        _tanggalExpired = picked;
        _tanggalExpiredController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void simpanData() {
    if (_formKey.currentState?.validate() ?? false) {
      String key = 'lowongan$counter';
      Map<String, dynamic> lowonganData = {
        'kategori': selectedCategory,
        'namaKantor': _namaKantorController.text,
        'posisi': _posisiController.text,
        'kualifikasi': _kualifikasiController.text,
        'persyaratan': _persyaratanController.text,
        'email': _emailController.text,
        'alamatKantor': _alamatKantorController.text,
        'tanggalExpired': _tanggalExpiredController.text,
        'catatan': _catatanController.text,
      };

      if (_whatsappController.text.isNotEmpty) {
        lowonganData['whatsapp'] = _whatsappController.text;
      }

      database.child('lowongan').child(key).set(lowonganData).then((value) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Sukses'),
              content: Text('Data berhasil ditambahkan'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        _namaKantorController.clear();
        _posisiController.clear();
        _kualifikasiController.clear();
        _persyaratanController.clear();
        _emailController.clear();
        _alamatKantorController.clear();
        _tanggalExpiredController.clear();
        _catatanController.clear();
        _whatsappController.clear();
        _tanggalExpired = null;
      });
      counter++;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text('Silakan isi semua kolom wajib yang diperlukan.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: Text('Tambah Lowongan'),
        foregroundColor: white,
        leading: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            // Implementasikan aksi yang diinginkan ketika ikon ditekan
            // Contoh: Navigator.pop(context); jika ingin kembali ke halaman sebelumnya
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Pilih kategori pekerjaan :',
                style: TextStyle(fontSize: 16),
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      selectedCategory = newValue;
                    });
                  }
                },
                items: <String>['IT', 'Pendidikan', 'Restoran', 'Hotel']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) =>
                    value == null ? 'Kategori harus dipilih' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _namaKantorController,
                decoration: InputDecoration(labelText: 'Nama Kantor'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Nama Kantor harus diisi' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _posisiController,
                decoration: InputDecoration(labelText: 'Posisi Pekerjaan'),
                validator: (value) => value?.isEmpty ?? true
                    ? 'Posisi Pekerjaan harus diisi'
                    : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _kualifikasiController,
                decoration: InputDecoration(labelText: 'Kualifikasi'),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Kualifikasi harus diisi' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _persyaratanController,
                decoration: InputDecoration(labelText: 'Persyaratan'),
                maxLines: 3,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Persyaratan harus diisi' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email Kantor'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Email Kantor harus diisi' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _alamatKantorController,
                decoration: InputDecoration(labelText: 'Alamat Kantor'),
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Alamat Kantor harus diisi' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _tanggalExpiredController,
                decoration: InputDecoration(
                  labelText: 'Batas Lamaran',
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ),
                readOnly: true,
                validator: (value) =>
                    value?.isEmpty ?? true ? 'Batas Lamaran harus diisi' : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _catatanController,
                decoration: InputDecoration(
                  labelText: 'Catatan',
                  hintText: 'Tambahkan catatan',
                ),
                maxLines: 5,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _whatsappController,
                decoration: InputDecoration(
                  labelText: 'Nomor WhatsApp',
                  helperText: 'Nomor harus diawali dengan +62 dan hanya angka.',
                  helperStyle: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    String cleanValue = value.replaceAll(RegExp(r'\D'), '');

                    if (!cleanValue.startsWith('62')) {
                      return 'Nomor WhatsApp harus diawali dengan +62';
                    }
                    if (cleanValue.length < 10) {
                      return 'Nomor WhatsApp tidak valid';
                    }
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  simpanData();
                },
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _namaKantorController.dispose();
    _posisiController.dispose();
    _kualifikasiController.dispose();
    _persyaratanController.dispose();
    _emailController.dispose();
    _alamatKantorController.dispose();
    _tanggalExpiredController.dispose();
    _catatanController.dispose();
    _whatsappController.dispose();
    super.dispose();
  }
}
