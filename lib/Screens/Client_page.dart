import 'dart:convert';

import 'package:fe/Base/BasicLoadingScreen.dart';
import 'package:fe/Base/ChoseTextStyle.dart';
import 'package:fe/Base/EasyNavigationBar.dart';
import 'package:fe/Base/ImageButton.dart';
import 'package:fe/Models/Stupid_Client.dart';
import 'package:fe/Models/Stupid_Token.dart';
import 'package:fe/Providers/client_changeNotifier.dart';
import 'package:fe/Providers/device_changeNotifier.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:fe/Providers/tabControllerChangeNotifier.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

final backgroundColor=Colors.white;
final foregroundColor=Colors.white;

class ClientPage extends ConsumerWidget
{
  final ChangeNotifierProvider<ClientChangeNotifier> clientController= ChangeNotifierProvider(
          (ref) {
        return ClientChangeNotifier();
      }
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
        _clientView(clientNotifier.clientList,clientController)
    );
  }
}

class _clientView extends ConsumerWidget
{

  final List<Stupid_Client> clientList;
  final  ChangeNotifierProvider<ClientChangeNotifier> clientController;


  _clientView(this.clientList,this.clientController);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
        builder: (context,constraints) {
          return Stack(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  color: backgroundColor,
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
                  child: Client_Detail(ref.watch(clientController).focusClient,clientController)
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
              color: foregroundColor,
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


class Client_Detail extends ConsumerWidget
{
  final Stupid_Client? client;
  final ChangeNotifierProvider<ClientChangeNotifier> clientController;
  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController=ChangeNotifierProvider((ref) => DeviceChangeNotifier());
  bool firstLoad=true;

  Client_Detail(this.client,this.clientController);

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
      builder: (context,constraints)=>(deviceNotifier.isLoading)?
          BasicLoadingWidget()
      :
          Container(
            width: double.infinity,
            height: double.infinity,
          color: Colors.white,
          child: Stack(
            children: [
              ((){
                if(client!=null) {
                  if (constraints.maxWidth < mobileWidth)
                    return _clientDetailMobileView(client!,deviceController);
                  return _clientDetailDesktopView(client!,deviceController);
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

class _clientDetailMobileView extends ConsumerWidget
{

  Stupid_Client client;
  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController;

  List<Widget> dataTabs=[
    Container(
      color: Colors.purpleAccent,
    ),
    Container(
      color: Colors.yellowAccent,
    )
  ];


  _clientDetailMobileView(this.client,this.deviceController);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context,constraints)
      {
        return Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            children: [
              Expanded(
                  flex:5,
                  child: _customTabController(dataTabs)
              ),
              Expanded(
                  flex: 3,
                  child: _customTabController(
                      [
                        LayoutBuilder(
                          builder: (context,constraints)=>
                              Container(
                                height: constraints.maxHeight,
                                color: Colors.grey,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          client.name,
                                          style: GoogleFonts.teko(
                                            textStyle:TextStyle(
                                              fontSize: 30,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold
                                            )
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        ),
                        Container(
                          color: Colors.orangeAccent,
                        )
                      ]
                  )
              )
            ],
          ),
        );
      },
    );
  }

}

class _customTabController extends ConsumerWidget
{

  final List<Widget> tabs;

  _customTabController(this.tabs);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(
          builder: (context){
            final tabController=DefaultTabController.of(context);
            final ChangeNotifierProvider<TabControllerChangeNotifier> tabProvider=ChangeNotifierProvider((ref) => TabControllerChangeNotifier(tabController));
            return Stack(
              children: [
                TabBarView(
                  children: tabs,
                ),
                Container(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: IconButton(
                              onPressed: (){
                                // tabController.index=(tabController.index-1).clamp(0,tabController.length-1);
                                ref.read(tabProvider).tabController.animateTo((tabController.index-1).clamp(0,tabController.length-1));
                              },
                              icon: Icon(
                                CupertinoIcons.back,
                                size: 20,
                                color: Colors.black87,
                              )
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: SizedBox(
                          height: 50,
                          width: 50,
                          child: IconButton(
                              onPressed: (){
                                ref.read(tabProvider).tabController.animateTo((tabController.index+1).clamp(0,tabController.length-1));
                                // tabController.index=(tabController.index+1).clamp(0,tabController.length-1);
                              },
                              icon: Icon(
                                CupertinoIcons.right_chevron,
                                size: 20,
                                color: Colors.black87,
                              )
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _tabsDotIndicator(tabProvider)
              ],
            );
          }
      ),
    );
  }

}

class _tabsDotIndicator extends ConsumerWidget
{
  final ChangeNotifierProvider<TabControllerChangeNotifier> tabProvider;

  _tabsDotIndicator(this.tabProvider);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IgnorePointer(
      ignoring: true,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: LayoutBuilder(
          builder: (context,constraints) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(
                        ref.read(tabProvider).tabController.length,
                            (i) {
                          final double selectedSize=15;
                          final double unselectedSize=10;
                          return Container(
                            height: selectedSize,
                            width: selectedSize,
                            child: Center(
                              child: Container(
                                height: (ref
                                    .watch(tabProvider)
                                    .tabController
                                    .index == i) ? selectedSize : unselectedSize,
                                width: (ref
                                    .watch(tabProvider)
                                    .tabController
                                    .index == i) ? selectedSize : unselectedSize,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white.withOpacity(0.8),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      blurRadius: 10,
                                      spreadRadius: 5,
                                      offset: Offset(3,3)
                                    )
                                  ]
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  )
              ),
            );
          },
        ),
      ),
    );
  }
  
}


class _clientDetailDesktopView extends ConsumerWidget
{

  Stupid_Client client;
  final ChangeNotifierProvider<DeviceChangeNotifier> deviceController;



  _clientDetailDesktopView(this.client,this.deviceController);

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