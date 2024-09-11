import 'package:flutter/material.dart';
import 'package:project3/core/color.dart';
import 'package:project3/page/Admin/UbahPassword.dart';

class ProfilAdmin extends StatelessWidget {
  ProfilAdmin({Key? key}) : super(key: key);

  void signout(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/LoginAdmin');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible:
          false, // Membuat dialog tidak bisa ditutup dengan klik di luar dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Anda yakin ingin keluar akun?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Menutup dialog tanpa melakukan logout
              },
            ),
            TextButton(
              child: Text('Keluar'),
              onPressed: () {
                Navigator.of(context).pop(); // Menutup dialog
                signout(context); // Melakukan logout
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          lightBlue, // Mengubah warna latar belakang menjadi lightBlue
      appBar: AppBar(
        backgroundColor:
            darkBlue, // Mengubah warna latar belakang AppBar menjadi darkBlue
        title: Text(
          'Profil',
          style: TextStyle(
              color: white), // Mengubah warna teks AppBar menjadi putih
        ),
        leading: IconButton(
          icon: Icon(Icons.person,
              color:
                  white), // Mengganti panah dengan ikon person warna lightBlue
          onPressed: () {},
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundColor:
                  darkBlue, // Mengubah warna latar belakang CircleAvatar menjadi darkBlue
              child: Icon(
                Icons.person,
                size: 50,
                color:
                    lightBlue, // Mengubah warna ikon person menjadi lightBlue
              ),
            ),
            SizedBox(height: 20),
            // Informasi Profil
            Container(
              width: MediaQuery.of(context).size.width *
                  0.8, // Mengatur lebar kotak
              decoration: BoxDecoration(
                color: Colors
                    .white, // Mengubah warna latar belakang kotak menjadi putih
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: darkBlue,
                    width: 1), // Menambahkan garis tepi tipis berwarna darkBlue
                boxShadow: [
                  BoxShadow(
                    color: lightBlue.withOpacity(
                        0.3), // Menambahkan bayangan tipis berwarna biru
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        color:
                            darkBlue, // Mengubah warna ikon person dalam box menjadi darkBlue
                      ),
                      SizedBox(width: 10),
                      Text(
                        "admin",
                        style: TextStyle(
                          color: darkBlue, // Mengubah warna teks menjadi biru
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Contoh menu di halaman utama admin
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UbahPassword()),
                );
              },
              child: Text('Ubah Password'),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlue,
                foregroundColor: white,
              ),
            ),
            SizedBox(height: 20),
            // Tombol Logout di bawah box
            ElevatedButton(
              onPressed: () {
                _showLogoutDialog(
                    context); // Menampilkan dialog konfirmasi saat tombol ditekan
              },
              child: Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: darkBlue, // Warna latar belakang tombol
                foregroundColor: lightBlue, // Warna teks tombol
              ),
            ),
          ],
        ),
      ),
    );
  }
}
