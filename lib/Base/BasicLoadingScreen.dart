import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BasicLoadingWidget extends ConsumerWidget
{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        color: Colors.white,
        child: Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            )
        )
    );
  }

}