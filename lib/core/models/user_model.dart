// Mendefinisikan sebuah kelas bernama UserModel.
class UserModel {
  // Properti `uid` (User ID) yang wajib ada dan tidak bisa diubah (final).
  // Ini akan menyimpan ID unik dari Firebase Authentication.
  final String uid;

  // Properti `email` yang tidak bisa diubah (final) tapi boleh kosong (nullable, ditandai dengan '?').
  // Ini untuk mengantisipasi jika ada metode login yang tidak menggunakan email.
  final String? email;

  // Constructor untuk membuat objek UserModel.
  // `required this.uid` berarti `uid` wajib diisi saat membuat objek.
  // `this.email` bersifat opsional.
  UserModel({required this.uid, this.email});
}