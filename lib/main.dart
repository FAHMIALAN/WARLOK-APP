import 'package:firebase_auth/firebase_auth.dart'; // Untuk autentikasi pengguna
import 'package:firebase_core/firebase_core.dart'; // Untuk inisialisasi Firebase
import 'package:flutter/material.dart';
import 'package:warlok/features/auth/screens/login_screen.dart'; // Halaman login
import 'package:warlok/features/home/screens/home_screen.dart'; // Halaman home setelah login
import 'package:warlok/firebase_options.dart'; // Konfigurasi Firebase yang dihasilkan otomatis

// Fungsi utama aplikasi
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Pastikan Flutter terhubung dengan binding sebelum async
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Inisialisasi Firebase dengan konfigurasi yang sesuai platform
  );
  runApp(const MyApp()); // Jalankan aplikasi
}

// Widget utama aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WARLOK', // Judul aplikasi
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange), // Skema warna utama
        useMaterial3: true, // Menggunakan Material Design 3
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.orange.shade700, // Warna latar AppBar
          foregroundColor: Colors.white, // Warna teks/icon AppBar
          elevation: 4, // Bayangan AppBar
        ),
      ),
      debugShowCheckedModeBanner: false, // Hilangkan banner debug
      home: const AuthWrapper(), // Mulai dari widget AuthWrapper
    );
  }
}

// Widget ini berfungsi sebagai gerbang otentikasi
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Pantau status login user
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Jika masih proses cek status login, tampilkan loading
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasData) {
          // Jika sudah login, arahkan ke halaman Home
          return const HomeScreen();
        }
        // Jika belum login, arahkan ke halaman Login
        return const LoginScreen();
      },
    );
  }
}
