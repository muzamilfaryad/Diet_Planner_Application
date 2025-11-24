import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Firebase Authentication Service
/// Handles user authentication with email/password and Google Sign-In
class FirebaseAuthService {
  FirebaseAuthService._private();
  static final FirebaseAuthService instance = FirebaseAuthService._private();

  // Lazy initialization to avoid errors when Firebase is not configured
  FirebaseAuth? _auth;
  FirebaseAuth? get auth {
    try {
      _auth ??= FirebaseAuth.instance;
      return _auth;
    } catch (e) {
      if (kDebugMode) {
        print('Firebase not initialized: $e');
      }
      return null;
    }
  }

  // Google Sign-In configuration
  static const List<String> _googleScopes = ['email', 'profile'];
  static const String _googleClientId =
      '1037372126451-v41cqtb0rtad7r2j2jvlr7fb4d02s7b7.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  Future<void>? _googleInitFuture;

  /// Get current user
  User? get currentUser => auth?.currentUser;

  /// Get current user ID
  String? get currentUserId => auth?.currentUser?.uid;

  /// Check if user is signed in
  bool get isSignedIn => auth?.currentUser != null;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges =>
      auth?.authStateChanges() ?? Stream.value(null);

  /// Sign up with email and password
  Future<UserCredential?> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (auth == null) throw Exception('Firebase not initialized');

    try {
      final credential = await auth!.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await credential.user?.updateDisplayName(displayName);
      await credential.user?.reload();

      if (kDebugMode) {
        print('User signed up: ${credential.user?.uid}');
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Sign up error: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected sign up error: $e');
      }
      rethrow;
    }
  }

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (auth == null) throw Exception('Firebase not initialized');

    try {
      final credential = await auth!.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (kDebugMode) {
        print('User signed in: ${credential.user?.uid}');
      }

      return credential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Sign in error: ${e.code} - ${e.message}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected sign in error: $e');
      }
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    if (auth == null) return;

    try {
      await auth!.signOut();
      if (kDebugMode) {
        print('User signed out');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Sign out error: $e');
      }
      rethrow;
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    if (auth == null) throw Exception('Firebase not initialized');

    try {
      await auth!.sendPasswordResetEmail(email: email);
      if (kDebugMode) {
        print('Password reset email sent to: $email');
      }
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Password reset error: ${e.code} - ${e.message}');
      }
      rethrow;
    }
  }

  /// Delete current user account
  Future<void> deleteAccount() async {
    if (auth == null) return;

    try {
      await auth!.currentUser?.delete();
      if (kDebugMode) {
        print('User account deleted');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Delete account error: $e');
      }
      rethrow;
    }
  }

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitFuture != null) {
      await _googleInitFuture;
      return;
    }
    _googleInitFuture = _googleSignIn.initialize(clientId: _googleClientId);
    await _googleInitFuture;
  }

  Future<GoogleSignInAccount?> _authenticateWithGoogle() async {
    await _ensureGoogleInitialized();

    GoogleSignInAccount? account;
    try {
      final Future<GoogleSignInAccount?>? restored = _googleSignIn
          .attemptLightweightAuthentication();
      if (restored != null) {
        account = await restored;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Lightweight Google auth failed: $e');
      }
    }

    if (account != null) {
      return account;
    }

    if (!_googleSignIn.supportsAuthenticate()) {
      throw Exception(
        'GoogleSignIn.authenticate is not supported on this platform. '
        'Use the platform-specific sign-in button instead.',
      );
    }

    return _googleSignIn.authenticate(scopeHint: _googleScopes);
  }

  Future<String?> _fetchGoogleAccessToken(GoogleSignInAccount account) async {
    try {
      final GoogleSignInClientAuthorization? cached = await account
          .authorizationClient
          .authorizationForScopes(_googleScopes);
      if (cached != null) {
        return cached.accessToken;
      }
      final GoogleSignInClientAuthorization refreshed = await account
          .authorizationClient
          .authorizeScopes(_googleScopes);
      return refreshed.accessToken;
    } catch (e) {
      if (kDebugMode) {
        print('Unable to fetch Google access token: $e');
      }
      return null;
    }
  }

  /// Sign in with Google
  Future<UserCredential?> signInWithGoogle() async {
    if (auth == null) throw Exception('Firebase not initialized');

    try {
      final GoogleSignInAccount? googleUser = await _authenticateWithGoogle();

      if (googleUser == null) {
        if (kDebugMode) {
          print('Google sign-in cancelled or unavailable');
        }
        return null;
      }

      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final String? accessToken = await _fetchGoogleAccessToken(googleUser);

      final credential = GoogleAuthProvider.credential(
        accessToken: accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await auth!.signInWithCredential(credential);

      if (kDebugMode) {
        print('Google sign-in successful: ${userCredential.user?.uid}');
        print('User email: ${userCredential.user?.email}');
        print('User name: ${userCredential.user?.displayName}');
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Google sign-in error: ${e.code} - ${e.message}');
      }
      rethrow;
    } on GoogleSignInException catch (e) {
      if (kDebugMode) {
        print(
          'Google sign-in exception: ${e.code} - ${e.description ?? e.toString()}',
        );
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Google sign-in error: $e');
      }
      rethrow;
    }
  }

  /// Get user-friendly error message
  String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'popup-closed-by-user':
        return 'Sign-in cancelled. Please try again.';
      case 'popup-blocked':
        return 'Pop-up blocked. Please allow pop-ups and try again.';
      case 'cancelled-popup-request':
        return 'Sign-in cancelled.';
      case 'unauthorized-domain':
        return 'This domain is not authorized. Please contact support.';
      default:
        return 'An error occurred: ${e.message}';
    }
  }

  /// Get user-friendly error message for general exceptions
  String getGeneralErrorMessage(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('people api')) {
      return 'Google Sign-In setup incomplete. Please use Email/Password for now.';
    }
    if (errorString.contains('permission_denied')) {
      return 'Permission denied. Please use Email/Password instead.';
    }
    if (errorString.contains('popup')) {
      return 'Sign-in popup was blocked. Please allow pop-ups and try again.';
    }
    if (errorString.contains('network')) {
      return 'Network error. Please check your connection.';
    }

    return 'Unable to sign in with Google. Please use Email/Password instead.';
  }
}
