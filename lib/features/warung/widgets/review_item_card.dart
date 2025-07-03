import 'package:flutter/material.dart';
// Import package 'intl' untuk bisa memformat tanggal
import 'package:intl/intl.dart';
import 'package:warlok/features/warung/models/review_model.dart';

// Widget ini bersifat StatelessWidget karena hanya bertugas menampilkan data ulasan yang diterima.
class ReviewItemCard extends StatelessWidget {
  // Menerima satu objek 'review' untuk ditampilkan.
  final ReviewModel review;
  const ReviewItemCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Card untuk memberikan tampilan kartu dengan bayangan.
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        // Menggunakan Column untuk menyusun elemen-elemen secara vertikal.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris pertama untuk nama pengguna dan tanggal.
            Row(
              // `spaceBetween` akan mendorong elemen pertama ke kiri dan elemen kedua ke kanan.
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Menampilkan nama pengguna dengan teks tebal.
                Text(review.username, style: const TextStyle(fontWeight: FontWeight.bold)),
                // Menampilkan tanggal ulasan.
                Text(
                  // `DateFormat` dari package 'intl' digunakan untuk memformat objek Timestamp
                  // dari Firebase menjadi format tanggal yang mudah dibaca (contoh: 03 Jul 2025).
                  DateFormat('dd MMM yyyy').format(review.timestamp.toDate()),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            // Baris kedua untuk menampilkan rating bintang.
            Row(
              // `List.generate(5, ...)` adalah cara cerdas untuk membuat 5 ikon bintang.
              children: List.generate(5, (index) {
                // Logika untuk menampilkan bintang:
                // Jika 'index' (0-4) lebih kecil dari 'rating' (misal: 3.0),
                // maka tampilkan bintang penuh (Icons.star).
                // Jika tidak, tampilkan bintang kosong (Icons.star_border).
                return Icon(
                  index < review.rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 20,
                );
              }),
            ),
            const SizedBox(height: 8), // Memberi sedikit jarak
            // Menampilkan teks komentar ulasan.
            Text(review.comment),
          ],
        ),
      ),
    );
  }
}