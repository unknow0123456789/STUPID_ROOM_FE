import 'package:fe/Screens/Login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MainScreen extends ConsumerWidget
{
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // Container(
        //   color: Colors.blueGrey.withOpacity(0.5),
        //   child: Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.start,
        //         children: [
        //           CustomButton(
        //             onTap: () {
        //               ref
        //                   .read(loginController)
        //                   .needLogin = true;
        //             },
        //             color: Colors.grey,
        //             boderRadius: BorderRadius.circular(30),
        //             child: Icon(
        //               CupertinoIcons.restart,
        //               size: 30,
        //               color: Colors.black,
        //             ),
        //           ),
        //           CustomButton(
        //             onTap: () {
        //               navigatorKey.currentState?.pushNamed("/screen1");
        //             },
        //             color: Colors.red,
        //             boderRadius: BorderRadius.circular(30),
        //             child: Icon(
        //               Icons.navigate_before,
        //               size: 30,
        //               color: Colors.black,
        //             ),
        //           ),
        //           CustomButton(
        //             onTap: () {
        //               navigatorKey.currentState?.pushNamed("/screen2");
        //             },
        //             color: Colors.blue,
        //             boderRadius: BorderRadius.circular(30),
        //             child: Icon(
        //               Icons.navigate_next,
        //               size: 30,
        //               color: Colors.black,
        //             ),
        //           ),
        //         ],
        //       ),
        //       Navigator(
        //         key: navigatorKey,
        //         onGenerateRoute: (settings)
        //         {
        //           WidgetBuilder builder;
        //           switch(settings.name)
        //           {
        //             case "/screen1":
        //               builder= (BuildContext context) => test_screen1();
        //               break;
        //             case "/screen2":
        //               builder= (BuildContext context) => test_screen2();
        //               break;
        //             default:
        //               builder= (BuildContext context) => test_screen1();
        //           }
        //           return MaterialPageRoute(builder: builder,settings: settings);
        //         },
        //       )
        //     ],
        //   )
        // ),
        Visibility(
            visible: (() {
              // return ref
              //     .watch(loginController)
              //     .needLogin;
              return false;
            })(),
            child: const LoginScreen()
        ),
      ],
    );
  }

}
