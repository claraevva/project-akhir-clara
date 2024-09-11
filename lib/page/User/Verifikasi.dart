import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project3/page/User/LoginUser.dart';

class Verifikasi extends StatefulWidget {
  _VerifikasiState createState() => _VerifikasiState();
}

class _VerifikasiState extends State<Verifikasi> {
  final auth = FirebaseAuth.instance;
  late User user;
  late Timer timer;

  void initState() {
    user = auth.currentUser!;
    user.sendEmailVerification();

    Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  Future<void> checkEmailVerified() async {
    user = auth.currentUser!;
    await user.reload();
    if (user.emailVerified) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginUser()));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
            "Link telah dikirim. \n Silahkan cek email anda untuk verifikasi.",
            textAlign: TextAlign.center),
      ),
    );
  }
}
