import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:nexsite/secure_storage.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  String? _selectedClientType; // single_owner | small_builder | turnkey
  bool _isLoading = false;

  Future<void> _register() async {
    final fullName = fullNameController.text.trim();
    final username = usernameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim(); // kept in UI; not sent to backend yet
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final clientType = _selectedClientType;

    if (fullName.isEmpty ||
        username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty ||
        clientType == null) {
      _showError('Please fill in all required fields.');
      return;
    }
    if (password != confirmPassword) {
      _showError('Passwords do not match.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ✅ Correct Django endpoint
      final url = Uri.parse("http://10.0.2.2:8000/api/accounts/register/");

      final payload = {
        "username": username,
        "full_name": fullName,
        "email": email,
        "role": clientType,               // Django expects `role`
        "password": password,
        "password_confirm": confirmPassword,
        // NOTE: `phone` is NOT sent because your current DRF serializer
        // doesn't accept it. Keep it in UI; add it server-side later if needed.
      };

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        try {
          final data = jsonDecode(response.body);

          // Your RegisterView returns: { "tokens": {"refresh","access"}, "user": {...} }
          final access = data["tokens"]?["access"] as String?;
          final refresh = data["tokens"]?["refresh"] as String?;

          if (access != null) {
            await SecureStorage.saveToken("access", access);
          }
          if (refresh != null) {
            await SecureStorage.saveToken("refresh", refresh);
          }

          _showSuccess('Registered successfully!');

          // Go to Login after a short delay
          Future.delayed(const Duration(seconds: 1), () {
            if (!mounted) return;
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          });
        } catch (_) {
          // If backend returns non-JSON for some reason
          _showSuccess('Registered successfully!');
        }
      } else {
        // Show backend error body
        String msg = 'Registration failed';
        try {
          final err = jsonDecode(response.body);
          msg = err.toString();
        } catch (_) {
          msg = response.body;
        }
        _showError(msg);
      }
    } catch (e) {
      _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ));
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00A8E8), Color(0xFF0077B6)],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: GlassCard(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Welcome to NexSite 💙",
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Full Name
                    _buildInput("Full Name", controller: fullNameController),
                    const SizedBox(height: 10),

                    // Username
                    _buildInput("Username", controller: usernameController),
                    const SizedBox(height: 10),

                    // Email
                    _buildInput("Email", controller: emailController),
                    const SizedBox(height: 10),

                    // Phone (kept in UI; not sent yet)
                    _buildInput("Phone", controller: phoneController),
                    const SizedBox(height: 10),

                    // Password
                    _buildInput("Password",
                        controller: passwordController, isPassword: true),
                    const SizedBox(height: 10),

                    // Confirm Password
                    _buildInput("Confirm Password",
                        controller: confirmPasswordController, isPassword: true),
                    const SizedBox(height: 10),

                    // Client Type
                    _buildDropdown(),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A8E8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: _isLoading ? null : _register,
                      child: _isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : Text(
                        "Register",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            "Login",
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Text(
                      '"Great projects start with a single step."',
                      style: GoogleFonts.nunito(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label,
      {required TextEditingController controller, bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedClientType,
      items: const [
        DropdownMenuItem(value: "single_owner", child: Text("Single Owner")),
        DropdownMenuItem(value: "small_builder", child: Text("Small Builder")),
        DropdownMenuItem(value: "turnkey", child: Text("Turnkey Builder")),
      ],
      onChanged: (value) => setState(() => _selectedClientType = value),
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: "Client Type",
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}

class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
          ),
          child: child,
        ),
      ),
    );
  }
}
