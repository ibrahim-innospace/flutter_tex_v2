// TeXViewGroup.dart
import 'dart:convert';

import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/models/widget_meta.dart';
import 'package:flutter_tex/src/utils/style_utils.dart';

class TeXViewGroup extends TeXViewWidget {
  /// A list of [TeXViewGroupItem].
  final List<TeXViewGroupItem> children;

  /// Style for the group container
  final TeXViewStyle? style;

  /// Whether this is single or multiple selection
  final bool single;

  /// Currently selected item IDs
  final List<String> selectedIds;

  const TeXViewGroup({
    required this.children,
    this.style,
    this.single = true,
    this.selectedIds = const [],
  });

  const TeXViewGroup.multipleSelection({
    required this.children,
    this.style,
    this.selectedIds = const [],
  }) : single = false;

  @override
  TeXViewWidgetMeta meta() {
    return const TeXViewWidgetMeta(
      tag: 'div',
      classList: 'tex-view-group',
      node: Node.internalChildren,
    );
  }

  @override
  void onTapCallback(String id) {
    // Delegate to individual items
    for (TeXViewGroupItem child in children) {
      child.onTapCallback(id);
    }
  }

  @override
  Map toJson() => {
        'meta': meta().toJson(),
        'data': children.map((child) {
          // Update child's selected state based on selectedIds
          final isSelected = selectedIds.contains(child.id);
          return {
            ...child.toJson(),
            'isSelected': isSelected,
          };
        }).toList(),
        'single': single,
        'style': style?.initStyle() ?? teXViewDefaultStyle,
        'selectedIds': selectedIds,
      };
}
