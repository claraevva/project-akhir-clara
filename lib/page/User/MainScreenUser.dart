import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project3/core/color.dart';
import 'package:project3/page/User/FavoritesPage.dart';

import 'package:project3/page/User/HomePageUser.dart';
import 'package:project3/page/User/LoginUser.dart';
import 'package:project3/page/User/ProfilUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreenUser extends StatefulWidget {
  const MainScreenUser({super.key});

  @override
  State<MainScreenUser> createState() => _MainScreenUserState();
}

class _MainScreenUserState extends State<MainScreenUser> {
  int currentTab = 0; // Ensure initial value is within range
  List<Widget> screens = [
    HomePageUser(),
    FavoritesPage(),
    ProfilUser(),
  ];

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    _loadLastTab();
  }

  void _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? loggedIn = prefs.getBool('loggedIn');
    if (loggedIn == null || !loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginUser()),
      );
    }
  }

  Future<void> _loadLastTab() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastTab = prefs.getInt('lastTab') ?? 0;
    setState(() {
      // Ensure lastTab is within the valid range
      if (lastTab >= 0 && lastTab < screens.length) {
        currentTab = lastTab;
      }
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
      MaterialPageRoute(builder: (context) => LoginUser()),
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
            if (index >= 0 && index < screens.length) {
              setState(() {
                currentTab = index;
                _saveLastTab(index);
              });
            }
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
                Icons.favorite_outline,
                color: currentTab == 1 ? white : lightBlue,
              ),
              label: 'Favorite',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outlined,
                color: currentTab == 2 ? white : lightBlue,
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
