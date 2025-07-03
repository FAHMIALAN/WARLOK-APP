import 'package:flutter/material.dart';

// Widget stateless bernama LoadingSpinner untuk menampilkan loading indicator
class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key}); // Constructor kosong (tanpa parameter tambahan)

  @override
  Widget build(BuildContext context) {
    return const Center(
      // Tampilkan indikator loading di tengah layar
      child: CircularProgressIndicator(
        color: Colors.orange, // Warna indikator (warna utama aplikasi)
      ),
    );
  }
}
