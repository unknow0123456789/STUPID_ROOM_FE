import 'dart:convert';

import 'package:fe/Models/SecureStorage.dart';
import 'package:fe/Models/Stupid_Token.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginChangeNotifier extends ChangeNotifier{
  String dataKey="/stupidroom/token";
  bool _isRegister;
  bool _needLogin;
  StupidToken? _userToken;
  String? _error_message;
  late TextEditingController username_controller;
  late TextEditingController password_controller;
  late TextEditingController register_username_controller;
  late TextEditingController register_password_controller;
  late TextEditingController register_password2_controller;

  LoginChangeNotifier({bool isRegister=false, bool needLogin=true}):_needLogin=needLogin,_isRegister=isRegister
  {
    reset();
  }

  bool get isRegister => _isRegister;

  String? get error_message => _error_message;


  bool get needLogin => _needLogin;

  set needLogin(bool value) {
    // print("VALUE CHANGE TO "+value.toString());
    _needLogin = value;
    notifyListeners();
  }

  set error_message(String? value) {
    _error_message = value;
    notifyListeners();
  }

  set isRegister(bool value) {
    _isRegister = value;
    notifyListeners();
  }

  Future<void> checkLocalToken() async
  {
    String? data = await SecureStorage.getData(dataKey);
    bool needLogin=true;
    if (data!=null)
      {
        // print("Data: "+ data +" Type: "+data.runtimeType.toString());
        final token=StupidToken.fromJson(data);
        if(DateTime.now().isBefore(token.exp))
          {
            final response = await stupidRoomAPI.testToken(token);
            if (response.statusCode==200)
              {
                needLogin=false;
                userToken=token;
              }
            else
              {
                await SecureStorage.removeData(dataKey);
              }
          }
      }
    this.needLogin=needLogin;
  }

  void reset()
  {
    username_controller=TextEditingController();
    password_controller=TextEditingController();
    register_username_controller=TextEditingController();
    register_password_controller=TextEditingController();
    register_password2_controller=TextEditingController();
    _isRegister=false;
    _error_message=null;
    notifyListeners();
  }

  Future<void> logout() async
  {
    await SecureStorage.removeData(dataKey);
    _needLogin=true;
    _userToken=null;
    reset();
  }

  StupidToken? get userToken {
    if (_userToken == null) {
      needLogin = true;
    }
    return _userToken;
  }

  set userToken(StupidToken? value) {
    _userToken = value;
    if(userToken!=null)
      SecureStorage.saveData(dataKey, jsonEncode(value));
    notifyListeners();
  }

  // void loginCheck(BuildContext context)
  // {
  //   if (needLogin) {
  //     context.go("/login");
  //   }
  // }
}