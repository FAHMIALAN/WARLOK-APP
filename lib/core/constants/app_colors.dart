import 'package:flutter/material.dart';

// Kelas statis untuk menyimpan warna-warna utama aplikasi
class AppColors {
  // Warna utama (utama terang) digunakan untuk tema dan elemen utama
  static const Color primary = Colors.orange;

  // Warna utama gelap, digunakan untuk variasi shade (misal AppBar)
  static final Color primaryDark = Colors.orange.shade700;

  // Warna aksen, digunakan untuk elemen sekunder (misal tombol, ikon)
  static const Color accent = Colors.amber;
}
