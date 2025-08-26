import 'package:flutter_tex_v2/flutter_tex.dart';
import 'package:flutter_tex_v2/src/tex_view/utils/widget_meta.dart';
import 'package:flutter_tex_v2/src/tex_view/utils/style_utils.dart';

class TeXViewImage extends TeXViewWidget {
  /// Uri for Image.
  final String imageUri;

  final String _type;

  const TeXViewImage.asset(this.imageUri) : _type = 'tex-view-asset-image';

  const TeXViewImage.network(this.imageUri) : _type = 'tex-view-network-image';

  @override
  TeXViewWidgetMeta meta() {
    return TeXViewWidgetMeta(tag: 'img', classList: _type, node: Node.leaf);
  }

  @override
  Map toJson() => {
        'meta': meta().toJson(),
        'data': imageUri,
        'style': "max-width: 100%; max-height: 100%; $teXViewDefaultStyle",
      };
}
