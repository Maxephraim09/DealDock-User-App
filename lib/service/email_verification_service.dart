import 'package:firebase_auth/firebase_auth.dart';

class EmailVerificationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> sendVerificationEmail() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user available to send verification email.',
      );
    }
    await user.reload();
    if (!user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<bool> checkVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      return false;
    }
    await user.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  bool isUserSignedIn() {
    return _auth.currentUser != null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
