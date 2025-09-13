//import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class FontToolbar extends StatefulWidget {
  final quill.QuillController controller;
  const FontToolbar({required this.controller, super.key});

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

  /*  final List<String> fontFamilies = [
    "Arial",
    "Times New Roman",
    "Courier New",
    "Verdana",
    "Georgia",
    "Tahoma",
  ]; */

  String? currentFontFamily;

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
    } else {
      _sizeController.text = '16';
    }

    // update font family
    /*  final currentFamily = widget.controller
        .getSelectionStyle()
        .attributes['font']
        ?.value
        .toString();
    if (currentFamily != null && currentFamily != currentFontFamily) {
      setState(() => currentFontFamily = currentFamily);
    } */
  }

  void _applyFontSize(String value) {
    final size = double.tryParse(value);
    if (size != null) {
      widget.controller.formatSelection(
        quill.Attribute.fromKeyValue('size', value),
      );
    }
  }

  /*  void _applyFontFamily(String family) {
    widget.controller.formatSelection(
      quill.Attribute.fromKeyValue('font', family),
    );
    setState(() => currentFontFamily = family);
  } */

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
        border: Border(bottom: BorderSide(color: Colors.black54, width: 1.0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          quill.QuillToolbarFontFamilyButton(
            controller: widget.controller,
            options: quill.QuillToolbarFontFamilyButtonOptions(
              items: {
                /* 'Sans Serif': 'sans-serif',
                  'Serif': 'serif',
                  'Monospace': 'monospace',
                  'Ibarra Real Nova': 'ibarra-real-nova',
                  'SquarePeg': 'square-peg',
                  'Nunito': 'nunito',
                  'Pacifico': 'pacifico',
                  'Roboto Mono': 'roboto-mono', */
                'Times New Roman': 'times_new_roman',
                'Inspiration': 'Inspiration',
                'Libertinus Keyboard': 'Libertinus_Keyboard',
                'clear': 'Clear',
              },
              initialValue: 'Times New Roman',
         
            ),
          ),

          /* DropdownButtonHideUnderline(
            child: DropdownButton2<String>(
              value: currentFontFamily,
              hint: const Text("Font"),
              items: fontFamilies.map((family) {
                return DropdownMenuItem(
                  value: family,
                  child: Text(family, style: TextStyle(fontFamily: family)),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) _applyFontFamily(value);
              },
              buttonStyleData: ButtonStyleData(
                overlayColor: WidgetStatePropertyAll(Colors.transparent),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(Icons.arrow_forward_ios_outlined),
                iconSize: 14,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                offset: const Offset(0, -3),
                scrollbarTheme: ScrollbarThemeData(
                  radius: const Radius.circular(40),
                  thickness: WidgetStateProperty.all<double>(6),
                  thumbVisibility: WidgetStateProperty.all<bool>(true),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 40,
                padding: EdgeInsets.only(left: 14, right: 14),
              ),
            ),
          ), */
          VerticalDivider(color: Colors.black54),
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
