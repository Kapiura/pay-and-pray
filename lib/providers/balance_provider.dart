import 'package:flutter/material.dart';

class BalanceProvider extends ChangeNotifier {
  int _balance = 1000;
  int _amount = 0;

  int get balance => _balance;
  int get amount => _amount;

  void addFunds(int value) {
    _amount += value;
    _balance -= value;
    notifyListeners();
  }

  void updateBalance(int value) {
    _balance += value;
    notifyListeners();
  }

  void resetAmount() {
    _amount = 0;
    notifyListeners();
  }
}
