import 'package:cloud_firestore/cloud_firestore.dart'; // Import untuk Firestore dan GeoPoint

// Model untuk data warung yang akan disimpan/diambil dari Firestore
class WarungModel {
  final String? id; // ID dokumen Firestore (opsional)
  final String name; // Nama warung
  final String description; // Deskripsi singkat warung
  final String imageUrl; // URL gambar warung
  final GeoPoint location; // Lokasi warung dalam bentuk koordinat
  final String createdBy; // UID user yang membuat/menambahkan warung

  // Konstruktor utama untuk membuat WarungModel
  WarungModel({
    this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.location,
    required this.createdBy,
  });

  // Factory constructor: mengubah dokumen Firestore menjadi WarungModel
  factory WarungModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>; // Ambil data dari dokumen

    return WarungModel(
      id: doc.id, // Ambil ID dokumen
      name: data['name'] ?? '', // Nama warung atau default ""
      description: data['description'] ?? '', // Deskripsi atau default ""
      imageUrl: data['imageUrl'] ?? '', // URL gambar atau default ""
      location: data['location'] ?? const GeoPoint(0, 0), // Lokasi atau default 0,0
      createdBy: data['createdBy'] ?? '', // UID user pembuat warung
    );
  }

  // Method untuk mengubah objek ke bentuk Map (untuk disimpan ke Firestore)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'location': location, // GeoPoint langsung bisa disimpan ke Firestore
      'createdBy': createdBy,
      'createdAt': FieldValue
          .serverTimestamp(), // Timestamp otomatis dari server saat data disimpan
    };
  }
}
