import 'dart:convert';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/models/widget_meta.dart';
import 'package:flutter_tex/src/utils/style_utils.dart';

class TeXViewGroupMultipleSelection extends TeXViewWidget {
  final List<TeXViewGroupItem> children;
  final Function(String id)? onTap;
  final Function(List<String> ids)? onItemsSelection;
  final TeXViewStyle? style;
  final TeXViewStyle? selectedItemStyle;
  final TeXViewStyle? normalItemStyle;
  final bool single;
  final String? selectedItemId;
  final List<String>? selectedItemIds;
  final String groupId;

  const TeXViewGroupMultipleSelection({
    required this.children,
    required this.onItemsSelection,
    required this.groupId,
    this.style,
    this.selectedItemStyle,
    this.normalItemStyle,
    this.selectedItemIds,
  })  : onTap = null,
        selectedItemId = null,
        single = false;

  @override
  TeXViewWidgetMeta meta() {
    return TeXViewWidgetMeta(
      tag: 'div',
      classList: 'tex-view-group-multiple',
      node: Node.internalChildren,
      id: 'texview-group-$groupId', // Ensure unique group container ID
    );
  }

  @override
  void onTapCallback(String data) {
    try {
      final Map<String, dynamic> callbackData = jsonDecode(data);
      if (callbackData['groupId'] == groupId) {
        final List<String> selectedIds =
            List<String>.from(callbackData['selectedIds']);
        onItemsSelection?.call(selectedIds);
      }
    } catch (e) {
      print('TeXView Group callback error: $e');
    }
  }

  @override
  Map toJson() => {
        'meta': meta().toJson(),
        'data': children.map((child) {
          final childJson = child.toJson();
          // Add group information to each child
          childJson['groupId'] = groupId;
          return childJson;
        }).toList(),
        'single': single,
        'groupId': groupId,
        'style': style?.initStyle() ?? teXViewDefaultStyle,
        'selectedItemStyle':
            selectedItemStyle?.initStyle() ?? teXViewDefaultStyle,
        'normalItemStyle': normalItemStyle?.initStyle() ?? teXViewDefaultStyle,
        'selectedItemIds': selectedItemIds ?? [],
      };
}
