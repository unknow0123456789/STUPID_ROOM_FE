import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

String? lastPage;

void trackLastPage(GoRouter goRouter) {

  goRouter.routerDelegate.addListener(() {
    final currentPage = goRouter.routerDelegate.currentConfiguration.uri.toString();

    if (currentPage != lastPage) {
      print("Navigated from: $lastPage → $currentPage");
      lastPage = currentPage; // Store last page before updating
    }
  });
}