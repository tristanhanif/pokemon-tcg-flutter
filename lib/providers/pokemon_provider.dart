import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/pokemon_card_model.dart';
import '../models/pokemon_set_model.dart';
import 'auth_provider.dart';
import '../services/api_service.dart';

class PokemonProvider extends ChangeNotifier {
  final AuthProvider authProvider;
  PokemonProvider(this.authProvider);

  // Pokemon Cards (for detailed view)
  List<PokemonCard> _cards = [];
  final List<PokemonCard> _allCards = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 1;
  String? _errorMessage;
  String _searchQuery = '';

  // Pokemon Sets (for dashboard - infinite scroll)
  final List<PokemonSet> _pokemonSets = [];
  bool _isLoadingSets = false;
  bool _hasMoreSets = true;
  int _currentPageSets = 1;
  String? _errorMessageSets;
  String _searchQuerySets = '';

  List<PokemonCard> get cards => _cards;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  // Getters for sets
  List<PokemonSet> get pokemonSets => _pokemonSets;
  List<PokemonSet> get filteredPokemonSets {
    if (_searchQuerySets.isEmpty) return List.from(_pokemonSets);
    return _pokemonSets.where((set) {
      final query = _searchQuerySets.toLowerCase();
      return set.name.toLowerCase().contains(query) ||
          set.description.toLowerCase().contains(query);
    }).toList();
  }

  bool get isLoadingSets => _isLoadingSets;
  bool get hasMoreSets => _hasMoreSets;
  String? get errorMessageSets => _errorMessageSets;
  String get searchQuerySets => _searchQuerySets;

  /// 📦 Fetch Pokemon Sets with Infinite Scroll
  Future<void> fetchPokemonSets({bool isRefresh = false}) async {
    if (_isLoadingSets || (!_hasMoreSets && !isRefresh)) return;

    if (isRefresh) {
      _currentPageSets = 1;
      _pokemonSets.clear();
      _hasMoreSets = true;
      _errorMessageSets = null;
      notifyListeners();
    }

    _isLoadingSets = true;
    notifyListeners();

    try {
      final token = authProvider.token;
      if (token == null || token.isEmpty) {
        _errorMessageSets = 'Token tidak tersedia. Silakan login kembali.';
        _isLoadingSets = false;
        notifyListeners();
        return;
      }

      final result = await ApiService.fetchPokemonSets(
        bearerToken: token,
        page: _currentPageSets,
        limit: 10,
      );

      if (result['success']) {
        final data = result['data'];
        List<dynamic> items = [];

        if (data is List) {
          items = data;
        } else if (data is Map) {
          items = data['data'] ?? data['sets'] ?? [];
        }

        final newSets = items.map((e) => PokemonSet.fromJson(e)).toList();

        if (newSets.isEmpty || newSets.length < 10) {
          _hasMoreSets = false;
        }

        _pokemonSets.addAll(newSets);
        _currentPageSets++;
        _errorMessageSets = null;
      } else {
        _errorMessageSets = result['message'] ?? 'Gagal mengload sets';
      }
    } catch (e) {
      _errorMessageSets = 'Network error: $e';
    } finally {
      _isLoadingSets = false;
      notifyListeners();
    }
  }

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
        Uri.parse(
          'https://api.pokemontcg.io/v2/cards?page=$_currentPage&pageSize=20',
        ),
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

  void searchSets(String query) {
    _searchQuerySets = query;
    notifyListeners();
  }

  void _applySearch() {
    if (_searchQuery.isEmpty) {
      _cards = List.from(_allCards);
    } else {
      _cards = _allCards
          .where(
            (card) =>
                card.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
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
      if (token == null || token.isEmpty) {
        _errorMessage = 'Token tidak tersedia';
        return false;
      }

      final result = await ApiService.topupBalance(
        bearerToken: token,
        amount: amount,
      );

      if (result['success']) {
        final newBalance = result['balance'] ?? 0;
        await authProvider.updateBalance(newBalance);
        return true;
      } else {
        _errorMessage = result['message'] ?? 'Topup gagal';
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error: $e';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
