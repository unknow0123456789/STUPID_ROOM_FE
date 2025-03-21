import 'dart:core';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marquee/marquee.dart';

class WrappedText extends Text
{
  const WrappedText._internal(
      super.data,
      {
        super.style,
        super.key,
        super.locale,
        super.maxLines,
        super.overflow,
        super.selectionColor,
        super.semanticsLabel,
        super.softWrap,
        super.strutStyle,
        super.textAlign,
        super.textDirection,
        super.textHeightBehavior,
        super.textScaler,
        super.textWidthBasis
      });

  factory WrappedText(
      {
        required String data,
        required String alterData,
        required BoxConstraints constraints,
        TextStyle? style,
        Key? key,
        Locale? locale,
        int? maxLines,
        TextOverflow? overflow,
        Color? selectionColor,
        String? semanticsLabel,
        bool? softWrap,
        StrutStyle? strutStyle,
        TextAlign? textAlign,
        TextDirection? textDirection,
        TextHeightBehavior? textHeightBehavior,
        TextScaler? textScaler,
        TextWidthBasis? textWidthBasis
      }
      )
  {
    final textPainter=TextPainter(
      text: TextSpan(
        text: data,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: constraints.maxWidth);
    final needAlternative=textPainter.size.width+5>constraints.maxWidth;
    return WrappedText._internal(
      (needAlternative)? alterData:data,
      key: key,
      style: style,
      textAlign: textAlign,
      locale: locale,
      maxLines: maxLines,
      overflow: overflow,
      selectionColor: selectionColor,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      strutStyle: strutStyle,
      textDirection: textDirection,
      textHeightBehavior: textHeightBehavior,
      textScaler: textScaler,
      textWidthBasis: textWidthBasis,
    );
  }
}


class WrappedTextAutoScroll extends ConsumerWidget
{
  String data;
  TextStyle? style;
  Key? key;
  Locale? locale;
  int? maxLines;
  TextOverflow? overflow;
  Color? selectionColor;
  String? semanticsLabel;
  bool? softWrap;
  StrutStyle? strutStyle;
  TextAlign? textAlign;
  TextDirection? textDirection;
  TextHeightBehavior? textHeightBehavior;
  TextScaler? textScaler;
  TextWidthBasis? textWidthBasis;


  WrappedTextAutoScroll(
      this.data,
      {this.style,
      this.key,
      this.locale,
      this.maxLines,
      this.overflow,
      this.selectionColor,
      this.semanticsLabel,
      this.softWrap,
      this.strutStyle,
      this.textAlign,
      this.textDirection,
      this.textHeightBehavior,
      this.textScaler,
      this.textWidthBasis}
      );

  bool needScrolling(constraints)
  {
    final textPainter=TextPainter(
      text: TextSpan(
        text: data,
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: constraints.maxWidth);
    // print("${textPainter.size.width+5>constraints.maxWidth} / textPainter: ${textPainter.size.width+5} / constraints: ${constraints.maxWidth}");
    return textPainter.size.width+5>constraints.maxWidth;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
        builder: (context,constraints) =>
        needScrolling(constraints)?
        Marquee(
          text:data,
          style: style,
          scrollAxis: Axis.horizontal,
          blankSpace: 20,
          pauseAfterRound: Duration(seconds: 1),
          key: key,
        ):
            Text(
              data,
              key: key,
              softWrap: softWrap,
              style: style,
              textWidthBasis: textWidthBasis,
              textScaler: textScaler,
              textHeightBehavior: textHeightBehavior,
              textDirection: textDirection,
              strutStyle: strutStyle,
              semanticsLabel: semanticsLabel,
              selectionColor: selectionColor,
              overflow: overflow,
              maxLines: maxLines,
              locale: locale,
              textAlign: textAlign,
            )
    );
  }
}