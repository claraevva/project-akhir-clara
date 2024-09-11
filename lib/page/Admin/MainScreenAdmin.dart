import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project3/core/color.dart';
import 'package:project3/page/Admin/HomePageAdmin.dart';
import 'package:project3/page/Admin/UserData.dart';
import 'package:project3/page/Admin/TambahLowongan.dart';
import 'package:project3/page/Admin/ProfilAdmin.dart';
import 'package:project3/page/Admin/LoginAdmin.dart';

class MainScreenAdmin extends StatefulWidget {
  const MainScreenAdmin({super.key});

  @override
  State<MainScreenAdmin> createState() => _MainScreenAdminState();
}

class _MainScreenAdminState extends State<MainScreenAdmin> {
  int currentTab = 0;
  List<Widget> screens = [
    HomePageAdmin(),
    Users(),
    TambahLowongan(),
    ProfilAdmin(),
  ];

  @override
  void initState() {
    super.initState();
    _loadLastTab();
  }

  Future<void> _loadLastTab() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      currentTab = prefs.getInt('lastTab') ?? 0;
    });
  }

  Future<void> _saveLastTab(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastTab', index);
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Konfirmasi'),
            content: Text('Apakah Anda yakin ingin keluar?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Exit
                },
                child: Text('Keluar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // Cancel
                },
                child: Text('Batal'),
              ),
            ],
          ),
        )) ??
        false;
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', false);
    await prefs.remove('lastTab');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginAdmin()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CupertinoTabBar(
          backgroundColor: darkBlue,
          currentIndex: currentTab,
          onTap: (int index) {
            setState(() {
              currentTab = index;
              _saveLastTab(index);
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: currentTab == 0 ? white : lightBlue,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_add_outlined,
                color: currentTab == 1 ? white : lightBlue,
              ),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_outlined,
                color: currentTab == 2 ? white : lightBlue,
              ),
              label: 'Lowongan',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outlined,
                color: currentTab == 3 ? white : lightBlue,
              ),
              label: 'Profil',
            ),
          ],
        ),
        body: screens[currentTab],
      ),
    );
  }
}
