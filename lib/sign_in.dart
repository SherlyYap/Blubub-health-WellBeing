import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ProfilPage.dart';
import 'sign_up.dart';
import 'forgot_password.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _handleSignIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Mohon isi semua field");
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('loggedInEmail', email);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } on FirebaseAuthException catch (e) {
      _showSnackbar(e.message ?? "Terjadi kesalahan");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xff0D273D),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
    TextInputAction inputAction = TextInputAction.next,
    void Function(String)? onSubmitted,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      textInputAction: inputAction,
      onSubmitted: onSubmitted,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        filled: true,
        fillColor: Colors.white,
        border: const UnderlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffc1e8ff),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60),
            child: Image.asset('img-project/logo.png', width: 300, height: 300),
          ),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildTextField(
                      hint: "enter your email",
                      icon: Icons.email,
                      controller: _emailController,
                      inputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      hint: "enter your password",
                      icon: Icons.lock,
                      controller: _passwordController,
                      obscure: true,
                      inputAction: TextInputAction.done,
                      onSubmitted: (_) => _handleSignIn(),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ForgotPasswordPage()),
                          );
                        },
                        child: Text(
                          "Lupa Password?",
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _handleSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 202, 231, 255),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 80,
                                vertical: 16,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Text(
                              "SIGN IN",
                              style: GoogleFonts.nunito(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "no account? ",
                          style: GoogleFonts.nunito(fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SignUp()),
                            );
                          },
                          child: Text(
                            "Register now",
                            style: GoogleFonts.nunito(
                              color: const Color(0XFF031716),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
