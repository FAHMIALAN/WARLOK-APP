import 'package:flutter/material.dart';
import 'package:warlok/core/widgets/custom_button.dart';
import 'package:warlok/features/auth/services/auth_service.dart';

// Menggunakan StatefulWidget karena kita perlu mengelola state dari
// input form dan status loading.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controller untuk setiap kolom input teks (TextField).
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  // Instance dari service otentikasi.
  final _authService = AuthService();
  // State untuk mengontrol tampilan loading pada tombol.
  bool _isLoading = false;

  /// Fungsi yang dipanggil saat tombol "Daftar" ditekan.
  void _register() async {
    // 1. Validasi di sisi klien: Pastikan password dan konfirmasi password sama.
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Password konfirmasi tidak cocok."),
          backgroundColor: Colors.red));
      return; // Hentikan proses jika tidak cocok.
    }

    // 2. Aktifkan loading indicator dan panggil service.
    setState(() => _isLoading = true);
    final errorMessage = await _authService.registerWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );
    // Safety check: Pastikan halaman masih ada sebelum update UI.
    if (!mounted) return;
    // Hentikan loading indicator setelah proses selesai.
    setState(() => _isLoading = false);

    // 3. Tangani hasil dari service.
    // Jika tidak ada pesan error (null), berarti berhasil.
    if (errorMessage == null) {
      // Kembali ke halaman login setelah berhasil.
      Navigator.pop(context);
      // Beri notifikasi sukses di halaman login.
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Pendaftaran berhasil! Silakan login."),
          backgroundColor: Colors.green));
    } else {
      // Jika ada pesan error, tampilkan pesan tersebut kepada pengguna.
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Akun Baru")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("Buat Akun",
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 32),
            // TextField dihubungkan dengan controller masing-masing.
            TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email)),
                keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 16),
            TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock)),
                // `obscureText: true` untuk menyembunyikan teks password.
                obscureText: true),
            const SizedBox(height: 16),
            TextField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                    labelText: "Konfirmasi Password",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline)),
                obscureText: true),
            const SizedBox(height: 32),
            // Tombol custom yang `onPressed`-nya memanggil fungsi _register.
            // Status `isLoading`-nya terhubung dengan state _isLoading.
            CustomButton(text: "Daftar", onPressed: _register, isLoading: _isLoading),
          ],
        ),
      ),
    );
  }
}