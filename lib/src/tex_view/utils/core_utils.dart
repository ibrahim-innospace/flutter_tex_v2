import 'dart:convert';

import 'package:flutter_tex_v2/src/tex_view/utils/widget_meta.dart';
import 'package:flutter_tex_v2/src/tex_view/utils/style_utils.dart';
import 'package:flutter_tex_v2/src/tex_view/tex_view.dart';

const double initialHeight = 0.1;

String getRawData(TeXView teXView) {
  return jsonEncode({
    'meta': const TeXViewWidgetMeta(
            tag: 'div', classList: 'tex-view', node: Node.root)
        .toJson(),
    'fonts': (teXView.fonts ?? []).map((font) => font.toJson()).toList(),
    'data': teXView.child.toJson(),
    'style': teXView.style?.initStyle() ?? teXViewDefaultStyle
  });
}
