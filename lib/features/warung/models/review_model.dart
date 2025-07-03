import 'package:cloud_firestore/cloud_firestore.dart'; // Import untuk Timestamp dan DocumentSnapshot dari Firestore

// Model untuk merepresentasikan data review ulasan warung
class ReviewModel {
  final String? id; // ID dokumen Firestore (opsional)
  final String userId; // ID user yang memberikan ulasan
  final String username; // Nama/email user
  final double rating; // Nilai rating (1.0 - 5.0)
  final String comment; // Isi komentar/ulasan
  final Timestamp timestamp; // Waktu ulasan dibuat (dari Firestore)

  // Konstruktor untuk membuat instance ReviewModel
  ReviewModel({
    this.id,
    required this.userId,
    required this.username,
    required this.rating,
    required this.comment,
    required this.timestamp,
  });

  // Factory constructor untuk membuat ReviewModel dari dokumen Firestore
  factory ReviewModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return ReviewModel(
      id: doc.id, // Ambil ID dokumen Firestore
      userId: data['userId'] ?? '', // Ambil userId dari data, default ke string kosong jika null
      username: data['username'] ?? 'Anonim', // Default nama pengguna ke "Anonim"
      rating: (data['rating'] ?? 0.0).toDouble(), // Konversi rating ke double
      comment: data['comment'] ?? '', // Default komentar ke string kosong
      timestamp: data['timestamp'] ?? Timestamp.now(), // Gunakan waktu sekarang jika tidak tersedia
    );
  }

  // Konversi objek ke format Map agar bisa disimpan ke Firestore
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'rating': rating,
      'comment': comment,
      'timestamp': timestamp,
    };
  }
}
