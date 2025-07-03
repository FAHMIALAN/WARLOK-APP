// File ini dihasilkan secara otomatis oleh FlutterFire CLI.
// Perubahan manual di sini akan hilang jika kamu menjalankan 'flutterfire configure' lagi.
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Kelas static yang menyimpan konfigurasi Firebase berdasarkan platform.
class DefaultFirebaseOptions {
  
  // Getter ini secara cerdas mendeteksi platform apa yang sedang menjalankan aplikasi
  // (misal: Android atau iOS), lalu mengembalikan konfigurasi yang sesuai.
  static FirebaseOptions get currentPlatform {
    // kIsWeb adalah konstanta untuk mengecek apakah aplikasi berjalan di web.
    if (kIsWeb) {
      // Kita sudah menonaktifkan web, jadi di sini akan melempar error jika ada yang mencoba.
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }

    // `switch` digunakan untuk memilih konfigurasi yang benar.
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        // Jika platformnya Android, kembalikan konfigurasi 'android'.
        return android;
      case TargetPlatform.iOS:
        // Jika platformnya iOS, kembalikan konfigurasi 'ios'.
        return ios;
      case TargetPlatform.macOS:
        // Kita sudah menonaktifkan macOS, jadi di sini akan error.
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        // Kita sudah menonaktifkan Windows, jadi di sini akan error.
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // Konfigurasi Firebase khusus untuk platform Android.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA84eng_JxaQD-AP7mhA2x2Kt4Y0z8Z3-s', // Kunci unik untuk mengakses API Firebase.
    appId: '1:397388348126:android:95b98e6e20b007683ca04f', // ID unik untuk aplikasi Android-mu di dalam proyek Firebase.
    messagingSenderId: '397388348126', // ID pengirim untuk layanan seperti notifikasi (FCM).
    projectId: 'warlok-722d4', // ID unik dari proyek Firebase-mu.
    storageBucket: 'warlok-722d4.firebasestorage.app', // Alamat bucket Cloud Storage yang terhubung.
  );

  // Konfigurasi Firebase khusus untuk platform iOS.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAOJVCA2X0DCqkZDbjyjXbSrzLGWsBNucg',
    appId: '1:397388348126:ios:47c840eda9899d373ca04f',
    messagingSenderId: '397388348126',
    projectId: 'warlok-722d4',
    storageBucket: 'warlok-722d4.firebasestorage.app',
    androidClientId: '397388348126-qelc2hj3e01oalt76uefla3ltga3ebda.apps.googleusercontent.com', // Client ID untuk Google Sign-In di Android.
    iosClientId: '397388348126-55n1hocgtpbghqjjo5b5s5itsk4npnu9.apps.googleusercontent.com', // Client ID untuk Google Sign-In di iOS.
    iosBundleId: 'com.example.warlok', // Nama paket unik untuk aplikasi iOS.
  );
}