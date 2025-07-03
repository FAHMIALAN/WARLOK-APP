import 'package:flutter/material.dart';
import 'package:warlok/core/widgets/custom_button.dart'; // Tombol kustom dengan indikator loading
import 'package:warlok/features/auth/screens/register_screen.dart'; // Navigasi ke halaman register
import 'package:warlok/features/auth/services/auth_service.dart'; // Service untuk autentikasi

// Halaman login
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(); // Controller input email
  final _passwordController = TextEditingController(); // Controller input password
  final _authService = AuthService(); // Instance dari AuthService

  bool _isEmailLoading = false; // Loading indikator login email
  bool _isGoogleLoading = false; // Loading indikator login Google

  // Fungsi login menggunakan email dan password
  void _loginWithEmail() async {
    setState(() => _isEmailLoading = true);

    final errorMessage = await _authService.signInWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _isEmailLoading = false);

    if (errorMessage != null) {
      // Tampilkan error jika login gagal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Fungsi login menggunakan akun Google
  void _loginWithGoogle() async {
    setState(() => _isGoogleLoading = true);
    await _authService.signInWithGoogle(); // Tidak menangani error secara eksplisit
    if (!mounted) return;
    setState(() => _isGoogleLoading = false);
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dihancurkan
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Text(
                "Selamat Datang di",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                "WARLOK",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade800,
                    ),
              ),
              const SizedBox(height: 48),

              // Input Email
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // Input Password
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              // Tombol login dengan email
              CustomButton(
                text: "Login",
                onPressed: _loginWithEmail,
                isLoading: _isEmailLoading,
              ),

              const SizedBox(height: 12),

              // Divider dengan tulisan "ATAU"
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("ATAU"),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 12),

              // Tombol login Google
              CustomButton(
                text: "Masuk dengan Google",
                onPressed: _loginWithGoogle,
                isLoading: _isGoogleLoading,
              ),
              const SizedBox(height: 16),

              // Link ke halaman registrasi
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Belum punya akun?"),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    ),
                    child: const Text("Daftar di sini"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
