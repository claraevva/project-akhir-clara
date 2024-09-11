import 'package:flutter/material.dart';
import 'package:project3/core/Kategori.dart';
import 'package:project3/page/User/MainScreenUser.dart';
import 'package:project3/page/User/pageHotel.dart';
import 'package:project3/page/User/pageIT.dart';
import 'package:project3/page/User/pagePendidikan.dart';
import 'package:project3/page/User/pageResto.dart';

class KategoriBar extends StatelessWidget {
  final VoidCallback onCategorySelected;
  const KategoriBar({super.key, required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {
                  onCategorySelected();
                  if (index == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreenUser()),
                    );
                  } else if (index == 1) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IT()),
                    );
                  } else if (index == 2) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Pendidikan()),
                    );
                  } else if (index == 3) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Restoran()),
                    );
                  } else if (index == 4) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Hotel()),
                    );
                  }
                },
                child: Container(
                  height: 60,
                  width: 60,
                  child: Icon(
                    categories[index].icon,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                categories[index].title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemCount: categories.length,
      ),
    );
  }
}
