import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warlok/features/warung/models/review_model.dart';
import 'package:warlok/features/warung/models/warung_model.dart';

class WarungService {
  // Membuat satu instance dari Firestore untuk berkomunikasi dengan database.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Mengambil semua data warung secara real-time.
  /// Menggunakan Stream agar UI otomatis update jika ada data baru/perubahan.
  Stream<List<WarungModel>> getWarungs() {
    // Mengakses koleksi 'warungs' di Firestore.
    return _firestore
        .collection('warungs')
        // Mengurutkan data berdasarkan waktu pembuatan (terbaru di atas).
        .orderBy('createdAt', descending: true)
        // .snapshots() membuat koneksi real-time.
        .snapshots()
        // .map() mengubah data mentah dari Firestore menjadi List<WarungModel>.
        .map((snapshot) {
      return snapshot.docs.map((doc) => WarungModel.fromFirestore(doc)).toList();
    });
  }

  /// Menambah dokumen warung baru ke Firestore.
  /// Menerima objek WarungModel sebagai input.
  Future<bool> addWarung(WarungModel warung) async {
    try {
      // Menggunakan .add() untuk membuat dokumen baru dengan ID acak di koleksi 'warungs'.
      // warung.toJson() mengubah objek Dart menjadi format Map yang bisa disimpan Firestore.
      await _firestore.collection('warungs').add(warung.toJson());
      // Mengembalikan true jika berhasil.
      return true;
    } catch (e) {
      // Menangani jika terjadi error saat proses penyimpanan.
      print("ERROR ADD WARUNG: $e");
      return false;
    }
  }

  /// Mengambil semua ulasan untuk satu warung spesifik secara real-time.
  Stream<List<ReviewModel>> getReviewsForWarung(String warungId) {
    // Mengakses sub-koleksi 'reviews' yang ada di dalam sebuah dokumen warung.
    return _firestore
        .collection('warungs')
        // .doc(warungId) menunjuk ke dokumen warung yang spesifik.
        .doc(warungId)
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => ReviewModel.fromFirestore(doc)).toList();
    });
  }

  /// Menambah ulasan baru ke sub-koleksi 'reviews' dari sebuah warung.
  Future<bool> addReview(String warungId, ReviewModel review) async {
    try {
      await _firestore
          .collection('warungs')
          .doc(warungId)
          .collection('reviews')
          .add(review.toJson());
      return true;
    } catch (e) {
      print("ERROR ADD REVIEW: $e");
      return false;
    }
  }

  /// Mengubah data dokumen warung yang sudah ada.
  Future<bool> updateWarung(String warungId, WarungModel warung) async {
    try {
      // Menggunakan .update() pada dokumen spesifik untuk mengubah datanya.
      await _firestore.collection('warungs').doc(warungId).update(warung.toJson());
      return true;
    } catch (e) {
      print("ERROR UPDATE WARUNG: $e");
      return false;
    }
  }

  /// Menghapus data dokumen warung dari Firestore.
  Future<bool> deleteWarung(String warungId) async {
    try {
      // Menggunakan .delete() pada dokumen spesifik untuk menghapusnya.
      await _firestore.collection('warungs').doc(warungId).delete();
      return true;
    } catch (e) {
      print("ERROR DELETE WARUNG: $e");
      return false;
    }
  }
}