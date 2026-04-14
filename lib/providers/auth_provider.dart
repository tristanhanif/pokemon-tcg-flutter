import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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

    try {
      final response = await http.post(
        Uri.parse('https://api-tcg-backend.vercel.app/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name,
          'email': email,
          'password_hash': password,
          'confirm_password': confirmPassword,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Assuming success
        _setLoading(false);
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _setError(errorData['message'] ?? 'Registration failed');
        return false;
      }
    } catch (e) {
      _setError('Network error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 🔑 LOGIN
  Future<bool> login({
    required String username,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await http.post(
        Uri.parse('https://api-tcg-backend.vercel.app/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Assuming success, perhaps parse token if available
        _isLoggedIn = true;
        _setLoading(false);
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _setError(errorData['message'] ?? 'Username atau password salah');
        return false;
      }
    } catch (e) {
      _setError('Network error: $e');
      return false;
    } finally {
      _setLoading(false);
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