import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _isLoggedIn = false;
  String? _token;
  int _balance = 0; // Menambahkan balance mock/real

  User? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _isLoggedIn;
  User? get currentUser => _currentUser;
  String? get token => _token;
  int get balance => _balance;

  AuthProvider() {
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _balance = prefs.getInt('user_balance') ?? 0;
    if (_token != null && _token!.isNotEmpty) {
      _isLoggedIn = true;
    }
    notifyListeners();
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
  }

  Future<void> updateBalance(int amount) async {
    final prefs = await SharedPreferences.getInstance();
    _balance = amount;
    await prefs.setInt('user_balance', _balance);
    notifyListeners();
  }

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
<<<<<<< HEAD
      final uri = Uri.parse(
        'https://api-tcg-backend.vercel.app/api/auth/register',
      );

=======
>>>>>>> a82a2b042064581a1c2f17a32105ebb0728bd5c8
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
<<<<<<< HEAD

      final body = jsonDecode(response.body);
      _setError(
        body['message']?.toString() ??
            body['error']?.toString() ??
            'Registrasi gagal.',
      );
      return false;
    } catch (exception) {
      _setError('Tidak dapat terhubung ke server.');
=======
    } catch (e) {
      _setError('Network error: $e');
>>>>>>> a82a2b042064581a1c2f17a32105ebb0728bd5c8
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
<<<<<<< HEAD
      final uri = Uri.parse(
        'https://api-tcg-backend.vercel.app/api/auth/login',
      );

=======
>>>>>>> a82a2b042064581a1c2f17a32105ebb0728bd5c8
      final response = await http.post(
        Uri.parse('https://api-tcg-backend.vercel.app/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

<<<<<<< HEAD
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = jsonDecode(response.body);
        final token = body['data']?['token'] ?? body['token'];

        if (token == null || token.toString().isEmpty) {
          _setError("Token tidak diterima dari server.");
          return false;
        }

        await _saveToken(token);

        _currentUser = User(
          id: 1,
          name: username,
          email: "hidden",
          role: "user",
          password: "",
        );

        final balanceFromApi = body['data']?['balance'] ?? body['balance'];
        _balance = balanceFromApi != null
            ? int.tryParse(balanceFromApi.toString()) ?? 0
            : 0;
        await updateBalance(_balance);

=======
      if (response.statusCode == 200) {
        // Assuming success, perhaps parse token if available
>>>>>>> a82a2b042064581a1c2f17a32105ebb0728bd5c8
        _isLoggedIn = true;
        _setLoading(false);
        return true;
      } else {
        final errorData = jsonDecode(response.body);
        _setError(errorData['message'] ?? 'Username atau password salah');
        return false;
      }
<<<<<<< HEAD

      final body = jsonDecode(response.body);
      _setError(
        body['message']?.toString() ??
            body['error']?.toString() ??
            "Login gagal. Cek email dan password.",
      );
      return false;
=======
>>>>>>> a82a2b042064581a1c2f17a32105ebb0728bd5c8
    } catch (e) {
      _setError('Network error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// 🚪 LOGOUT
  Future<void> logout() async {
    _isLoggedIn = false;
    _currentUser = null;
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
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
