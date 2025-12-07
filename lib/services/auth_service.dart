import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // List of admin emails
  final List<String> _adminEmails = [
    'sabifahaseeb@gmail.com', // Add your admin emails here
  ];

  Stream<User?> get user => _auth.authStateChanges();

  Future<bool> isAdmin() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return false;
    }
    return _adminEmails.contains(currentUser.email);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
