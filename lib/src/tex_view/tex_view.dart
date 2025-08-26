import 'package:flutter/widgets.dart';
import 'package:flutter_tex_v2/flutter_tex.dart';
import 'package:flutter_tex_v2/src/tex_view/tex_view_mobile.dart'
    if (dart.library.html) 'package:flutter_tex_v2/src/tex_view/tex_view_web.dart';

///A Webview based Widget to render Mathematics / Maths, Physics and Chemistry, Statistics / Stats Equations based on LaTeX with full HTML and JavaScript support.
class TeXView extends StatefulWidget {
  /// A list of [TeXViewWidget]s.
  final TeXViewWidget child;

  /// Style TeXView Widget with [TeXViewStyle].
  final TeXViewStyle? style;

  /// Register fonts.
  final List<TeXViewFont>? fonts;

  /// Height offset to be added to the rendered height.
  final double heightOffset;

  /// Show a loading widget before rendering completes.
  final Widget Function(BuildContext context)? loadingWidgetBuilder;

  /// Callback when TEX rendering finishes.
  final Function(double height)? onRenderFinished;

  /// Whether to keep the widget alive when it is not visible. Default is false.
  final bool wantKeepAlive;

  const TeXView({
    super.key,
    required this.child,
    @Deprecated('See docs to use custom fonts.') this.fonts,
    this.style,
    this.wantKeepAlive = false,
    this.heightOffset = 5.0,
    this.loadingWidgetBuilder,
    this.onRenderFinished,
  });

  @override
  TeXViewState createState() => TeXViewState();
}
