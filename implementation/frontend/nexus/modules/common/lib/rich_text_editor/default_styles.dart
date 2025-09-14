import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

DefaultStyles customStyle(BuildContext context) {
  final defaultStyle = DefaultStyles.getInstance(context);

  return DefaultStyles(
    paragraph: DefaultTextBlockStyle(
      defaultStyle.paragraph!.style.copyWith(
        fontFamily: 'times_new_roman',
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      defaultStyle.paragraph!.horizontalSpacing,
      defaultStyle.paragraph!.verticalSpacing,
      defaultStyle.paragraph!.lineSpacing,
      defaultStyle.paragraph!.decoration,
    ),

    h1: DefaultTextBlockStyle(
      defaultStyle.h1!.style.copyWith(
        //fontFamily: 'Inspiration',
        fontSize: 44,
        color: Theme.of(context).textTheme.bodyLarge?.color,
        fontWeight: FontWeight.normal,
      ),
      defaultStyle.h1!.horizontalSpacing,
      defaultStyle.h1!.verticalSpacing,
      defaultStyle.h1!.lineSpacing,
      defaultStyle.h1!.decoration,
    ),
  );
}
