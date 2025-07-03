import 'package:flutter/material.dart';
import 'package:warlok/core/widgets/loading_spinner.dart';
import 'package:warlok/features/home/widgets/warung_list_card.dart';
import 'package:warlok/features/warung/models/warung_model.dart';
import 'package:warlok/features/warung/services/warung_service.dart';

// Widget ini bersifat StatelessWidget karena semua state (daftar warung)
// dikelola secara otomatis oleh StreamBuilder.
class WarungListPage extends StatelessWidget {
  const WarungListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membuat instance dari service untuk mengakses data.
    final WarungService warungService = WarungService();

    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Warung Lokal")),
      // StreamBuilder adalah widget kunci untuk menampilkan data real-time dari Firebase.
      // Ia akan "mendengarkan" perubahan data dan otomatis membangun ulang UI jika ada update.
      body: StreamBuilder<List<WarungModel>>(
        // `stream` dihubungkan ke fungsi `getWarungs()` dari service kita.
        stream: warungService.getWarungs(),
        // `builder` adalah fungsi yang akan dipanggil setiap kali ada data baru dari stream.
        // `snapshot` berisi informasi tentang status koneksi dan data itu sendiri.
        builder: (context, snapshot) {
          // Jika `snapshot` sedang menunggu data pertama dari Firebase, tampilkan loading.
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinner();
          }
          // Jika terjadi error saat mengambil data, tampilkan pesan error.
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          // Jika koneksi berhasil tapi tidak ada data (atau datanya kosong), tampilkan pesan.
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Belum ada warung yang ditambahkan."));
          }

          // Jika semua aman dan data ada, ambil datanya dari snapshot.
          final warungs = snapshot.data!;
          // `ListView.builder` digunakan untuk menampilkan daftar yang panjang secara efisien.
          // Ia hanya akan me-render item yang terlihat di layar.
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            // Jumlah item dalam daftar sesuai dengan jumlah data warung yang didapat.
            itemCount: warungs.length,
            // Fungsi ini akan dipanggil untuk setiap item dalam daftar.
            itemBuilder: (context, index) {
              // Untuk setiap item, kita membuat widget `WarungListCard`
              // dan mengirimkan data warung yang sesuai (`warungs[index]`).
              return WarungListCard(warung: warungs[index]);
            },
          );
        },
      ),
    );
  }
}