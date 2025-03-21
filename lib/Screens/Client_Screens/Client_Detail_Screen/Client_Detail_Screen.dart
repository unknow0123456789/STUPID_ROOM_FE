import 'package:fe/Base/ImageButton.dart';
import 'package:fe/Models/Stupid_Client.dart';
import 'package:fe/Providers/client_changeNotifier.dart';
import 'package:fe/Providers/dataOptions_changeNotifier.dart';
import 'package:fe/Providers/device_changeNotifier.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:fe/Screens/Client_Screens/Client_Detail_Screen/Desktop/Client_Detail_Desktop_Screen.dart';
import 'package:fe/Screens/Client_Screens/Client_Detail_Screen/Mobile/Client_Detail_Mobile_Screen.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Client_Detail extends ConsumerWidget
{
  final Stupid_Client? client;
  final ChangeNotifierProvider<ClientChangeNotifier> clientController;
  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController;
  final ChangeNotifierProvider<DataOptions_ChangeNotifier> dataOptionController;
  bool firstLoad=true;

  Client_Detail(this.client,this.clientController,this.deviceController,this.dataOptionController);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deviceNotifier = ref.watch(deviceController);
    if (firstLoad) {
      firstLoad = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        try
        {
          await ref.read(deviceController).requestDevices(ref.watch(loginController).userToken!, client!.id!);
          // print("result: ${deviceNotifier.devicesList.toString()}");
        }
        catch (e)
        {

        }
      });
    }

    return LayoutBuilder(
      builder: (context,constraints)=>
      // (deviceNotifier.isLoading)?
      //     BasicLoadingWidget()
      // :
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
        child: Stack(
          children: [
            ((){
              if(client!=null) {
                if (constraints.maxWidth < mobileWidth)
                  return ClientDetailMobileView(client!,deviceController,dataOptionController);
                return ClientDetailDesktopView(client!,deviceController);
              }
              return Container();
            })(),
            Padding(
              padding: const EdgeInsets.all(15),
              child: CustomButton(
                  onTap: (){
                    ref.read(clientController).focusClient=null;
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: const Icon(
                        FluentIcons.dismiss_12_regular,
                        size: 30,
                        color: Colors.black87,
                      ),
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

}