import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:warlok/core/widgets/loading_spinner.dart';
import 'package:warlok/features/warung/models/review_model.dart';
import 'package:warlok/features/warung/models/warung_model.dart';
import 'package:warlok/features/warung/screens/add_review_screen.dart';
import 'package:warlok/features/warung/screens/edit_warung_screen.dart';
import 'package:warlok/features/warung/services/warung_service.dart';
import 'package:warlok/features/warung/widgets/review_item_card.dart';

// Widget ini bersifat StatelessWidget karena hanya menampilkan data yang dikirimkan kepadanya.
class WarungDetailScreen extends StatelessWidget {
  // Menerima data 'warung' yang akan ditampilkan dari halaman sebelumnya.
  final WarungModel warung;
  const WarungDetailScreen({super.key, required this.warung});

  // Fungsi helper untuk menangani logika penghapusan warung.
  void _deleteWarung(BuildContext context, WarungService service) async {
    // Menampilkan dialog pop-up untuk meminta konfirmasi dari pengguna.
    final bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Hapus"),
        content: const Text("Apakah Anda yakin ingin menghapus warung ini?"),
        actions: [
          // Tombol Batal, akan mengembalikan nilai 'false'.
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Batal")),
          // Tombol Hapus, akan mengembalikan nilai 'true'.
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    // Jika pengguna menekan tombol "Hapus" (confirm == true)...
    if (confirm == true) {
      // Panggil fungsi deleteWarung dari service dengan ID warung yang sesuai.
      final success = await service.deleteWarung(warung.id!);
      // Cek 'mounted' untuk memastikan halaman ini masih ada sebelum melakukan navigasi.
      if (success && context.mounted) {
        // Jika berhasil, tutup halaman detail ini.
        Navigator.of(context).pop(); 
        // Tampilkan notifikasi sukses.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Warung berhasil dihapus"), backgroundColor: Colors.green),
        );
      } else if (context.mounted) {
         // Jika gagal, tampilkan notifikasi error.
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal menghapus warung."), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Membuat instance service untuk digunakan di dalam UI.
    final WarungService warungService = WarungService();
    // Mengambil data pengguna yang sedang login saat ini.
    final currentUser = FirebaseAuth.instance.currentUser;
    // Logika penting: Mengecek apakah UID pengguna saat ini sama dengan UID pembuat warung.
    // Ini menentukan apakah tombol Edit & Hapus akan muncul.
    final bool isOwner = currentUser?.uid == warung.createdBy;

    return Scaffold(
      appBar: AppBar(
        title: Text(warung.name),
        // Gunakan operator ternary: JIKA 'isOwner' true, TAMPILKAN tombol, JIKA tidak, JANGAN tampilkan apa-apa (null).
        actions: isOwner ? [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => EditWarungScreen(warung: warung),
              ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            // Memanggil fungsi _deleteWarung saat tombol ditekan.
            onPressed: () => _deleteWarung(context, warungService),
          ),
        ] : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cek jika URL gambar ada atau tidak, lalu tampilkan gambar dari internet.
            // 'errorBuilder' akan menangani jika link gambar rusak atau gagal dimuat.
            warung.imageUrl == null || warung.imageUrl!.isEmpty
            ? Container(height: 250, color: Colors.grey.shade300, child: const Center(child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)))
            : Image.network(
                warung.imageUrl!, 
                width: double.infinity, 
                height: 250, 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(height: 250, color: Colors.grey.shade300, child: const Center(child: Icon(Icons.error_outline, size: 50, color: Colors.grey)));
                },
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Menampilkan detail teks dari warung.
                  Text(warung.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(warung.description, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 24),
                  const Divider(),
                  Text("Ulasan Pengguna", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  
                  // `StreamBuilder` untuk menampilkan daftar ulasan secara real-time.
                  // Ia akan "mendengarkan" perubahan data dari `getReviewsForWarung`.
                  StreamBuilder<List<ReviewModel>>(
                    stream: warungService.getReviewsForWarung(warung.id!),
                    builder: (context, snapshot) {
                      // Tampilkan loading spinner selagi menunggu data.
                      if (snapshot.connectionState == ConnectionState.waiting) return const LoadingSpinner();
                      // Tampilkan pesan jika ada error atau tidak ada data.
                      if (snapshot.hasError) return const Text("Gagal memuat ulasan.");
                      if (!snapshot.hasData || snapshot.data!.isEmpty) return const Text("Belum ada ulasan.");
                      
                      final reviews = snapshot.data!;
                      // `ListView.builder` untuk membuat daftar ulasan secara efisien.
                      // `shrinkWrap` dan `NeverScrollableScrollPhysics` diperlukan karena ListView ini ada di dalam SingleChildScrollView.
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviews.length,
                        itemBuilder: (context, index) {
                          // Tampilkan setiap ulasan menggunakan widget `ReviewItemCard`.
                          return ReviewItemCard(review: reviews[index]);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Tombol untuk menambah ulasan baru.
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigasi ke halaman tambah review dengan mengirim ID warung yang sedang dilihat.
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddReviewScreen(warungId: warung.id!),
          ));
        },
        label: const Text("Tulis Ulasan"),
        icon: const Icon(Icons.rate_review),
      ),
    );
  }
}