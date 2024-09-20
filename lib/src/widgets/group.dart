import 'dart:convert';

import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/models/widget_meta.dart';
import 'package:flutter_tex/src/utils/style_utils.dart';

class TeXViewGroup extends TeXViewWidget {
  final List<TeXViewGroupItem> children;
  final Function(String id)? onTap;
  final Function(List<String> ids)? onItemsSelection;
  final TeXViewStyle? style;
  final TeXViewStyle? selectedItemStyle;
  final TeXViewStyle? normalItemStyle;
  final bool single;

  // Add a new field to store the currently selected item
  final String? selectedItemId;

  const TeXViewGroup({
    required this.children,
    required this.onTap,
    this.style,
    this.selectedItemStyle,
    this.normalItemStyle,
    this.selectedItemId, // Add this parameter
  })  : onItemsSelection = null,
        single = true;

  const TeXViewGroup.multipleSelection({
    required this.children,
    required this.onItemsSelection,
    this.style,
    this.selectedItemStyle,
    this.normalItemStyle,
    this.selectedItemId, // Add this parameter
  })  : onTap = null,
        single = false;

  @override
  TeXViewWidgetMeta meta() {
    return const TeXViewWidgetMeta(
        tag: 'div', classList: 'tex-view-group', node: Node.internalChildren);
  }

  @override
  void onTapCallback(String id) {
    if (single) {
      for (TeXViewGroupItem child in children) {
        if (child.id == id) onTap!(id);
      }
    } else {
      onItemsSelection!((jsonDecode(id) as List<dynamic>).cast<String>());
    }
  }

  @override
  Map toJson() => {
        'meta': meta().toJson(),
        'data': children.map((child) => child.toJson()).toList(),
        'single': single,
        'style': style?.initStyle() ?? teXViewDefaultStyle,
        'selectedItemStyle':
            selectedItemStyle?.initStyle() ?? teXViewDefaultStyle,
        'normalItemStyle': normalItemStyle?.initStyle() ?? teXViewDefaultStyle,
        'selectedItemId': selectedItemId, // Add this line
      };
}
