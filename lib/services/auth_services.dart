import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Check if user is logged in
  bool get isLoggedIn => currentUser != null;

  // Register User
  Future<Map<String, dynamic>> registerWithEmail(
      String email, String password, String username) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'hobbies': '',
        'age': null,
        'occupation': '',
        'favoriteMovie': '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Registration successful'
      };
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'invalid-email':
          message = 'Email address is not valid';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        default:
          message = 'Registration failed: ${e.message}';
      }

      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Registration failed: $e'};
    }
  }

  // Login User
  Future<Map<String, dynamic>> loginWithEmail(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return {
        'success': true,
        'user': userCredential.user,
        'message': 'Login successful'
      };
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Wrong password';
          break;
        case 'invalid-credential':
          message = 'Invalid email or password';
          break;
        default:
          message = 'Login failed: ${e.message}';
      }

      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': 'Login failed: $e'};
    }
  }

  // Get user profile data with retry mechanism
  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) return null;

    try {
      // Try up to 3 times to get the profile
      for (int attempt = 0; attempt < 3; attempt++) {
        try {
          final doc =
              await _firestore.collection('users').doc(currentUser!.uid).get();
          if (doc.exists) {
            return doc.data();
          } else {
            // If document doesn't exist, create a default one
            Map<String, dynamic> defaultProfile = {
              'username': currentUser!.email?.split('@')[0] ?? 'User',
              'email': currentUser!.email ?? '',
              'hobbies': '',
              'age': null,
              'occupation': '',
              'favoriteMovie': '',
              'createdAt': FieldValue.serverTimestamp(),
            };

            await _firestore
                .collection('users')
                .doc(currentUser!.uid)
                .set(defaultProfile);
            return defaultProfile;
          }
        } catch (e) {
          if (attempt == 2) rethrow; // Throw on last attempt
          await Future.delayed(Duration(seconds: 1)); // Wait before retrying
        }
      }
    } catch (e) {
      print("Error getting user profile: $e");
      // Return basic profile if Firestore fails
      return {
        'username': currentUser!.email?.split('@')[0] ?? 'User',
        'email': currentUser!.email ?? '',
        'hobbies': '',
        'age': null,
        'occupation': '',
        'favoriteMovie': '',
      };
    }
    return null;
  }

  // Update user profile with retry
  Future<bool> updateUserProfile(Map<String, dynamic> data) async {
    if (currentUser == null) return false;

    try {
      // Try up to 3 times
      for (int attempt = 0; attempt < 3; attempt++) {
        try {
          await _firestore
              .collection('users')
              .doc(currentUser!.uid)
              .update(data);
          return true;
        } catch (e) {
          if (attempt == 2) rethrow;
          await Future.delayed(Duration(seconds: 1));
        }
      }
    } catch (e) {
      print("Error updating user profile: $e");
      return false;
    }
    return false;
  }

  // Logout User
  Future<void> logout() async {
    await _auth.signOut();
  }
}
