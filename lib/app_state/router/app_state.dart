import 'package:flutter/material.dart';

class YummyAppState extends ChangeNotifier {
  double _selectedIndex;

  YummyAppState() : _selectedIndex = 0;

  double get selectedIndex => _selectedIndex;

  set selectedIndex(double idx) {
    _selectedIndex = idx;
    notifyListeners();
  }
}
