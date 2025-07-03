import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:warlok/core/widgets/custom_button.dart';
import 'package:warlok/features/warung/models/warung_model.dart';
import 'package:warlok/features/warung/screens/location_picker_screen.dart';
import 'package:warlok/features/warung/services/warung_service.dart';

class AddWarungScreen extends StatefulWidget {
  const AddWarungScreen({super.key});

  @override
  State<AddWarungScreen> createState() => _AddWarungScreenState();
}

class _AddWarungScreenState extends State<AddWarungScreen> {
  // Kunci global untuk mengidentifikasi dan memvalidasi Form
  final _formKey = GlobalKey<FormState>();
  // Controller untuk mengambil teks dari setiap kolom input
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  // Instance dari service untuk berinteraksi dengan Firestore
  final _warungService = WarungService();

  // Variabel untuk menyimpan data lokasi yang dipilih dari peta, awalnya kosong
  GeoPoint? _selectedLocation;
  // State untuk menandakan proses penyimpanan sedang berlangsung (untuk loading)
  bool _isLoading = false;

  /// Fungsi ini dipanggil saat tombol "Simpan Warung" ditekan.
  void _submitWarung() async {
    // 1. Validasi semua input di dalam Form. Jika ada yang tidak valid, proses berhenti.
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // Validasi tambahan untuk memastikan lokasi sudah dipilih.
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Silakan pilih lokasi warung di peta."),
        backgroundColor: Colors.red,
      ));
      return;
    }
    // Validasi untuk memastikan pengguna sudah login.
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Anda harus login untuk menambah warung."),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // 2. Tampilkan loading di tombol.
    setState(() => _isLoading = true);

    // Membuat objek `WarungModel` dari data yang diinput pengguna.
    final warung = WarungModel(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: _imageUrlController.text.trim(),
      location: _selectedLocation!,
      createdBy: currentUser.uid,
    );

    // 3. Kirim data ke service untuk disimpan ke Firestore.
    bool success = await _warungService.addWarung(warung);

    // 4. Hentikan loading setelah proses selesai (baik berhasil maupun gagal).
    // `mounted` dicek untuk memastikan widget masih ada di layar.
    if (!mounted) return;
    setState(() => _isLoading = false);

    // 5. Beri feedback ke pengguna dan kembali ke halaman sebelumnya jika berhasil.
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Warung berhasil ditambahkan!"),
          backgroundColor: Colors.green));
      // Tutup halaman ini untuk kembali ke halaman daftar warung.
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Gagal menambahkan warung."),
          backgroundColor: Colors.red));
    }
  }

  @override
  void dispose() {
    // Membersihkan controller saat halaman ditutup untuk mencegah kebocoran memori.
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tambah Warung Baru")),
      // `SingleChildScrollView` agar halaman bisa di-scroll jika keyboard muncul.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Hubungkan Form dengan GlobalKey
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Kolom input untuk Nama Warung
              TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: "Nama Warung", border: OutlineInputBorder()),
                  // `validator` akan dijalankan saat form divalidasi.
                  validator: (value) =>
                      value!.isEmpty ? 'Nama tidak boleh kosong' : null),
              const SizedBox(height: 16),
              // Kolom input untuk Deskripsi
              TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                      labelText: "Deskripsi Singkat", border: OutlineInputBorder()),
                  maxLines: 3,
                  validator: (value) =>
                      value!.isEmpty ? 'Deskripsi tidak boleh kosong' : null),
              const SizedBox(height: 16),
              // Kolom input untuk URL Gambar
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: "URL Gambar Warung",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.link),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL Gambar tidak boleh kosong';
                  }
                  if (!value.startsWith('http')) {
                    return 'URL sepertinya tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Tombol untuk membuka halaman pemilih lokasi
              OutlinedButton.icon(
                icon: const Icon(Icons.map_outlined),
                // Teks tombol berubah jika lokasi sudah dipilih
                label: Text(_selectedLocation == null
                    ? "Pilih Lokasi di Peta"
                    : "Lokasi Sudah Dipilih!"),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  foregroundColor: _selectedLocation == null
                      ? Colors.grey.shade700
                      : Colors.green,
                ),
                // `onPressed` ini akan menjalankan navigasi ke halaman peta
                onPressed: () async {
                  // `await` menunggu hasil dari halaman `LocationPickerScreen`
                  final pickedLocation = await Navigator.push<LatLng?>(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LocationPickerScreen()),
                  );

                  // Jika pengguna memilih lokasi (hasilnya tidak null)...
                  if (pickedLocation != null) {
                    // Update state untuk menyimpan lokasi dan mengubah tampilan tombol
                    setState(() {
                      _selectedLocation = GeoPoint(
                          pickedLocation.latitude, pickedLocation.longitude);
                    });
                  }
                },
              ),
              const SizedBox(height: 32),
              // Tombol Simpan custom kita
              CustomButton(
                  text: "Simpan Warung",
                  onPressed: _submitWarung,
                  isLoading: _isLoading),
            ],
          ),
        ),
      ),
    );
  }
}