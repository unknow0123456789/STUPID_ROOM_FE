import 'dart:ui';

import 'package:fe/Providers/image_button_changeNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomButton extends ConsumerWidget
{
  final ChangeNotifierProvider<imageButtonChangeNotifier> imageButtonController=ChangeNotifierProvider<imageButtonChangeNotifier>((ref) => imageButtonChangeNotifier());
  final Function onTap;
  final Widget child;
  final Color color;
  final BorderRadius borderRadius;


  CustomButton({super.key, 
    required this.onTap,
    required this.child,
    this.color=Colors.transparent,
    this.borderRadius=BorderRadius.zero
  });

  //WARNING: DO NOT PUT PADDING IN THE CHILD WIDGET, IF NEEDED, PUT IT ON THIS CUSTOM BUTTON WIDGET SINCE PADDING WILL MESS UP THE ON HOVER EFFECT !!!!
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: implement build
    return MouseRegion(
      onEnter: (_){ref.read(imageButtonController).isHover=true;},
      onExit: (_){ref.read(imageButtonController).isHover=false;},
      child: GestureDetector(
        // onTap: () {
        //   ref
        //       .read(imageButtonController)
        //       .isPress = true;
        //   onTap();
        //   print("Tap");
        // },
        onTap: ()
        {
          onTap();
        },
        onTapDown: (_) {
          ref
              .read(imageButtonController)
              .isPress = true;
          // print("Tap");
        },
        onTapCancel: () {
          ref
              .read(imageButtonController)
              .isPress = false;
          // print("Not Tap");
        },
        onTapUp: (_) {
          ref
              .read(imageButtonController)
              .isPress = false;
          // print("Not Tap");
        },
        child: PhysicalModel(
          color: color,
          elevation: (ref.watch(imageButtonController).isPress)? 10:10,
          shadowColor: Colors.grey.withOpacity((ref.watch(imageButtonController).isPress)? 0.7:0.4),
          borderRadius: borderRadius,
          clipBehavior: Clip.antiAlias,
          child: ClipRRect(
            child: Stack(
              children: [
                child,
                Positioned.fill(
                  child: IgnorePointer(
                    ignoring: true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white30.withOpacity((ref.watch(imageButtonController).isHover)?0.3:0),
                        borderRadius: borderRadius
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}