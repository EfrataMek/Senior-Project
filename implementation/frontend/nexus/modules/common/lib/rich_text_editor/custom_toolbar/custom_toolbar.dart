import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import '../custom_embeddable/time_stamp_embed/time_stamp_in_toolbar.dart';
import 'custom_toolbar_elements/font_with_size.dart';

class CustomToolbar extends StatelessWidget {
  const CustomToolbar({
    super.key,
    required this.controller,
    required this.base,
  });

  final QuillController controller;
  final QuillToolbarBaseButtonOptions base;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        QuillToolbarHistoryButton(
          isUndo: true,
          controller: controller,
          baseOptions: base,
        ),
        QuillToolbarHistoryButton(
          isUndo: false,
          controller: controller,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          options: const QuillToolbarToggleStyleButtonOptions(),
          controller: controller,
          attribute: Attribute.bold,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          options: const QuillToolbarToggleStyleButtonOptions(),
          controller: controller,
          attribute: Attribute.italic,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.underline,
          baseOptions: base,
        ),
        QuillToolbarClearFormatButton(
          controller: controller,
          baseOptions: base,
        ),
        const VerticalDivider(),
        SizedBox(
          height: 30 * 1.4,
          child: QuillToolbarDivider(
            Axis.horizontal,
            color: Colors.grey,
            //space: 5,
          ),
        ),
        QuillToolbarImageButton(controller: controller, baseOptions: base),
        QuillToolbarCameraButton(controller: controller, baseOptions: base),
        QuillToolbarVideoButton(controller: controller, baseOptions: base),
        const VerticalDivider(),
        QuillToolbarColorButton(
          controller: controller,
          isBackground: false,
          baseOptions: base,
        ),
        QuillToolbarColorButton(
          controller: controller,
          isBackground: true,
          baseOptions: base,
        ),
        const VerticalDivider(),
        FontToolbar(controller: controller, base: base),
        const VerticalDivider(),
        QuillToolbarSelectHeaderStyleDropdownButton(
          controller: controller,
          options: QuillToolbarSelectHeaderStyleDropdownButtonOptions(
            attributes: [
              Attribute.h1,
              Attribute.h2,
              Attribute.h3,
              Attribute.h4,
              Attribute.h5,
              Attribute.h6,
              Attribute.header,
            ],
            /* afterButtonPressed: () {
              
              controller.formatSelection(
                Attribute.clone(Attribute.size, null),
              );
            }, */
          ),
          baseOptions: base,
        ),
        const VerticalDivider(),
        QuillToolbarSelectLineHeightStyleDropdownButton(
          controller: controller,
          baseOptions: base,
        ),
        const VerticalDivider(),
        QuillToolbarToggleCheckListButton(
          controller: controller,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.ol,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.ul,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.inlineCode,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.blockQuote,
          baseOptions: base,
        ),
        QuillToolbarIndentButton(
          controller: controller,
          isIncrease: true,
          baseOptions: base,
        ),
        QuillToolbarIndentButton(
          controller: controller,
          isIncrease: false,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.leftAlignment,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.centerAlignment,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.rightAlignment,
          baseOptions: base,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.justifyAlignment,
          baseOptions: base,
        ),
        const VerticalDivider(),
        QuillToolbarLinkStyleButton(controller: controller, baseOptions: base),
        const VerticalDivider(),
        timeStampToolBar(controller: controller, base: base),
      ],
    );
  }
}
