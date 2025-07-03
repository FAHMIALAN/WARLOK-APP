import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warlok/core/widgets/custom_button.dart';
import 'package:warlok/features/auth/services/auth_service.dart';

// Widget ini bersifat StatelessWidget karena tidak mengelola state lokal yang berubah-ubah.
// Ia hanya menampilkan data dari user yang sedang login.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengambil objek User yang sedang login saat ini langsung dari instance FirebaseAuth.
    final User? user = FirebaseAuth.instance.currentUser;
    // Membuat instance dari AuthService untuk mengakses fungsi logout.
    final AuthService authService = AuthService();

    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          // mainAxisAlignment & crossAxisAlignment akan membuat semua elemen di tengah.
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Widget untuk menampilkan avatar atau ikon profil.
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 24),
            // Label statis.
            Text(
              "Email Pengguna:",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium
            ),
            // Menampilkan email pengguna.
            // `user?.email` (null-aware) untuk menghindari error jika user null.
            // `?? "Tidak ada email"` (null-coalescing) untuk memberikan teks default jika emailnya null.
            Text(
              user?.email ?? "Tidak ada email",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall
            ),
            // `Spacer` adalah widget fleksibel yang akan mengisi semua ruang kosong yang tersedia,
            // sehingga mendorong tombol Logout ke bagian paling bawah layar.
            const Spacer(),
            // Tombol Logout custom kita.
            CustomButton(
              text: "Logout",
              // Saat ditekan, panggil fungsi signOut dari AuthService.
              // Setelah itu, AuthWrapper di main.dart akan otomatis mendeteksi
              // perubahan status dan mengarahkan ke halaman login.
              onPressed: () async => await authService.signOut()
            ),
          ],
        ),
      ),
    );
  }
}