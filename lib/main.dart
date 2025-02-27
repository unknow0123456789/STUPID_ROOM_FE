
import 'package:fe/Base/route_listener.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:window_size/window_size.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // setWindowTitle('Flutter Desktop App');
  // setWindowMinSize(Size(850, 470));
  // HttpOverrides.global = new DevHttpOverrides();
  runApp(
    const ProviderScope(
        child: MyApp()
    )
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authCheck=ref.watch(checkLocalTokenProvider);
    return authCheck.when(
        data: (_)
        {
          // trackLastPage(ref.watch(routerProvider).router);
          return MaterialApp.router(
            routerConfig: ref.watch(routerProvider).router,
            title: 'STUPID_ROOM',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
          );
        },
        error: (err,stack){
          return MaterialApp.router(
            routerConfig: ref.watch(routerProvider).router,
            title: 'STUPID_ROOM',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
              useMaterial3: true,
            ),
            debugShowCheckedModeBanner: false,
          );
        },
        loading: ()
        {
          return LayoutBuilder(
            builder: (context,constraints)
            =>Center(
              child: Container(
                width: constraints.maxWidth/50,
                height: constraints.maxHeight/50,
                child: CircularProgressIndicator(
                  color: Colors.blue,

                ),
              ),
            ),
          );
        }
    );

  }
}
