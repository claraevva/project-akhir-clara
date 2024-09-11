import 'package:flutter/material.dart';

class Kategori {
  final String title;
  final IconData icon;

  Kategori({required this.title, required this.icon});
}

final List<Kategori> categories = [
  Kategori(title: "Semua Kategori", icon: Icons.grid_view_outlined),
  Kategori(title: "IT", icon: Icons.computer_outlined),
  Kategori(title: "Pendidikan", icon: Icons.school_outlined),
  Kategori(title: "Restoran", icon: Icons.restaurant_outlined),
  Kategori(title: "Hotel", icon: Icons.hotel),
];
