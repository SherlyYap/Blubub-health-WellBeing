import 'package:flutter/material.dart';
import 'package:project/database/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailOrUserController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmNewPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final input = emailOrUserController.text.trim();
    final newPassword = newPasswordController.text;
    final confirmNewPassword = confirmNewPasswordController.text;

    if (newPassword != confirmNewPassword) {
      _showSnackbar("Konfirmasi password tidak cocok!");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final updated = await DBHelper.updatePassword(input, newPassword);

      if (updated > 0) {
        final prefs = await SharedPreferences.getInstance();
        final loggedEmail = prefs.getString('loggedInEmail') ?? '';
        final loggedName = prefs.getString('loggedInName') ?? '';

        if (input == loggedEmail || input == loggedName) {
          await prefs.setString('password', newPassword);
        }

        _showSnackbar("Password berhasil direset!");
        if (mounted) Navigator.pop(context);
      } else {
        _showSnackbar("Akun tidak ditemukan (email/username salah).");
      }
    } catch (e) {
      _showSnackbar("Gagal reset password: ${e.toString()}");
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

  @override
  void dispose() {
    emailOrUserController.dispose();
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffc1e8ff),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Lupa Password',
          style:
              TextStyle(color: Color(0xff0D273D), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildTextField(
                  controller: emailOrUserController,
                  label: "Email atau Username",
                  icon: Icons.person,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Wajib diisi';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: newPasswordController,
                  label: "Password Baru",
                  icon: Icons.lock,
                  obscure: true,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Minimal 8 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: confirmNewPasswordController,
                  label: "Konfirmasi Password",
                  icon: Icons.lock_outline,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.length < 8) {
                      return 'Minimal 8 karakter';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) => _resetPassword(),
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0D273D),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 80, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          "Reset Password",
                          style: GoogleFonts.nunito(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    TextInputAction textInputAction = TextInputAction.next,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onFieldSubmitted: onFieldSubmitted,
      validator: validator,
      style: GoogleFonts.nunito(),
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        labelStyle: GoogleFonts.nunito(),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
