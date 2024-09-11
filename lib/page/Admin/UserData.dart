import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:project3/core/color.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final Query _databaseReference =
      FirebaseDatabase.instance.ref().child('data').child('USER');

  // Menyimpan string pencarian
  String _searchQuery = '';

  // Widget untuk menampilkan setiap item dalam daftar
  Widget _listItem({required Map user}) {
    String userId = user['key'] ?? 'Unknown'; // Menampilkan ID pengguna
    String name = user['name'] ?? 'No Name';
    String email = user['email'] ?? 'No Email';

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 110,
      color: darkBlue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "ID: $userId", // Menampilkan ID pengguna
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: white),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Nama: $name", // Menampilkan nama pengguna
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: white),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            "Email: $email", // Menampilkan email pengguna
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w400, color: white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBlue,
      appBar: AppBar(
        backgroundColor:
            darkBlue, // Mengubah warna latar belakang AppBar menjadi darkBlue
        title: Text(
          'Data User',
          style: TextStyle(
              color: white), // Mengubah warna teks AppBar menjadi putih
        ),
        leading: IconButton(
          icon: Icon(Icons.person_add,
              color:
                  white), // Mengganti panah dengan ikon person warna lightBlue
          onPressed: () {},
        ),
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery =
                      value.toLowerCase(); // Memperbarui query pencarian
                });
              },
              decoration: InputDecoration(
                labelText: 'Cari Data User..',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: _databaseReference,
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                Map user = snapshot.value as Map;
                user['key'] = snapshot
                    .key; // Menambahkan key sebagai bagian dari data pengguna

                // Filter berdasarkan ID, Nama, atau Email
                String userId = user['key'].toString().toLowerCase();
                String name = user['name'].toString().toLowerCase();
                String email = user['email'].toString().toLowerCase();

                // Jika pencarian kosong, tampilkan semua, jika tidak, tampilkan sesuai query
                if (_searchQuery.isEmpty ||
                    userId.contains(_searchQuery) ||
                    name.contains(_searchQuery) ||
                    email.contains(_searchQuery)) {
                  return _listItem(user: user);
                } else {
                  return Container(); // Jika tidak sesuai dengan pencarian, jangan tampilkan
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
