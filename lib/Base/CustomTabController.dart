
import 'package:fe/Providers/tabControllerChangeNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomTabController extends ConsumerWidget
{

  final List<Widget> tabs;

  CustomTabController(this.tabs);

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
                          height: 70,
                          width: 30,
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
                          height: 70,
                          width: 30,
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
                                    color: Colors.white.withOpacity(0.5),
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