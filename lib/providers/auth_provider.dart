import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;

  User? _currentUser;
  final List<User> _registeredUsers = [];

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;

  /// 🔐 REGISTER
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    await Future.delayed(const Duration(seconds: 1));

    email = email.trim();

    if (password != confirmPassword) {
      _setError("Password tidak sama");
      return false;
    }

    if (_registeredUsers.any((user) => user.email == email)) {
      _setError("Email sudah terdaftar");
      return false;
    }

    final newUser = User(
      id: _registeredUsers.length + 1,
      name: name,
      email: email,
      role: "user",
      password: password, // ⚠️ nanti ganti hash kalau ke production
    );

    _registeredUsers.add(newUser);

    _setLoading(false);
    return true;
  }

  /// 🔑 LOGIN
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    await Future.delayed(const Duration(seconds: 1));

    email = email.trim();
    password = password.trim();

    try {
      final user = _registeredUsers.firstWhere(
        (user) => user.email == email,
      );

      if (user.password != password) {
        _setError("Password salah");
        return false;
      }

      _currentUser = user;
      _isLoggedIn = true;

      _setLoading(false);
      return true;
    } catch (e) {
      _setError("Email tidak ditemukan");
      return false;
    }
  }

  /// 🚪 LOGOUT
  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    notifyListeners();
  }

  /// ⚙️ INTERNAL STATE
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}