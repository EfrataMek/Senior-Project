import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

import 'custom_embeddable/time_stamp_embed/time_stamp_in_editor.dart';
import 'default_styles.dart';

class CustomQuillEditor extends StatelessWidget {
  final QuillController controller;
  final FocusNode focusNode;
  final ScrollController scrollController;

  const CustomQuillEditor({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: QuillEditor(
        focusNode: focusNode,
        scrollController: scrollController,
        controller: controller,
        config: QuillEditorConfig(
          placeholder: 'Start writing...',
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          customStyles: customStyle(context),
          embedBuilders: [
            ...FlutterQuillEmbeds.editorBuilders(
              imageEmbedConfig: QuillEditorImageEmbedConfig(
                imageProviderBuilder: (context, imageUrl) {
                  // https://pub.dev/packages/flutter_quill_extensions#-image-assets
                  if (imageUrl.startsWith('assets/')) {
                    return AssetImage(imageUrl);
                  }
                  return null;
                },
              ),
              /* videoEmbedConfig: QuillEditorVideoEmbedConfig(
                customVideoBuilder: (videoUrl, readOnly) {
                  // To load YouTube videos https://github.com/singerdmx/flutter-quill/releases/tag/v10.8.0
                  return null;
                },
              ), */
            ),
            TimeStampEmbedBuilder(),
          ],
          /* customStyleBuilder: (attribute) {
                        /* print(
                          'key ${attribute.key.toString()}, value ${attribute.value.toString()}',
                        ); */
                        if (attribute.key == 'font') {
                          /*  return GoogleFonts.getFont(
                            'Bebas Neue',
                            color: Colors.purple,
                          ); */
                          return TextStyle(
                            color: Colors.purple,
                            fontSize: 18,
                            fontFamily: "Inspiration",
                          );
                        }
                        return TextStyle();
                      }, */
        ),
      ),
    );
  }
}
