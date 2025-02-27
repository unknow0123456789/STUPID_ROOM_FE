import 'dart:convert';

import 'package:fe/Models/Stupid_Client.dart';
import 'package:fe/Models/Stupid_Token.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientChangeNotifier extends ChangeNotifier
{
  List<Stupid_Client> _clientList;
  bool _isLoading=false;
  Stupid_Client? _focusClient;

  ClientChangeNotifier():_clientList=const[];

  List<Stupid_Client> get clientList => _clientList;

  set clientList(List<Stupid_Client> value) {
    _clientList = value;
    notifyListeners();
  }


  Stupid_Client? get focusClient => _focusClient;

  set focusClient(Stupid_Client? value) {
    _focusClient = value;
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> requestClients(StupidToken userToken) async
  {
    isLoading=true;

    final response=await stupidRoomAPI.getSelfClient(userToken);
    if (response.statusCode==200)
      {
        // print("Success !");
        // print("Body: "+(jsonDecode(response.body.toString())).toString());
        clientList=(jsonDecode(response.body.toString()) as List).map((e) => Stupid_Client.fromJson(e)).toList();
        // print(jsonEncode(clientList[0]));
      }
    else
      {
        print("Failed: "+ response.body);
      }
    isLoading=false;
  }
  
}