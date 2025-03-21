import 'package:fe/Models/TimeUnitDropDown.dart';
import 'package:flutter/material.dart';

class DataOptions_ChangeNotifier extends ChangeNotifier
{
  final List<TimeUnitDropDown> _timeUnitList;
  int _selectedTimeUnitIndex;

  DataOptions_ChangeNotifier({required timeUnitList}):this._selectedTimeUnitIndex=0,this._timeUnitList=timeUnitList;


  List<TimeUnitDropDown> get timeUnitList => _timeUnitList;

  int get selectedTimeUnitIndex => _selectedTimeUnitIndex;

  set selectedTimeUnitIndex(int value) {
    _selectedTimeUnitIndex = value;
    notifyListeners();
  }
}