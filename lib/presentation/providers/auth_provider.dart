import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabase = SupabaseService.instance;

  bool _isAuthenticated = false;
  String? _userName;
  String? _userEmail;
  String? _userAvatar;
  bool _isLoading = false;
  String? _error;
  String _pendingEmail = '';

  bool get isAuthenticated => _isAuthenticated;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  String? get userAvatar => _userAvatar;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get pendingEmail => _pendingEmail;

  AuthProvider() {
    _checkAuthState();
  }

  void _checkAuthState() {
    final user = _supabase.currentUser;
    if (user != null) {
      _isAuthenticated = true;
      _userName = user.userMetadata?['full_name'] as String? ?? '';
      _userEmail = user.email;
      _userAvatar = user.userMetadata?['avatar_url'] as String?;
      notifyListeners();
    }

    _supabase.authStateChanges.listen((data) {
      final event = data.event;
      final session = data.session;
      if (event == AuthChangeEvent.signedIn && session != null) {
        _isAuthenticated = true;
        _userName = session.user.userMetadata?['full_name'] as String? ?? '';
        _userEmail = session.user.email;
        _userAvatar = session.user.userMetadata?['avatar_url'] as String?;
      } else if (event == AuthChangeEvent.signedOut) {
        _isAuthenticated = false;
        _userName = null;
        _userEmail = null;
        _userAvatar = null;
      }
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _supabase.signIn(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _supabase.signUp(email: email, password: password, fullName: name);
      _pendingEmail = email;
      _isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> sendOTP(String email) async {
    _isLoading = true;
    _error = null;
    _pendingEmail = email;
    notifyListeners();
    try {
      await _supabase.client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.supabase.flutter://login-callback/',
      );
      _isLoading = false;
      notifyListeners();
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> verifyOTP(String email, String otp) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await _supabase.client.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.signup,
      );
      if (response.session != null) {
        _isAuthenticated = true;
        _userName = response.user?.userMetadata?['full_name'] as String? ?? '';
        _userEmail = response.user?.email;
        _isLoading = false;
        notifyListeners();
        return true;
      }
      _isLoading = false;
      notifyListeners();
      return false;
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _supabase.resetPassword(email);
      _isLoading = false;
      notifyListeners();
    } on AuthException catch (e) {
      _error = e.message;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _supabase.signOut();
    _isAuthenticated = false;
    _userName = null;
    _userEmail = null;
    _userAvatar = null;
    notifyListeners();
  }

  Future<void> updateProfile({String? name, String? email}) async {
    try {
      await _supabase.updateProfile(fullName: name);
      if (name != null) _userName = name;
      if (email != null) _userEmail = email;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
