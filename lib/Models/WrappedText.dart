import 'package:flutter/widgets.dart';

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
    final needAlternative=textPainter.size.width+5<constraints.maxWidth;
    return WrappedText._internal(
      (needAlternative)? data:alterData,
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