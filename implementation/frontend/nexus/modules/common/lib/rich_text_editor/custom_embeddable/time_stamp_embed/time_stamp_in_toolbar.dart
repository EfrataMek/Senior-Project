import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import 'time_stamp_in_editor.dart';

QuillToolbarCustomButton timeStampToolBar({required QuillController controller, required QuillToolbarBaseButtonOptions base}) {
  return QuillToolbarCustomButton(
    controller: controller,
    options: QuillToolbarCustomButtonOptions(
      icon: const Icon(Icons.add_alarm_rounded),
      onPressed: () {
        final offset = controller.selection.extentOffset;

        controller.document.insert(
          offset,
          TimeStampEmbed(DateTime.now().toString()),
        );

        controller.updateSelection(
          TextSelection.collapsed(offset: offset + 1),
          ChangeSource.local,
        );
      },
    ),
    baseOptions: base,
  );
}
