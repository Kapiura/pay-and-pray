import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BalanceProvider extends ChangeNotifier {
  int _balance = 1000;
  int _amount = 0;
  static const String _balanceKey = 'user_balance';

  BalanceProvider() {
    _loadBalance();
  }

  int get balance => _balance;
  int get amount => _amount;

  Future<void> _loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    _balance = prefs.getInt(_balanceKey) ?? 1000;
    notifyListeners();
  }

  Future<void> _saveBalance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_balanceKey, _balance);
  }

  void addFunds(int value) {
    _amount += value;
    _balance -= value;
    _saveBalance();
    notifyListeners();
  }

  void updateBalance(int value) {
    _balance += value;
    _saveBalance();
    notifyListeners();
  }

  void resetAmount() {
    _amount = 0;
    notifyListeners();
  }
}