import 'package:flutter/foundation.dart';

class BalanceModel extends ChangeNotifier {
  double _balance = 10000.0;

  double get balance => _balance;

  void updateBalance(double newBalance) {
    _balance = newBalance;
    notifyListeners();
  }
}
