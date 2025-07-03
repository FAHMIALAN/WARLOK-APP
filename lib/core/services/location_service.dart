
import 'package:location/location.dart';

class LocationService {
  final Location _location = Location();

  /// Fungsi untuk mengecek apakah GPS aktif dan apakah aplikasi punya izin.
  /// Jika tidak, fungsi ini akan meminta pengguna untuk mengaktifkannya.
  Future<bool> checkAndRequestGps() async {
    // 1. Cek apakah layanan lokasi (GPS) di HP sudah aktif.
    bool isServiceEnabled = await _location.serviceEnabled();
    if (!isServiceEnabled) {
      // Jika belum, tampilkan dialog sistem untuk meminta pengguna menyalakan GPS.
      isServiceEnabled = await _location.requestService();
      if (!isServiceEnabled) {
        return false; // Pengguna menolak menyalakan GPS.
      }
    }

    // 2. Cek apakah aplikasi sudah diberi izin akses lokasi oleh pengguna.
    PermissionStatus permissionStatus = await _location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      // Jika belum, tampilkan dialog sistem untuk meminta izin.
      permissionStatus = await _location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        return false; // Pengguna menolak memberikan izin.
      }
    }

    // Jika semua sudah siap (GPS aktif dan izin diberikan), kembalikan true.
    return true;
  }

  // --- TAMBAHKAN FUNGSI BARU DI BAWAH INI ---
  /// Mengambil data lokasi (koordinat) pengguna saat ini.
  /// Pastikan sudah memanggil checkAndRequestGps() sebelum fungsi ini.
  Future<LocationData?> getCurrentLocation() async {
    try {
      return await _location.getLocation();
    } catch (e) {
      // Jika terjadi error (misal, pengguna mematikan GPS di tengah jalan)
      print("Error tidak mendapatkan lokasi: $e");
      return null;
    }
  }
}