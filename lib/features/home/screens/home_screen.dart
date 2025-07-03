import 'package:flutter/material.dart';
import 'package:warlok/features/home/screens/warung_list_page.dart'; // Halaman daftar warung
import 'package:warlok/features/map/screens/map_screen.dart'; // Halaman peta warung
import 'package:warlok/features/profile/screens/profile_screen.dart'; // Halaman profil pengguna

// Halaman utama aplikasi dengan BottomNavigationBar
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Indeks tab yang sedang dipilih (default: 0)

  // Daftar halaman yang ditampilkan sesuai tab yang dipilih
  static const List<Widget> _pages = <Widget>[
    WarungListPage(), // Halaman daftar warung
    MapScreen(),      // Halaman peta warung
    ProfileScreen(),  // Halaman profil pengguna
  ];

  // Fungsi untuk menangani perubahan tab
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update halaman aktif
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gunakan IndexedStack agar state tiap halaman tidak hilang saat pindah tab
      body: IndexedStack(
        index: _selectedIndex, // Tampilkan halaman sesuai tab yang dipilih
        children: _pages,
      ),

      // BottomNavigationBar untuk navigasi antar halaman
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt), 
            label: 'Daftar', // Label untuk tab daftar warung
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined), 
            label: 'Peta', // Label untuk tab peta
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), 
            label: 'Profil', // Label untuk tab profil
          ),
        ],
        currentIndex: _selectedIndex, // Tab yang aktif
        onTap: _onItemTapped, // Panggil saat pengguna tap tab
      ),
    );
  }
}
