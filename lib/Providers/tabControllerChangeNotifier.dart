import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TabControllerChangeNotifier extends ChangeNotifier
{
  final TabController tabController;


  TabControllerChangeNotifier(this.tabController)
  {
    tabController.addListener(() {
      if(tabController.indexIsChanging)
      {
        notifyListeners();
      }
    });
  }
}