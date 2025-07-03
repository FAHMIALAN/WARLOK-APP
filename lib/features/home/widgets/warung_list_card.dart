import 'package:flutter/material.dart';
import 'package:warlok/features/warung/models/warung_model.dart'; // Import model warung
import 'package:warlok/features/warung/screens/warung_detail_screen.dart'; // Halaman detail warung

// Widget stateless yang menampilkan 1 kartu warung dalam bentuk list
class WarungListCard extends StatelessWidget {
  final WarungModel warung; // Data warung yang akan ditampilkan

  const WarungListCard({super.key, required this.warung});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0), // Jarak antar kartu
      elevation: 4, // Efek bayangan
      clipBehavior: Clip.antiAlias, // Untuk membuat gambar dipotong sesuai radius
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Sudut kartu membulat
      ),
      child: InkWell(
        // Bisa ditekan → buka halaman detail warung
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WarungDetailScreen(warung: warung),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian gambar di atas kartu
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.network(
                warung.imageUrl, // Ambil gambar dari URL
                fit: BoxFit.cover, // Gambar akan menyesuaikan area kotak
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child; // Tampilkan gambar jika sudah siap
                  return const Center(child: CircularProgressIndicator()); // Loading indicator
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.broken_image, size: 50, color: Colors.grey); // Jika gagal load gambar
                },
              ),
            ),

            // Bagian teks (nama dan deskripsi)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    warung.name, // Nama warung
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, // Potong teks jika terlalu panjang
                  ),
                  const SizedBox(height: 4),
                  Text(
                    warung.description, // Deskripsi singkat
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade700,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // Maks 2 baris
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
