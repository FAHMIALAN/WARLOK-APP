// Import package yang dibutuhkan
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart'; // Untuk menampilkan peta
import 'package:latlong2/latlong.dart'; // Untuk koordinat LatLng
import 'package:location/location.dart'; // Untuk akses lokasi GPS
import 'package:warlok/core/services/location_service.dart'; // Service buatan sendiri untuk izin lokasi
import 'package:warlok/core/widgets/loading_spinner.dart'; // Widget loading kustom
import 'package:warlok/features/warung/models/warung_model.dart'; // Model data warung
import 'package:warlok/features/warung/screens/add_warung_screen.dart'; // Layar tambah warung
import 'package:warlok/features/warung/screens/warung_detail_screen.dart'; // Layar detail warung
import 'package:warlok/features/warung/services/warung_service.dart'; // Service untuk mengambil data warung

// StatefulWidget agar bisa update posisi user secara dinamis
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final LocationService _locationService = LocationService(); // Inisialisasi service lokasi
  final MapController _mapController = MapController(); // Controller peta
  LatLng? _currentPosition; // Posisi user saat ini (null = belum diketahui)

  @override
  void initState() {
    super.initState();
    _findMyLocation(); // Langsung cari lokasi saat halaman dibuka
  }

  /// Mengecek izin GPS dan mengambil lokasi saat ini
  Future<void> _findMyLocation() async {
    final bool isGpsReady = await _locationService.checkAndRequestGps(); // Minta izin lokasi dan aktifkan GPS

    if (isGpsReady && mounted) {
      final LocationData? locationData = await _locationService.getCurrentLocation(); // Ambil data lokasi user

      if (locationData != null && locationData.latitude != null && mounted) {
        setState(() {
          _currentPosition = LatLng(locationData.latitude!, locationData.longitude!); // Simpan posisi ke state
          _mapController.move(_currentPosition!, 15.0); // Arahkan peta ke posisi user
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final WarungService warungService = WarungService(); // Inisialisasi service warung

    return Scaffold(
      appBar: AppBar(
        title: const Text("Peta Warung Lokal"),
        actions: [
          // Tombol untuk kembali ke posisi user
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _findMyLocation,
          ),
        ],
      ),

      // Ambil data warung dari Firestore secara realtime
      body: StreamBuilder<List<WarungModel>>(
        stream: warungService.getWarungs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingSpinner(); // Tampilkan spinner saat loading
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          List<Marker> markers = [];

          // Jika ada data warung, buat marker untuk masing-masing
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final warungs = snapshot.data!;

            markers = warungs.map((warung) {
              return Marker(
                point: LatLng(warung.location.latitude, warung.location.longitude),
                width: 80,
                height: 80,
                child: GestureDetector(
                  onTap: () {
                    // Saat marker diklik, buka halaman detail warung
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WarungDetailScreen(warung: warung),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.location_pin, color: Colors.red.shade700, size: 40),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          warung.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 11, color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList();
          }

          // Tambahkan marker posisi user jika sudah diketahui
          if (_currentPosition != null) {
            markers.add(
              Marker(
                point: _currentPosition!,
                width: 80,
                height: 80,
                child: const Column(
                  children: [
                    Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
                    Text("Anda", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            );
          }

          // Tampilkan peta OpenStreetMap dan semua marker
          return FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(-7.7956, 110.3695), // Titik awal: Yogyakarta
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // Sumber peta OSM
              ),
              MarkerLayer(markers: markers), // Layer untuk semua marker (warung + user)
            ],
          );
        },
      ),

      // Tombol tambah warung
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddWarungScreen()));
        },
        child: const Icon(Icons.add_location_alt),
      ),
    );
  }
}
