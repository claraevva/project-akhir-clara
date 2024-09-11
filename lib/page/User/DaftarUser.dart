import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project3/core/color.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:project3/page/User/Verifikasi.dart';

class DaftarUser extends StatefulWidget {
  const DaftarUser({Key? key}) : super(key: key);

  @override
  State<DaftarUser> createState() => _DaftarUserState();
}

class _DaftarUserState extends State<DaftarUser> {
  bool _obscureText = true;

  // Controllers
  final _formkey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('data').child('USER');
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _addData() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      try {
        // Buat user baru dengan Firebase Authentication
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Kirim email verifikasi
        await userCredential.user!.sendEmailVerification();

        // Ambil ID pengguna yang sudah ada untuk menentukan ID pengguna berikutnya
        final lastUserSnapshot =
            await _database.orderByKey().limitToLast(1).once();
        String newUserKey = 'User1'; // Default ke User1 jika tidak ada pengguna
        if (lastUserSnapshot.snapshot.value != null) {
          final lastUserMap = Map<dynamic, dynamic>.from(
              lastUserSnapshot.snapshot.value as Map);
          int lastIndex =
              int.parse(lastUserMap.keys.first.replaceAll('User', ''));
          newUserKey = 'User${lastIndex + 1}';
        }

        // Simpan data ke database setelah pendaftaran berhasil
        await _database.child(newUserKey).set({
          'name': name,
          'email': email,
        });

        // Clear the text fields
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();

        // Navigasi ke halaman verifikasi setelah pendaftaran berhasil
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Verifikasi()),
        );
      } catch (e) {
        // Registrasi gagal, tampilkan pesan error
        print(e.toString());
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Registrasi Gagal'),
              content: Text('Terjadi kesalahan saat melakukan registrasi.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      print('Semua field harus diisi');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        backgroundColor: lightBlue,
        title: Text(
          'Daftar Akun Pencari Kerja',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Center(
                    child: Container(
                      width: width,
                      height: 200,
                      child: Image.asset('assets/images/DaftarUser.png'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nameController,
                    validator: RequiredValidator(errorText: 'Masukkan Nama'),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: white,
                      hintText: 'Nama',
                      labelText: 'Nama',
                      prefixIcon: Icon(
                        Icons.person,
                        color: darkBlue,
                      ),
                      errorStyle: TextStyle(fontSize: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: darkBlue),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _emailController,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Masukkan Email'),
                      EmailValidator(
                          errorText:
                              'Email tidak valid. Silahkan diisi kembali.'),
                    ]),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: white,
                      hintText: 'Email',
                      labelText: 'Email',
                      prefixIcon: Icon(
                        Icons.email,
                        color: darkBlue,
                      ),
                      errorStyle: TextStyle(fontSize: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: darkBlue),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    validator: MultiValidator([
                      RequiredValidator(errorText: 'Masukkan Password'),
                      MinLengthValidator(6, errorText: 'Minimal 6 Karakter'),
                    ]),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: white,
                      hintText: 'Masukkan Password',
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: darkBlue, // Set warna ikon sesuai dengan tema
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                      prefixIcon: Icon(
                        Icons.key,
                        color: darkBlue,
                      ),
                      errorStyle: TextStyle(fontSize: 10.0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: darkBlue),
                        borderRadius: BorderRadius.all(Radius.circular(9.0)),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      child: TextButton(
                        child: Text(
                          'Daftar',
                          style: TextStyle(
                            color: white,
                            fontSize: 22,
                          ),
                        ),
                        onPressed: _addData,
                        style: TextButton.styleFrom(
                          backgroundColor:
                              darkBlue, // Warna latar belakang tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
