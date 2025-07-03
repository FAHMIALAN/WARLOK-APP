import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart'; // Digunakan oleh location_service
// Import service lokasi yang sudah kita buat
import 'package:warlok/core/services/location_service.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  // --- TAMBAHAN BARU ---
  // Controller untuk menggerakkan peta secara programatik
  final MapController _mapController = MapController();
  // Instance dari service lokasi untuk mengakses fungsinya
  final LocationService _locationService = LocationService();
  // --- AKHIR TAMBAHAN ---

  // State untuk menyimpan lokasi yang dipilih oleh pengguna (baik dari tap atau dari GPS)
  LatLng? _pickedLocation;

  // --- FUNGSI BARU UNTUK MENCARI LOKASI PENGGUNA ---
  Future<void> _goToMyLocation() async {
    // Tampilkan dialog loading agar pengguna tahu ada proses yang berjalan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Panggil service untuk memastikan GPS aktif dan izin sudah ada
    final bool isGpsReady = await _locationService.checkAndRequestGps();
    if (isGpsReady && mounted) {
      // Jika GPS siap, ambil data lokasi pengguna saat ini
      final LocationData? locationData = await _locationService.getCurrentLocation();
      
      // Tutup dialog loading setelah selesai mencari lokasi
      Navigator.of(context).pop();

      // Jika lokasi berhasil didapat...
      if (locationData != null && locationData.latitude != null && mounted) {
        final myLocation = LatLng(locationData.latitude!, locationData.longitude!);
        setState(() {
          // Set lokasi yang dipilih ke lokasi kita saat ini, sehingga marker akan muncul
          _pickedLocation = myLocation;
        });
        // Perintahkan peta untuk bergerak ke lokasi kita dengan animasi
        _mapController.move(myLocation, 15.0);
      }
    } else {
      // Jika GPS tidak siap (misal, pengguna menolak izin)
      // Tutup dialog loading
      Navigator.of(context).pop();
      if (mounted) {
        // Tampilkan pesan error kepada pengguna
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Gagal mendapatkan lokasi. Pastikan GPS aktif.")),
        );
      }
    }
  }
  // --- AKHIR FUNGSI BARU ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi Warung")),
      body: Stack(
        children: [
          FlutterMap(
            // Hubungkan controller ke widget peta agar bisa digerakkan
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(-7.7925, 110.3656), // Titik Nol KM Jogja
              initialZoom: 14.0,
              // Fungsi ini akan dipanggil setiap kali pengguna mengetuk peta
              onTap: (tapPosition, point) {
                setState(() {
                  // Update state dengan koordinat yang diketuk, sehingga marker pindah
                  _pickedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
              // Tampilkan marker hanya jika _pickedLocation sudah ada isinya
              if (_pickedLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _pickedLocation!,
                      child: Icon(Icons.location_pin, color: Colors.red.shade700, size: 50),
                    ),
                  ],
                ),
            ],
          ),
          // Tampilkan tombol "Pilih Lokasi" hanya jika pengguna sudah memilih titik
          if (_pickedLocation != null)
            Positioned(
              bottom: 30,
              left: 60,
              right: 60,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text("Pilih Lokasi Ini"),
                onPressed: () {
                  // Kirim data koordinat yang terpilih kembali ke halaman 'Tambah Warung'
                  Navigator.of(context).pop(_pickedLocation);
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white),
              ),
            ),
        ],
      ),
      // --- TOMBOL BARU UNTUK AKSES LOKASI ---
      // Tombol ini akan memanggil fungsi _goToMyLocation
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMyLocation,
        tooltip: 'Lokasi Saya',
        child: const Icon(Icons.my_location),
      ),
      // --- AKHIR TOMBOL BARU ---
    );
  }
}