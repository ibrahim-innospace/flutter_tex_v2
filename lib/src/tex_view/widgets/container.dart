import 'package:flutter_tex_v2/flutter_tex.dart';
import 'package:flutter_tex_v2/src/tex_view/utils/widget_meta.dart';
import 'package:flutter_tex_v2/src/tex_view/utils/style_utils.dart';

class TeXViewContainer implements TeXViewWidget {
  /// A [TeXViewWidget] as child.
  final TeXViewWidget child;

  /// Style TeXView Widget with [TeXViewStyle].
  final TeXViewStyle? style;

  const TeXViewContainer({required this.child, this.style});

  @override
  TeXViewWidgetMeta meta() {
    return const TeXViewWidgetMeta(
        tag: 'div', classList: 'tex-view-container', node: Node.internalChild);
  }

  @override
  void onTapCallback(String id) {
    child.onTapCallback(id);
  }

  @override
  Map toJson() => {
        'meta': meta().toJson(),
        'data': child.toJson(),
        'style': style?.initStyle() ?? teXViewDefaultStyle,
      };
}
