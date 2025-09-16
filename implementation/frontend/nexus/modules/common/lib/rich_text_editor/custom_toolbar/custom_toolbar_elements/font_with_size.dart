import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'list_of_fonts.dart';

class FontToolbar extends StatefulWidget {
  final QuillController controller;
  final QuillToolbarBaseButtonOptions base;

  const FontToolbar({super.key, required this.controller, required this.base});

  @override
  State<FontToolbar> createState() => _FontToolbarState();
}

class _FontToolbarState extends State<FontToolbar> {
  final TextEditingController _sizeController = TextEditingController();

  final List<int> fontSizes = [
    8,
    9,
    10,
    11,
    12,
    14,
    16,
    18,
    20,
    22,
    24,
    26,
    28,
    36,
    48,
    72,
  ];

  @override
  void initState() {
    widget.controller.addListener(_updateSelection);
    _updateSelection();
    super.initState();
  }

  void _updateSelection() {
    // update font size
    final currentSize =
        widget.controller
            .getSelectionStyle()
            .attributes['size']
            ?.value
            .toString() ??
        '';
    if (currentSize != '' && _sizeController.text != currentSize) {
      _sizeController.text = currentSize;
    } else if (currentSize == '') {
      _sizeController.text = '16';
    }
  }

  void _applyFontSize(String value) {
    final size = double.tryParse(value);
    if (size != null) {
      widget.controller.formatSelection(Attribute.fromKeyValue('size', value));
    }
    widget.base.afterButtonPressed!();
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateSelection);
    _sizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 33,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey, width: 1.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          QuillToolbarFontFamilyButton(
            controller: widget.controller,
            options: QuillToolbarFontFamilyButtonOptions(
              items: listOfFonts,
              initialValue: 'Times New Roman',
            ),
            baseOptions: widget.base,
          ),

          VerticalDivider(color: Colors.grey),
          SizedBox(
            width: 80,
            child: Row(
              children: [
                // Editable box
                Expanded(
                  child: TextFormField(
                    controller: _sizeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter
                          .digitsOnly, //Prevents letters and special characters
                    ],
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 0,
                      ),
                      border: InputBorder.none,
                    ),
                    onFieldSubmitted: _applyFontSize,
                  ),
                ),
                // Dropdown
                PopupMenuButton<int>(
                  icon: const Icon(Icons.arrow_forward_ios_outlined, size: 14),
                  position: PopupMenuPosition.under,
                  offset: Offset(-20, 15),
                  constraints: BoxConstraints(maxHeight: 300),
                  elevation: 10,
                  color: Theme.of(context).colorScheme.surface,
                  onSelected: (value) {
                    _applyFontSize(value.toString());
                    _sizeController.text = value.toString();
                  },
                  itemBuilder: (context) {
                    return fontSizes.map((size) {
                      return PopupMenuItem<int>(
                        height: 30,
                        value: size,
                        child: Text(size.toString()),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
