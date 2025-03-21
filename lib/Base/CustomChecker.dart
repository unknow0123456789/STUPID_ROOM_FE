import 'package:fe/Base/ChosenTextStyle.dart';
import 'package:fe/Base/ImageButton.dart';
import 'package:fe/Base/WrappedText.dart';
import 'package:fe/Models/CustomCheckerItem.dart';
import 'package:fe/Providers/customChecker_ChangeNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomChecker extends ConsumerWidget
{
  
  final ChangeNotifierProvider<CustomCheckerChangeNotifier> itemController;
  final String? title;

  CustomChecker({
    required this.itemController,
    this.title
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: (title!=null),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Text(
                  title??"",
                  style: customCheckerTitleTextStyle,
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(ref.watch(itemController).items.length, (index) =>
                  _customCheckerItemCard(
                      ref.watch(itemController).items[index],
                      () {
                        ref.read(itemController).checkAt(index);
                      }
                  )
              ),
            )
          ],
        ),
      ),
    );
  }

}

class _customCheckerItemCard extends ConsumerWidget
{

  final CustomCheckerItem item;
  final Function onTap;

  _customCheckerItemCard(this.item,this.onTap);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context,constraints)=>
      CustomButton(
        onTap: ()
        {
          onTap();
        },
        child: Container(
          height: 50,
          width: constraints.maxWidth,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                (item.isCheck)?Icons.radio_button_checked:Icons.radio_button_unchecked,
                size: 30,
                color: Colors.black,
              ),
              WrappedTextAutoScroll(
                item.value,
                style: customCheckerValueTextStyle,
              )
            ],
          ),
        ),
      ),
    );
  }

}