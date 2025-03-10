import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:movies/widgets/screens/login.dart';
import 'package:movies/services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController =
      TextEditingController(); // Added username
  final AuthService _authService = AuthService();

  void _register() async {
    if (_usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a username',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final user = await _authService.registerWithEmail(
      _emailController.text,
      _passwordController.text,
      _usernameController.text, // Added username
    );

    if (user != null) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Akun berhasil dibuat',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      // Add a slight delay before navigation to ensure the user sees the message
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to login page
      if (mounted) {
        // Check if the widget is still in the tree
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registration failed",
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          // Added ScrollView for keyboard issues
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 60), // Add space at the top
              const Text(
                'YUKDAFTAR!',
                style: TextStyle(
                  color: Colors.red,
                  fontFamily: 'Bebas Neue',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.person_add_solid,
                    size: 80,
                    color: Colors.red,
                  ),
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Lottie.asset(
                      'assets/animations/movieAnimation.json',
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Username field
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _usernameController,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Email field
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _emailController,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password field
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(15),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: TextField(
                  controller: _passwordController,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.red,
                    fontSize: 14,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.red,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 32),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Register',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[200],
                          foregroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
