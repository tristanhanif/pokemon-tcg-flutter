import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon_card_model.dart';
import 'auth_provider.dart';

class PokemonProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  PokemonProvider(this.authProvider);

  List<PokemonCard> _cards = [];
  List<PokemonCard> _allCards = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _errorMessage;
  String _searchQuery = '';

  List<PokemonCard> get cards => _cards;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchCards({bool isRefresh = false}) async {
    if (_isLoading || (!_hasMore && !isRefresh)) return;
    
    if (isRefresh) {
      _currentPage = 1;
      _cards.clear();
      _allCards.clear();
      _hasMore = true;
      _errorMessage = null;
      notifyListeners();
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://api.pokemontcg.io/v2/cards?page=$_currentPage&pageSize=20'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = json.decode(response.body);
        final List<dynamic> items = body['data'] ?? [];
        
        final newCards = items.map((e) => PokemonCard.fromJson(e)).toList();
        
        if (newCards.isEmpty || newCards.length < 20) {
          _hasMore = false;
        }
        
        _allCards.addAll(newCards);
        _applySearch();
        _currentPage++;
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load cards: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Network error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchCards(String query) {
    _searchQuery = query;
    _applySearch();
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _cards = List.from(_allCards);
    } else {
      _cards = _allCards
          .where((card) => card.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  /// Topup Saldo
  Future<bool> topup(int amount) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = authProvider.token;
      final response = await http.post(
        Uri.parse('https://api-tcg-backend.vercel.app/api/users/topup'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'amount': amount}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Ambil balance baru dari API jika ada, jika tidak tambahkan manual
        final Map<String, dynamic> body = json.decode(response.body);
        final newBalance = body['data']?['balance'] ?? (authProvider.balance + amount);
        
        await authProvider.updateBalance(newBalance);
        _isLoading = false;
        notifyListeners();
        return true;
      } else if (response.statusCode == 401) {
        await authProvider.logout();
        _errorMessage = 'Sesi telah berakhir. Silakan login kembali.';
      } else {
        final body = jsonDecode(response.body);
        _errorMessage = body['message'] ?? 'Gagal melakukan topup.';
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan jaringan selama topup.';
    }
    
    _isLoading = false;
    notifyListeners();
    return false;
  }
}
