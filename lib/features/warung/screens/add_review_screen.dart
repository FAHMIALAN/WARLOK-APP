import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore untuk simpan data review
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth untuk akses user login
import 'package:flutter/material.dart';
import 'package:warlok/core/widgets/custom_button.dart'; // Tombol kustom yang bisa digunakan ulang
import 'package:warlok/features/warung/models/review_model.dart'; // Model untuk struktur data review
import 'package:warlok/features/warung/services/warung_service.dart'; // Service untuk komunikasi dengan Firestore

// Widget Stateful untuk menambahkan ulasan/review
class AddReviewScreen extends StatefulWidget {
  final String warungId; // ID warung yang akan diberi ulasan

  const AddReviewScreen({super.key, required this.warungId});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>(); // Key untuk validasi form
  final _commentController = TextEditingController(); // Controller untuk input komentar
  final WarungService _warungService = WarungService(); // Service instance untuk simpan review
  double _rating = 3.0; // Nilai default rating bintang
  bool _isLoading = false; // Status loading untuk tombol

  // Fungsi untuk mengirim ulasan
  void _submitReview() async {
    if (!_formKey.currentState!.validate()) return; // Validasi form sebelum submit

    final user = FirebaseAuth.instance.currentUser; // Ambil user yang sedang login
    if (user == null) {
      // Jika belum login, tampilkan pesan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Anda harus login untuk memberi ulasan."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true); // Tampilkan loading saat proses kirim

    // Buat objek ReviewModel dari input user
    final newReview = ReviewModel(
      userId: user.uid,
      username: user.email ?? 'Anonim', // Gunakan email user atau 'Anonim'
      rating: _rating,
      comment: _commentController.text,
      timestamp: Timestamp.now(), // Waktu ulasan dibuat
    );

    // Kirim review ke Firestore melalui service
    final success = await _warungService.addReview(widget.warungId, newReview);

    if (!mounted) return;
    setState(() => _isLoading = false); // Sembunyikan loading

    if (success) {
      // Jika berhasil, kembali ke halaman sebelumnya
      Navigator.pop(context);
    } else {
      // Jika gagal, tampilkan pesan kesalahan
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Gagal mengirim ulasan."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tulis Ulasan")), // Judul AppBar
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding halaman
        child: Form(
          key: _formKey, // Gunakan formKey untuk validasi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Beri Rating:", style: Theme.of(context).textTheme.titleMedium),
              Slider(
                value: _rating, // Nilai rating saat ini
                min: 1,
                max: 5,
                divisions: 4,
                label: _rating.toString(), // Label angka rating
                onChanged: (newRating) {
                  setState(() => _rating = newRating); // Ubah rating saat slider digeser
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _commentController, // Input komentar
                decoration: const InputDecoration(
                  labelText: "Komentar",
                  border: OutlineInputBorder(),
                ),
                maxLines: 4, // Jumlah baris input
                validator: (value) => value!.isEmpty ? 'Komentar tidak boleh kosong' : null, // Validasi komentar
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: "Kirim Ulasan",
                onPressed: _submitReview, // Panggil fungsi submit saat ditekan
                isLoading: _isLoading, // Tampilkan loading jika sedang proses
              ),
            ],
          ),
        ),
      ),
    );
  }
}
