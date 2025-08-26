import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tex_v2/flutter_tex.dart';
import 'package:flutter_tex_v2/src/tex_server/tex_rendering_server_mobile.dart';
import 'package:flutter_tex_v2/src/tex_view/utils/core_utils.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart'
    show WebViewWidget;

/// A Webview based Widget to render Mathematics / Maths, Physics and Chemistry, Statistics / Stats Equations based on LaTeX with full HTML and JavaScript support.
class TeXViewState extends State<TeXView>
    with AutomaticKeepAliveClientMixin<TeXView> {
  final StreamController<double> heightStreamController = StreamController();
  late final TeXRenderingController teXRenderingController;

  bool _isReady = false;
  String _oldRawData = "";

  @override
  void initState() {
    if (TeXRenderingServer.multiTeXView) {
      teXRenderingController = TeXRenderingController();
      teXRenderingController.initController();
      teXRenderingController.onPageFinishedCallback =
          (pageFinishedCallbackMessage) {
        _onControllerReady();
      };
    } else {
      teXRenderingController = TeXRenderingServer.teXRenderingController;
      _onControllerReady();
    }

    super.initState();

    teXRenderingController.onTapCallback =
        (tapCallbackMessage) => widget.child.onTapCallback(tapCallbackMessage);

    teXRenderingController.onTeXViewRenderedCallback = (h) async {
      double height = double.parse(h.toString()) + widget.heightOffset;
      if (mounted) {
        heightStreamController.add(height);
        widget.onRenderFinished?.call(height);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _renderTeXView();
    return StreamBuilder<double>(
        stream: heightStreamController.stream,
        builder: (context, snap) {
          if (snap.hasData && !snap.hasError) {
            double height = snap.data ?? initialHeight;
            return SizedBox(
              height: height,
              child: WebViewWidget(
                controller: teXRenderingController.webViewControllerPlus,
              ),
            );
          } else {
            return widget.loadingWidgetBuilder?.call(context) ??
                const SizedBox.shrink();
          }
        });
  }

  @override
  void dispose() {
    if (mounted) {
      heightStreamController.close();
    }
    super.dispose();
  }

  void _onControllerReady() {
    _isReady = true;
    _renderTeXView();
  }

  void _renderTeXView() async {
    if (!_isReady) {
      return;
    }

    var currentRawData = getRawData(widget);

    if (currentRawData != _oldRawData) {
      await teXRenderingController.webViewControllerPlus
          .runJavaScript('initTeXViewMobile($currentRawData);');
      _oldRawData = currentRawData;
    }
  }

  @override
  bool get wantKeepAlive => widget.wantKeepAlive;
}
