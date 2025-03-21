

import 'package:fe/Base/ChosenTextStyle.dart';
import 'package:fe/Http.dart';
import 'package:fe/Models/SecureStorage.dart';
import 'package:fe/Base/WrappedText.dart';
import 'package:fe/Providers/counter_changeNotifier.dart';
import 'package:fe/Providers/login_changeNotifier.dart';
import 'package:fe/Screens/Client_Screens/Client_List_Screen/Client_List_Screen.dart';
import 'package:fe/Screens/Login_screen.dart';
import 'package:fe/Models/router.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';


final double mobileWidth=800;
final double mobileHeight=600;


final HttpApi stupidRoomAPI=HttpApi("https://phucfhs.cameraddns.net:8383");
final ChangeNotifierProvider counterController=ChangeNotifierProvider<counterChangeNotifier>((ref) => counterChangeNotifier(0));
final ChangeNotifierProvider<LoginChangeNotifier> loginController=ChangeNotifierProvider(
        (ref) => LoginChangeNotifier(needLogin: true)
            // ..checkLocalToken()
);

final checkLocalTokenProvider = FutureProvider<void>((ref) async {
  await ref.read(loginController).checkLocalToken();
});
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

final String lastPageKey="/stupidroom/lastpage";

final Provider<EasyRouter> routerProvider=Provider<EasyRouter>((ref){
  // ChangeNotifier cloneLoginController=ref.watch(loginController);
  // bool cloneNeedLogin=ref.read(loginController).needLogin;
  final EasyRouter easyRouter = EasyRouter(
      routeList: [
        NBD(
            route: GoRoute(
                path: "/login",
                pageBuilder: (context,state)=>const NoTransitionPage(child: LoginScreen())
            ),
          isNavOp: false
        ),
        NBD(
          route: GoRoute(path: "/",
              pageBuilder: (context,state)=>NoTransitionPage(child: ClientPage())),
          widget: Row(
            children: [
              Expanded(
                flex:1,
                child: Container(
                  child: Icon(
                    CupertinoIcons.collections,
                    color: Colors.black87,
                    size: 40,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return WrappedText(
                      data: "Client",
                      alterData:"Clt",
                      constraints: constraints,
                      style: navigationBarDestinationTextStyle
                    );
                  },
                ),
              )
            ],
          )
        ),
        NBD(
            route: GoRoute(
                path: "/account", 
                pageBuilder: (context,state)=>const NoTransitionPage(child: test_screen2())),
          widget: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex:1,
                child: Container(
                  child: Icon(
                    Icons.account_circle,
                    color: Colors.black87,
                    size: 40,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return WrappedText(
                        data: "Account",
                        alterData:"Acn",
                        constraints: constraints,
                      style: navigationBarDestinationTextStyle
                    );
                  },
                ),
              )
            ],
          )
        ),
      ],
      // errorBuilder: (context, state) {
      //   print("GoRouter ERROR: ${state.error}");
      //   return Scaffold(
      //     body: Center(child: Text("Page not found: ${state.fullPath}")),
      //   );
      // },
      refreshListenable: ref.read(loginController),
      redirect: (context, state) async {
        final needLogin = ref.read(loginController).needLogin;  // Getting the value of needLogin
        // print("Redirect triggered. Location: ${state.matchedLocation}, needLogin: $needLogin");
        final lastPage=await SecureStorage.getData(lastPageKey);
        // print ("Last Page was: '${lastPage}'");
        // await ref.read(loginController).checkLocalToken();
        if (needLogin && state.matchedLocation != "/login") {
          // print("DOES THIS");
          await SecureStorage.saveData(lastPageKey, state.matchedLocation);
          return "/login";
        }

        else if (!needLogin && state.matchedLocation == "/login") {
          // print("DOES THAT");
          return lastPage;
        }

        // print("No redirect triggered.");
        return null;
      }
  );
  return easyRouter;
});

