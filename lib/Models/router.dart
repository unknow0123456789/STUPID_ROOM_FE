import 'dart:convert';

import 'package:fe/Base/EasyNavigationBar.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// final Map<String,Widget> routeList=
// {
//   "/login":LoginScreen(),
//   "/":test_screen1(),
//   "/account":test_screen2()
// };
//
// final GoRouter globalRouter = GoRouter(
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => test_screen1(),
//     ),
//     GoRoute(
//       path: '/login',
//       builder: (context, state) => LoginScreen(),
//     ),
//     GoRoute(
//       path: '/account',
//       builder: (context, state) => test_screen2(),
//     ),
//   ],
// );

class NBD
{
  String path;
  Widget widget;
  GoRoute route;
  bool isNavOp;

  NBD({
    required this.route,
    this.widget=const Icon(
        CupertinoIcons.nosign
    ),
    this.isNavOp=true
  }):path=route.path;
}

class EasyRouter
{
  final List<NBD> routeList;
  final GoRouter router;

  EasyRouter._internal(this.routeList,this.router);

  factory EasyRouter({
    required List<NBD> routeList,
    Codec<Object?, Object?>? extraCodec,
    GoExceptionHandler? onException,
    GoRouterPageBuilder? errorPageBuilder,
    GoRouterWidgetBuilder? errorBuilder,
    GoRouterRedirect? redirect,
    Listenable? refreshListenable,
    int redirectLimit = 5,
    bool routerNeglect = false,
    String? initialLocation,
    bool overridePlatformDefaultLocation = false,
    Object? initialExtra,
    List<NavigatorObserver>? observers,
    bool debugLogDiagnostics = false,
    GlobalKey<NavigatorState>? navigatorKey,
    String? restorationScopeId,
    bool requestFocus = true,
  })
  {
    List<RouteBase> routes=[];
    for (NBD route in routeList)
      {
        routes.add(route.route);
      }
    GoRouter goRouter=GoRouter(
      routes: routes,
      extraCodec: extraCodec,
      onException: onException,
      errorPageBuilder: errorPageBuilder,
      errorBuilder: errorBuilder,
      refreshListenable: refreshListenable,
      routerNeglect: routerNeglect,
      initialLocation: initialLocation,
      overridePlatformDefaultLocation: overridePlatformDefaultLocation,
      initialExtra: initialExtra,
      observers: observers,
      debugLogDiagnostics: debugLogDiagnostics,
      navigatorKey: navigatorKey,
      restorationScopeId: restorationScopeId,
      requestFocus: requestFocus,
        redirect: redirect,
        redirectLimit: redirectLimit
    );
    return EasyRouter._internal(routeList, goRouter);
  }

  String getCurrentPathFirstSegment() {
    Uri uri = Uri.parse(router.routerDelegate.currentConfiguration.uri.toString());
    return uri.pathSegments.isNotEmpty ? "/${uri.pathSegments.first}" : "/";
  }

}


class test_screen1 extends ConsumerWidget
{
  const test_screen1({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: EasyNavigationBar(ref.watch(routerProvider).routeList),
      body: Container(
        color: Colors.blueGrey,
        child: const Center(
          child: Text(
              "Screen 1"
          ),
        ),
      ),
    );
  }

}

class test_screen2 extends ConsumerWidget
{
  const test_screen2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: EasyNavigationBar(ref.watch(routerProvider).routeList),
      body: Container(
        color: Colors.white,
        child: const Center(
          child: Text(
              "Screen 2"
          ),
        ),
      ),
    );
  }

}