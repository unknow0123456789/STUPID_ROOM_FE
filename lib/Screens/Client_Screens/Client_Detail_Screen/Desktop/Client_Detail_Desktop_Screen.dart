
import 'package:fe/Models/Stupid_Client.dart';
import 'package:fe/Providers/device_changeNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientDetailDesktopView extends ConsumerWidget
{

  Stupid_Client client;
  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController;



  ClientDetailDesktopView(this.client,this.deviceController);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context,constraints)
      {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Row(
            children: [
              Expanded(
                  flex:5,
                  child: Container(
                    color: Colors.greenAccent,
                  )
              ),
              Expanded(
                flex: 3,
                child: Container(
                  color: Colors.orangeAccent,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}