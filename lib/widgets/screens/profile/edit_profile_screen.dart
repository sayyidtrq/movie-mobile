import 'package:flutter/material.dart';
import 'package:movies/services/auth_services.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userProfile;

  const EditProfileScreen({Key? key, required this.userProfile})
      : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _ageController;
  late TextEditingController _occupationController;
  late TextEditingController _hobbiesController;
  late TextEditingController _favoriteMovieController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.userProfile?['username'] ?? '');
    _ageController = TextEditingController(
        text: widget.userProfile?['age']?.toString() ?? '');
    _occupationController =
        TextEditingController(text: widget.userProfile?['occupation'] ?? '');
    _hobbiesController =
        TextEditingController(text: widget.userProfile?['hobbies'] ?? '');
    _favoriteMovieController =
        TextEditingController(text: widget.userProfile?['favoriteMovie'] ?? '');
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    _occupationController.dispose();
    _hobbiesController.dispose();
    _favoriteMovieController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Show immediate feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Saving profile changes...'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 1),
      ),
    );

    setState(() {
      _isLoading = true;
    });

    final int? age = int.tryParse(_ageController.text);

    final Map<String, dynamic> updatedProfile = {
      'username': _usernameController.text,
      'age': age,
      'occupation': _occupationController.text,
      'hobbies': _hobbiesController.text,
      'favoriteMovie': _favoriteMovieController.text,
    };

    // Set a timeout to prevent extremely long waits

    final success = await _authService.updateUserProfile(updatedProfile);

    setState(() {
      _isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Failed to update profile, please check your connection'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.red,
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.red),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField(
                      controller: _usernameController,
                      label: 'Username',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _ageController,
                      label: 'Age',
                      icon: Icons.cake,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value != null && value.isNotEmpty) {
                          final age = int.tryParse(value);
                          if (age == null || age < 1 || age > 120) {
                            return 'Please enter a valid age';
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _occupationController,
                      label: 'Occupation',
                      icon: Icons.work,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _hobbiesController,
                      label: 'Hobbies',
                      icon: Icons.sports_esports,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _favoriteMovieController,
                      label: 'Favorite Movie',
                      icon: Icons.movie,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black87,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.red,
            fontSize: 14,
          ),
          border: InputBorder.none,
          icon: Icon(icon, color: Colors.red),
        ),
      ),
    );
  }
}
