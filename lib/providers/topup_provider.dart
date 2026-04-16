import 'package:flutter/material.dart';
import '../models/topup_item_model.dart';

class TopupProvider extends ChangeNotifier {
  // Predefined topup items berdasarkan mockup
  final List<TopupItem> _topupItems = [
    // Coins
    TopupItem(
      id: 'coin_150',
      name: 'ECO BISCUIT',
      amount: 150,
      icon: '🍪',
      category: 'coins',
    ),
    TopupItem(
      id: 'coin_100',
      name: 'CUBE MODULE',
      amount: 100,
      icon: '📦',
      category: 'coins',
    ),
    TopupItem(
      id: 'coin_480',
      name: 'CODE POTION',
      amount: 480,
      icon: '⚗️',
      category: 'coins',
    ),
    // Balls
    TopupItem(
      id: 'ball_20',
      name: '20 POKÉBALLS',
      amount: 20,
      icon: 'assets/pokeball.png',
      category: 'balls',
    ),
    TopupItem(
      id: 'ball_40',
      name: '40 GREAT BALLS',
      amount: 40,
      icon: 'assets/great_ball.png',
      category: 'balls',
    ),
    TopupItem(
      id: 'ball_80',
      name: '80 ULTRA BALLS',
      amount: 80,
      icon: 'assets/ultra_ball.png',
      category: 'balls',
    ),
    // Items
    TopupItem(
      id: 'item_drop1',
      name: 'WATER DROP',
      amount: 150,
      icon: '💧',
      category: 'items',
    ),
    TopupItem(
      id: 'item_wind1',
      name: 'WIND ESSENCE',
      amount: 100,
      icon: '💨',
      category: 'items',
    ),
    TopupItem(
      id: 'item_cloud1',
      name: 'CLOUD MIST',
      amount: 480,
      icon: '☁️',
      category: 'items',
    ),
  ];

  TopupItem? _selectedItem;
  bool _isProcessing = false;
  String? _errorMessage;
  String? _successMessage;

  List<TopupItem> get topupItems => _topupItems;
  TopupItem? get selectedItem => _selectedItem;
  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  // Group items by category
  Map<String, List<TopupItem>> get groupedItems {
    final grouped = <String, List<TopupItem>>{};
    for (var item in _topupItems) {
      if (!grouped.containsKey(item.category)) {
        grouped[item.category] = [];
      }
      grouped[item.category]!.add(item);
    }
    return grouped;
  }

  void selectItem(TopupItem item) {
    _selectedItem = item;
    _errorMessage = null;
    notifyListeners();
  }

  void clearSelection() {
    _selectedItem = null;
    _errorMessage = null;
    notifyListeners();
  }

  void setProcessing(bool value) {
    _isProcessing = value;
    notifyListeners();
  }

  void setErrorMessage(String message) {
    _errorMessage = message;
    _successMessage = null;
    notifyListeners();
  }

  void setSuccessMessage(String message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
