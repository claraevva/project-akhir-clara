import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project3/core/color.dart';
import 'package:project3/page/LupaPassword.dart';
import 'package:project3/page/User/TipsPage.dart';

class ProfilUser extends StatefulWidget {
  ProfilUser({Key? key}) : super(key: key);

  @override
  _ProfilUserState createState() => _ProfilUserState();
}

class _ProfilUserState extends State<ProfilUser> {
  final user = FirebaseAuth.instance.currentUser;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('data').child('USER');

  String _name = '';
  String _email = '';
  final TextEditingController _nameController = TextEditingController();
  bool _isEditingName = false; // Flag to control the editing mode

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    if (user != null) {
      final userSnapshot =
          await _database.orderByChild('email').equalTo(user!.email).once();

      final userData = userSnapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null) {
        final userKey = userData.keys.first;
        final userInfo = userData[userKey];

        setState(() {
          _name = userInfo['name'] ?? 'Nama Tidak Tersedia';
          _email = userInfo['email'] ?? 'Email Tidak Tersedia';
          _nameController.text =
              _name; // Set initial value for the name controller
        });
      }
    }
  }

  Future<void> _updateName() async {
    if (user != null) {
      final userSnapshot =
          await _database.orderByChild('email').equalTo(user!.email).once();

      final userData = userSnapshot.snapshot.value as Map<dynamic, dynamic>?;

      if (userData != null) {
        final userKey = userData.keys.first;
        await _database.child(userKey).update({
          'name': _nameController.text,
        });

        setState(() {
          _name = _nameController.text;
          _isEditingName = false; // Exit editing mode after update
        });
      }
    }
  }

  void signout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/LoginUser');
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Anda yakin ingin keluar akun?'),
          actions: <Widget>[
            TextButton(
              child: Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Keluar'),
              onPressed: () {
                Navigator.of(context).pop();
                signout(context);
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
      appBar: AppBar(
        backgroundColor: darkBlue,
        title: Text(
          'Profil',
          style: TextStyle(color: white),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.person,
            color: white,
          ),
          onPressed: () {},
        ),
      ),
      body: Container(
        color: lightBlue,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: darkBlue,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: darkBlue, width: 1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isEditingName = true;
                          });
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              color: darkBlue,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: _isEditingName
                                  ? TextFormField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Nama',
                                        hintStyle: TextStyle(color: darkBlue),
                                      ),
                                      style: TextStyle(
                                          color: darkBlue, fontSize: 18),
                                    )
                                  : Text(
                                      _name,
                                      style: TextStyle(
                                          color: darkBlue, fontSize: 18),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Divider(color: darkBlue, thickness: 1),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _email,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 18),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Email tidak dapat diubah',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                if (_isEditingName)
                  ElevatedButton(
                    onPressed: () {
                      _updateName();
                    },
                    child: Text('Update Nama'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkBlue,
                      foregroundColor: lightBlue,
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TipsPage()),
                    );
                  },
                  child: Text('Lihat Tips Karir'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: lightBlue,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LupaPassword()),
                    );
                  },
                  child: Text('Ubah Password'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: white,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  child: Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkBlue,
                    foregroundColor: lightBlue,
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
