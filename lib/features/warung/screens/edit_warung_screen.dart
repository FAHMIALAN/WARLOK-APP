import 'package:flutter/material.dart';
import 'package:warlok/core/widgets/custom_button.dart'; // Widget tombol kustom
import 'package:warlok/features/warung/models/warung_model.dart'; // Model data Warung
import 'package:warlok/features/warung/services/warung_service.dart'; // Service untuk CRUD Warung

// Halaman untuk mengedit data Warung
class EditWarungScreen extends StatefulWidget {
  final WarungModel warung; // Data warung yang akan diedit

  const EditWarungScreen({super.key, required this.warung});

  @override
  State<EditWarungScreen> createState() => _EditWarungScreenState();
}

class _EditWarungScreenState extends State<EditWarungScreen> {
  final _formKey = GlobalKey<FormState>(); // Key untuk validasi form

  // Controller untuk input text
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _imageUrlController;

  final WarungService _warungService = WarungService(); // Instance service

  bool _isLoading = false; // Status loading untuk tombol simpan

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller dengan data lama dari widget.warung
    _nameController = TextEditingController(text: widget.warung.name);
    _descriptionController = TextEditingController(text: widget.warung.description);
    _imageUrlController = TextEditingController(text: widget.warung.imageUrl);
  }

  // Fungsi untuk mengirim perubahan ke backend
  void _submitUpdate() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true); // Tampilkan loading

      // Buat model warung baru dengan data yang diperbarui
      final updatedWarung = WarungModel(
        id: widget.warung.id,
        name: _nameController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        location: widget.warung.location, // Lokasi tidak diedit
        createdBy: widget.warung.createdBy, // Creator tetap
      );

      // Kirim ke Firestore melalui service
      bool success = await _warungService.updateWarung(widget.warung.id!, updatedWarung);

      if (!mounted) return;
      setState(() => _isLoading = false); // Sembunyikan loading

      if (success) {
        // Jika berhasil, tampilkan pesan dan kembali ke 2 halaman sebelumnya
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Warung berhasil diperbarui!"), backgroundColor: Colors.green),
        );

        int count = 0;
        Navigator.of(context).popUntil((_) => count++ >= 2); // Pop 2 layar
      } else {
        // Jika gagal, tampilkan pesan error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal memperbarui warung."), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dihancurkan
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Warung")), // Judul AppBar
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0), // Padding isi halaman
        child: Form(
          key: _formKey, // Form key untuk validasi
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Field untuk nama warung
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Warung",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Field untuk deskripsi
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi Singkat",
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Field untuk URL gambar
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: "URL Gambar",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'URL tidak boleh kosong' : null,
              ),
              const SizedBox(height: 32),

              // Tombol simpan perubahan
              CustomButton(
                text: "Simpan Perubahan",
                onPressed: _submitUpdate,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
