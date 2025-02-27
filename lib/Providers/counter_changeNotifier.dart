import 'package:flutter/material.dart';

class counterChangeNotifier extends ChangeNotifier
{
  int _counter;

  counterChangeNotifier(this._counter);

  int get counter => _counter;

  set counter(int value) {
    _counter = value;
    notifyListeners();
  }
}