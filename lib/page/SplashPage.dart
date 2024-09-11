import 'package:flutter/material.dart';
import 'package:project3/core/color.dart';
import 'package:project3/page/Admin/LoginAdmin.dart';
import 'package:project3/page/User/LoginUser.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: lightBlue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(height: 25),
            const Text('Halo Basudara !',
                style: TextStyle(
                    color: darkBlue,
                    fontSize: 25,
                    letterSpacing: 1.8,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text(
              'Selamat datang di LOKERAMQ !!',
              style: TextStyle(
                color: darkBlue,
                fontSize: 16,
                letterSpacing: 1.8,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 350,
              width: 450,
              child: Image.asset('assets/images/splashimage.png'),
            ),
            const SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => LoginAdmin()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Masuk sebagai Admin',
                  style: TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (builder) => LoginUser()));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  color: darkBlue,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  'Masuk sebagai Pencari Kerja',
                  style: TextStyle(
                    color: white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
