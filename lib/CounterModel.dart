import 'package:flutter/material.dart';

class CounterModel with ChangeNotifier {
  int _count = 0;

  int get value => _count;

  Color _color = Colors.red;

  Color get color => _color;

  void increment() {
    _count++;
    notifyListeners();
  }

  void changeColor(color) {
    _color = color;
    notifyListeners();
  }
}
