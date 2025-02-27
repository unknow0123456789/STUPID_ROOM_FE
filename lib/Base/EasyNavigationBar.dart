
import 'package:fe/Base/ImageButton.dart';
import 'package:fe/Models/router.dart';
import 'package:fe/Providers/registerProviders.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Models/WrappedText.dart';

class EasyNavigationBar extends ConsumerWidget implements PreferredSizeWidget
{
  final double height=50;
  final List<NBD> listNBD;


  const EasyNavigationBar(this.listNBD, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context,constraints)
          {
            return Container(
              height: height,
              width: ((){
                final width=constraints.maxWidth;
                // print (width.toString());
                return width;
              })(),
              decoration: const BoxDecoration(
                  color: Colors.blue
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                          child: LayoutBuilder(
                              builder: (context,constraints)
                              {
                                return WrappedText(
                                  data: "STUPID_ROOM",
                                  alterData: "SR",
                                  style: GoogleFonts.montserrat(
                                      textStyle:const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                        fontFamilyFallback: ['Arial'],
                                      )
                                  ),
                                  constraints: constraints,
                                );
                              }
                          )
                      ),
                    ),

                    Expanded(
                        flex: 7,
                        child: LayoutBuilder(
                            builder:(context,constraints) => SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Container(
                                  width: constraints.maxWidth,
                                  constraints: BoxConstraints(maxWidth: constraints.maxWidth),
                                  child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: ((){
                                    List<Widget> buttonList=[];
                                    for (NBD nbd in listNBD)
                                    {
                                      if(nbd.isNavOp) {
                                        final currentPathFirstSegement=ref.read(routerProvider).getCurrentPathFirstSegment();
                                        // print(currentPathFirstSegement);
                                        final selected=nbd.path == currentPathFirstSegement;
                                        buttonList.add(Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10),
                                            child: CustomButton(
                                                borderRadius: BorderRadius.circular(10),
                                                onTap: () {
                                                  // print("CHANGE TO "+nbd.path);
                                                  context.go(nbd.path);
                                                },
                                                child: ClipRRect(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                          color: Colors.white,
                                                      ),
                                                    child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Expanded(child: nbd.widget),
                                                          Container(
                                                            height: double.infinity,
                                                            color: (selected)?Colors.orange:CupertinoColors.systemGrey.withOpacity(0.5),
                                                            width: 30,
                                                            child: Icon(
                                                              (selected)? FluentIcons.emoji_laugh_20_filled:FluentIcons.emoji_meh_20_filled,
                                                                size: 20,
                                                              color: (selected)?Colors.white:Colors.black87,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                  ),
                                                )),
                                          ),
                                        ));
                                      }
                                    }
                                    return buttonList;
                                  })(),
                                                            ),
                                ),
                              ),
                            ),
                        )
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      flex: 1,
                      // child: Container(),
                      child: Center(
                        child: CustomButton(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black,
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                              child: Icon(
                                Icons.exit_to_app_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                          onTap: () async
                          {
                            await ref.read(loginController).logout();
                            // context.go("/login");
                            // print("LOGOUT!!! needLogin=${ref.read(loginController).needLogin}");
                          },
                        ),
                      )
                    ),
                  ],
                ),
              ),
            );
          }
    );
  }

  @override
  Size get preferredSize => Size(double.infinity,height);

}