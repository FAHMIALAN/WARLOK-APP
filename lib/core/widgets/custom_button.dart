import 'package:flutter/material.dart';

// Widget ini bersifat StatelessWidget karena tampilannya murni dikontrol oleh parameter
// yang dikirim dari luar (text, onPressed, isLoading).
class CustomButton extends StatelessWidget {
  // Properti untuk menampung teks yang akan ditampilkan di tombol.
  final String text;
  // Properti untuk menampung fungsi yang akan dijalankan saat tombol ditekan.
  final VoidCallback onPressed;
  // Properti boolean untuk mengontrol status loading. Default-nya false.
  final bool isLoading;

  // Constructor untuk menerima nilai-nilai properti saat widget ini dibuat.
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // `SizedBox` digunakan untuk memberi ukuran yang pasti pada tombol.
    return SizedBox(
      // `double.infinity` membuat tombol membentang selebar mungkin.
      width: double.infinity,
      height: 50,
      // `ElevatedButton` adalah widget tombol dasar dari Material Design.
      child: ElevatedButton(
        // Logika penting: Jika `isLoading` true, `onPressed` menjadi null,
        // yang secara otomatis akan menonaktifkan tombol (disabled).
        // Jika false, `onPressed` akan diisi dengan fungsi yang dikirimkan.
        onPressed: isLoading ? null : onPressed,
        // Memberi styling pada tombol.
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange.shade700,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        // Logika penting: Mengganti isi (child) dari tombol berdasarkan state `isLoading`.
        child: isLoading
            // JIKA `isLoading` true, tampilkan loading spinner.
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            // JIKA `isLoading` false, tampilkan teks biasa.
            : Text(text, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}