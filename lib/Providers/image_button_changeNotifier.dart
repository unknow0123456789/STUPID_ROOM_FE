import 'package:flutter/foundation.dart';

class imageButtonChangeNotifier extends ChangeNotifier
{
  bool _isPress;
  bool _isHover;

  imageButtonChangeNotifier([this._isPress=false,this._isHover=false]);

  bool get isPress => _isPress;

  set isPress(bool value) {
    _isPress = value;
    notifyListeners();
  }

  bool get isHover => _isHover;

  set isHover(bool value) {
    _isHover = value;
    notifyListeners();

  }


}