import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'font_with_size.dart';
import 'quill.dart';

class CustomToolbar extends StatelessWidget {
  const CustomToolbar({super.key, required this.controller});

  final QuillController controller;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        QuillToolbarHistoryButton(isUndo: true, controller: controller),
        QuillToolbarHistoryButton(isUndo: false, controller: controller),
        QuillToolbarToggleStyleButton(
          options: const QuillToolbarToggleStyleButtonOptions(),
          controller: controller,
          attribute: Attribute.bold,
        ),
        QuillToolbarToggleStyleButton(
          options: const QuillToolbarToggleStyleButtonOptions(),
          controller: controller,
          attribute: Attribute.italic,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.underline,
        ),
        QuillToolbarClearFormatButton(controller: controller),
        const VerticalDivider(),
        QuillToolbarImageButton(controller: controller),
        QuillToolbarCameraButton(controller: controller),
        QuillToolbarVideoButton(controller: controller),
        const VerticalDivider(),
        QuillToolbarColorButton(controller: controller, isBackground: false),
        QuillToolbarColorButton(controller: controller, isBackground: true),
        const VerticalDivider(),
        FontToolbar(controller: controller),
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
          ),
        ),
        const VerticalDivider(),
        QuillToolbarSelectLineHeightStyleDropdownButton(controller: controller),
        const VerticalDivider(),
        QuillToolbarToggleCheckListButton(controller: controller),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.ol,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.ul,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.inlineCode,
        ),
        QuillToolbarToggleStyleButton(
          controller: controller,
          attribute: Attribute.blockQuote,
        ),
        QuillToolbarIndentButton(controller: controller, isIncrease: true),
        QuillToolbarIndentButton(controller: controller, isIncrease: false),
        IconButton(
          tooltip: 'Align left',
          icon: const Icon(Icons.format_align_left),
          onPressed: () => controller.formatSelection(Attribute.leftAlignment),
        ),
        IconButton(
          tooltip: 'Align center',
          icon: const Icon(Icons.format_align_center),
          onPressed: () =>
              controller.formatSelection(Attribute.centerAlignment),
        ),
        IconButton(
          tooltip: 'Align right',
          icon: const Icon(Icons.format_align_right),
          onPressed: () => controller.formatSelection(Attribute.rightAlignment),
        ),
        IconButton(
          tooltip: 'Justify',
          icon: const Icon(Icons.format_align_justify),
          onPressed: () =>
              controller.formatSelection(Attribute.justifyAlignment),
        ),

        const VerticalDivider(),
        QuillToolbarLinkStyleButton(controller: controller),
        const VerticalDivider(),
        QuillToolbarCustomButton(
          controller: controller,
          options: QuillToolbarCustomButtonOptions(
            icon: const Icon(Icons.add_alarm_rounded),
            onPressed: () {
              controller.document.insert(
                controller.selection.extentOffset,
                TimeStampEmbed(DateTime.now().toString()),
              );

              controller.updateSelection(
                TextSelection.collapsed(
                  offset: controller.selection.extentOffset + 1,
                ),
                ChangeSource.local,
              );
            },
          ),
        ),
      ],
    );
  }
}
