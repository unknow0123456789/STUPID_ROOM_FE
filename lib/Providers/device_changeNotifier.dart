import 'dart:convert';

import 'package:fe/Models/Stupid_Device.dart';
import 'package:fe/Models/Stupid_Token.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:flutter/cupertino.dart';

class DeviceChangeNotifier extends ChangeNotifier
{
  List<Stupid_Device> _devicesList;
  bool _isLoading=false;
  Stupid_Device? _focusedDevice;

  DeviceChangeNotifier():_devicesList=const [];

  Stupid_Device? get focusedDevice => _focusedDevice;

  set focusedDevice(Stupid_Device? value) {
    _focusedDevice = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  List<Stupid_Device> get devicesList => _devicesList;

  set devicesList(List<Stupid_Device> value) {
    _devicesList = value;
    notifyListeners();
  }

  Future<void> requestDevices(StupidToken userToken, int clientId) async
  {
    isLoading=true;

    final response=await stupidRoomAPI.getClientDevices(userToken,clientId);
    if (response.statusCode==200)
    {
      // print("Success !");
      // print("Body: "+(jsonDecode(response.body.toString())).toString());
      devicesList=(jsonDecode(response.body.toString()) as List).map((e) => Stupid_Device.fromJson(e)).toList();
      // print(jsonEncode(devicesList[0]));
    }
    else
    {
      print("Failed: "+ response.body);
    }
    isLoading=false;
  }
}