import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;
import '../repositories/auth_repository.dart';

class LoginPage extends StatelessWidget {
  final AuthRepository repo;
  const LoginPage({Key? key, required this.repo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Card(
          color: const Color.fromARGB(255, 246, 246, 246),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo / Icon
                const Icon(
                  Icons.business_center,
                  size: 60,
                  color: Colors.blueAccent,
                ),
                const SizedBox(height: 20),

                // Title
                const Text(
                  "Mini CRM",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  "Login to manage your campaigns and customers",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),

                // Email TextField (UI only)
                SizedBox(
                  width:300,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    enabled: false, // disabled, won't work
                  ),
                ),
                const SizedBox(height: 16),

                // Password TextField (UI only)
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: true,
                    enabled: false, // disabled, won't work
                  ),
                ),
                const SizedBox(height: 28),

                // Google Login Button
                SizedBox(
                  width: 300,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Colors.blueAccent),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black87,
                    ),
                    icon: Image.asset(
                      'assets/google.png',
                      height: 24,
                      width: 24,
                    ),
                    label: const Text(
                      "Sign in with Google",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      debugPrint("Google login clicked!");
                      web.window.location.href = repo.loginUrl;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
