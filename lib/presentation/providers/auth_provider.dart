import 'package:flutter/foundation.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String? _userName;
  String? _userEmail;
  bool _isLoading = false;

  bool get isAuthenticated => _isAuthenticated;
  String? get userName => _userName;
  String? get userEmail => _userEmail;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _userName = 'Fahmi';
    _userEmail = email;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> signUp(String name, String email, String password) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    _userName = name;
    _userEmail = email;
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<bool> verifyOTP(String email, String otp) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;
    notifyListeners();
    return true;
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _userName = null;
    _userEmail = null;
    notifyListeners();
  }

  void updateProfile({String? name, String? email}) {
    if (name != null) _userName = name;
    if (email != null) _userEmail = email;
    notifyListeners();
  }
}
