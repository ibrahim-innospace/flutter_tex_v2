// TeXViewGroupItem.dart
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/models/widget_meta.dart';
import 'package:flutter_tex/src/utils/style_utils.dart';

class TeXViewGroupItem implements TeXViewWidget {
  final String id;

  /// A [TeXViewWidget] as child.
  final TeXViewWidget child;

  /// Style when item is selected
  final TeXViewStyle? selectedStyle;

  /// Style when item is not selected
  final TeXViewStyle? normalStyle;

  /// Whether this item is currently selected
  final bool isSelected;

  /// Ripple effect on tap
  final bool? rippleEffect;

  /// Callback when this item is tapped
  final Function(String id)? onTap;

  const TeXViewGroupItem({
    required this.id,
    required this.child,
    this.selectedStyle,
    this.normalStyle,
    this.isSelected = false,
    this.rippleEffect,
    this.onTap,
  });

  @override
  TeXViewWidgetMeta meta() {
    return TeXViewWidgetMeta(
      id: id,
      tag: 'div',
      classList: 'tex-view-group-item',
      node: Node.internalChild,
    );
  }

  @override
  Map toJson() => {
        'meta': meta().toJson(),
        'data': child.toJson(),
        'rippleEffect': rippleEffect ?? true,
        'style': (isSelected ? selectedStyle : normalStyle)?.initStyle() ??
            teXViewDefaultStyle,
        'isSelected': isSelected,
      };

  @override
  void onTapCallback(String id) {
    // Handle the tap at item level
    if (onTap != null && id == this.id) {
      onTap!(id);
    }
    child.onTapCallback(id);
  }
}
