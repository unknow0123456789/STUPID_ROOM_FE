import 'package:fe/Base/BasicLoadingScreen.dart';
import 'package:fe/Base/ChosenTextStyle.dart';
import 'package:fe/Base/EasyNavigationBar.dart';
import 'package:fe/Base/ImageButton.dart';
import 'package:fe/Models/Stupid_Client.dart';
import 'package:fe/Models/TimeUnitDropDown.dart';
import 'package:fe/Providers/client_changeNotifier.dart';
import 'package:fe/Providers/dataOptions_changeNotifier.dart';
import 'package:fe/Providers/device_changeNotifier.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:fe/Screens/Client_Screens/Client_Detail_Screen/Client_Detail_Screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClientPage extends ConsumerWidget
{
  final ChangeNotifierProvider<ClientChangeNotifier> clientController= ChangeNotifierProvider(
          (ref) {
        return ClientChangeNotifier();
      }
  );
  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController=ChangeNotifierProvider((ref) => DeviceChangeNotifier());
  final ChangeNotifierProvider<DataOptions_ChangeNotifier> dataOptionController=ChangeNotifierProvider((ref) =>
      DataOptions_ChangeNotifier(
          timeUnitList:[
            TimeUnitDropDown("Second", "s"),
            TimeUnitDropDown("Minute", "m"),
            TimeUnitDropDown("Hour", "h"),
            TimeUnitDropDown("Day", "d")
          ])
  );
  bool firstLoad=true;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientNotifier = ref.watch(clientController);

    if (firstLoad) {
      firstLoad = false;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        try {
          await ref.read(clientController).requestClients(ref
              .watch(loginController)
              .userToken!);
        }
        catch(e)
        {

        }
      });
    }

    return Scaffold(
        appBar: EasyNavigationBar(ref
            .watch(routerProvider)
            .routeList),
        body: (clientNotifier.isLoading) ?
        BasicLoadingWidget()
            :
        _clientView(clientNotifier.clientList,clientController,deviceController,dataOptionController)
    );
  }
}

class _clientView extends ConsumerWidget
{

  final List<Stupid_Client> clientList;
  final  ChangeNotifierProvider<ClientChangeNotifier> clientController;
  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController;
  final ChangeNotifierProvider<DataOptions_ChangeNotifier> dataOptionController;



  _clientView(this.clientList,this.clientController,this.deviceController,this.dataOptionController);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
        builder: (context,constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  color: Colors.white,
                  width: constraints.maxWidth,
                  // height: constraints.maxHeight,
                  child:Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: (clientList.map((e) =>
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                          child: CustomButton(
                              borderRadius: BorderRadius.circular(10),
                              onTap: ()
                              {
                                ref.read(clientController).focusClient=e;
                              },
                              child: _clientCard(e)
                          ),
                        )
                    )).toList(),
                  ),
                ),
              ),
              Visibility(
                  visible: (ref.watch(clientController).focusClient!=null),
                  child: Client_Detail(ref.watch(clientController).focusClient,clientController,deviceController,dataOptionController)
              )
            ],
          );
        }
    );
  }

}

class _clientCard extends ConsumerWidget
{
  final Stupid_Client client;

  _clientCard(this.client);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context,constraints)=>
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              height: 100,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.3),
                //     blurRadius: 10,
                //     spreadRadius: 3,
                //     offset: Offset(3,3)
                //   )
                // ]
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                        flex:1,
                        child: Container(
                          color: Colors.blue,
                          child: Center(
                            child: Icon(
                              CupertinoIcons.house,
                              color: Colors.white,
                              size: (constraints.maxWidth / 15).clamp(20, 60),
                            ),
                          ),
                        )
                    ),
                    Expanded(
                        flex:10,
                        child: Container(
                          child: Center(
                            child: Text(
                              client.name,
                              style: clientCardNameStyle(constraints),
                            ),
                          ),
                        )
                    ),
                    Flexible(
                        fit: FlexFit.loose,
                        flex:1,
                        child: LayoutBuilder(
                          builder: (sContext,sConstraints)=>
                              Container(
                                  child: Center(
                                    child: IconButton(
                                      onPressed: ()
                                      {
                                        // print("hehehe");
                                      },
                                      icon: Icon(
                                        Icons.
                                        more_vert,
                                        color: Colors.black87,
                                        size: (sConstraints.maxWidth/3).clamp(20, 30),
                                      ),
                                    ),
                                  )
                              ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
    );
  }

}