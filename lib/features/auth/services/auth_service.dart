import 'package:firebase_auth/firebase_auth.dart'; // Untuk autentikasi Firebase
import 'package:google_sign_in/google_sign_in.dart'; // Untuk autentikasi Google

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instance Firebase Auth
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // Instance Google Sign-In

  // Stream yang memberitahu jika user login/logout
  Stream<User?> get user => _auth.authStateChanges();

  // === LOGIN DENGAN EMAIL & PASSWORD ===
  // Mengembalikan `null` jika berhasil login, atau pesan error jika gagal
  Future<String?> signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password); // Login user
      return null; // Berhasil
    } on FirebaseAuthException catch (e) {
      return e.message; // Gagal → kirim pesan error
    }
  }

  // === REGISTER AKUN BARU DENGAN EMAIL & PASSWORD ===
  // Mengembalikan `null` jika berhasil, atau pesan error jika gagal
  Future<String?> registerWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password); // Buat akun baru
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message; // Gagal → kirim pesan error
    }
  }

  // === LOGIN DENGAN GOOGLE ===
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn(); // Tampilkan popup login Google
      if (googleUser == null) return null; // Jika batal login

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Buat kredensial dari akun Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Login ke Firebase menggunakan kredensial Google
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user; // Kembalikan user
    } catch (e) {
      print("ERROR SIGN IN WITH GOOGLE: $e"); // Cetak error jika terjadi
      return null;
    }
  }
  
  // === LOGOUT DARI SELURUH AKUN ===
  Future<void> signOut() async {
    await _googleSignIn.signOut(); // Logout dari akun Google (jika pakai)
    await _auth.signOut(); // Logout dari Firebase
  }
}
