import 'dart:js_interop';

import 'package:flutter/foundation.dart';
import 'package:flutter_tex_v2/flutter_tex.dart';
import 'package:flutter_tex_v2/src/tex_view/tex_view_web.dart';
import 'package:web/web.dart';

class TeXRenderingServer {
  static bool multiTeXView = false;

  static Future<void> start({int port = 0}) async {
    TeXRenderingControllerWeb.initialize();
  }

  static Future<String> teX2SVG(
      {required String math, required TeXInputType teXInputType}) {
    try {
      return Future<String>.value(
          mathJaxLiteDOMTeX2SVG(math, teXInputType.value));
    } catch (e) {
      if (kDebugMode) {
        print('Error in teX2SVG: $e');
      }
      return Future.error('Error rendering TeX: $e');
    }
  }

  static Future<void> stop() async {
    TeXRenderingControllerWeb.dispose();
  }
}

@JS('OnTeXViewRenderedCallback')
external set onTeXViewRenderedCallback(JSFunction callback);

@JS('OnTapCallback')
external set onTapCallback(JSFunction callback);

@JS('initTeXViewWeb')
external void initTeXViewWeb(
    Window iframeContentWindow, String iframId, String flutterTeXData);

@JS('mathJaxLiteDOM.teX2SVG')
external String mathJaxLiteDOMTeX2SVG(String math, String inputType);

/// Manages the global callbacks and communication between JS and Dart.
class TeXRenderingControllerWeb {
  static bool _isInitialized = false;

  /// A map to hold references to the state of each TeXView instance.
  static final Map<String, TeXViewState> _instances = {};

  /// Registers an instance of TeXViewState to be managed.
  static void registerInstance(String viewId, TeXViewState instance) {
    _instances[viewId] = instance;
  }

  /// Unregisters an instance when it's disposed.
  static void unregisterInstance(String viewId) {
    _instances.remove(viewId);
  }

  static void initialize() {
    if (_isInitialized) return;

    onTeXViewRenderedCallback = _onTeXViewRendered.toJS;
    onTapCallback = _onTap.toJS;
    _isInitialized = true;
  }

  /// Disposes the global callbacks and resets the state.
  static void dispose() {
    onTeXViewRenderedCallback = (() {}).toJS;
    onTapCallback = (() {}).toJS;
    _isInitialized = false;
  }

  // Top-level or static callback handlers.
  static void _onTeXViewRendered(JSNumber h, JSString iframeId) {
    final instance = _instances[iframeId.toDart];
    if (instance != null && instance.mounted) {
      instance.onTeXViewRendered(h);
    }
  }

  static void _onTap(JSString tapId, JSString iframeId) {
    final instance = _instances[iframeId.toDart];
    if (instance != null && instance.mounted) {
      instance.onTap(tapId);
    }
  }
}
