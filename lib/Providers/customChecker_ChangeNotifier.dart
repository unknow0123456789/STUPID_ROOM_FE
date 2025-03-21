import 'package:fe/Base/CustomChecker.dart';
import 'package:fe/Models/CustomCheckerItem.dart';
import 'package:flutter/cupertino.dart';

class CustomCheckerChangeNotifier extends ChangeNotifier
{
  List _items;

  CustomCheckerChangeNotifier([this._items=const []]);

  void checkAt(int index)
  {
    _items[index].isCheck=!_items[index].isCheck;
    notifyListeners();
  }

  List get items => _items;

  set items(List value) {
    _items = value;
    notifyListeners();
  }
}