import 'dart:convert';
import 'dart:io' as io show Directory, File;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:path/path.dart' as path;

import 'custom_toolbar/custom_toolbar.dart';
import 'quill_editor.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuillController _controller = () {
    return QuillController.basic(
      config: QuillControllerConfig(
        clipboardConfig: QuillClipboardConfig(
          enableExternalRichPaste: true,
          onImagePaste: (imageBytes) async {
            if (kIsWeb) {
              // Dart IO is unsupported on the web.
              return null;
            }
            // Save the image somewhere and return the image URL that will be
            // stored in the Quill Delta JSON (the document).
            final newFileName =
                'image-file-${DateTime.now().toIso8601String()}.png';
            final newPath = path.join(
              io.Directory.systemTemp.path,
              newFileName,
            );
            final file = await io.File(
              newPath,
            ).writeAsBytes(imageBytes, flush: true);
            return file.path;
          },
        ),
      ),
    );
  }();
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Load document
    //_controller.document = Document.fromJson(kQuillDefaultSample);
    _controller.document = Document.fromJson([
      {"insert": "dsgdgs"},
      {"insert": "\n"},
      {"insert": "fgdfgf fg fdgf "},
      {
        "insert": "fdfg",
        "attributes": {"size": "72"},
      },
      {"insert": " "},
      {"insert": "\n\n"},
    ]);
  }

  @override
  Widget build(BuildContext context) {
    //final defaultStyle = DefaultStyles.getInstance(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Quill Example',
          style: TextStyle(
            color: Colors.purple,
            fontSize: 18,
            fontFamily: "Libertinus_Keyboard",
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.output),
            tooltip: 'Print Delta JSON to log',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'The JSON Delta has been printed to the console.',
                  ),
                ),
              );
              debugPrint(jsonEncode(_controller.document.toDelta().toJson()));
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            //border: Border.all(width: 10, color: Colors.red),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomToolbar(
                controller: _controller,
                base: QuillToolbarBaseButtonOptions(
                  afterButtonPressed: () {
                    final isDesktop = {
                      TargetPlatform.linux,
                      TargetPlatform.windows,
                      TargetPlatform.macOS,
                    }.contains(defaultTargetPlatform);
                    if (isDesktop) {
                      _editorFocusNode.requestFocus();
                    }
                  },
                ),
              ),
              /* QuillSimpleToolbar(
                controller: _controller,
                config: QuillSimpleToolbarConfig(
                  showClipboardPaste: true,
                    linkStyle: QuillToolbarLinkStyleButtonOptions(
                      validateLink: (link) {
                        // Treats all links as valid. When launching the URL,
                        // `https://` is prefixed if the link is incomplete (e.g., `google.com` → `https://google.com`)
                        // however this happens only within the editor.
                        return true;
                      },
                    ),
                  ),
                ),
              ) */
              Expanded(
                child: CustomQuillEditor(
                  controller: _controller,
                  focusNode: _editorFocusNode,
                  scrollController: _editorScrollController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _editorScrollController.dispose();
    _editorFocusNode.dispose();
    super.dispose();
  }
}
