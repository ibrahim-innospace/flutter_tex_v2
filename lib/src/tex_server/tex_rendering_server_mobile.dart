import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tex_v2/flutter_tex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

/// A rendering server for TeXView. This is backed by a [LocalhostServer] and a [WebViewControllerPlus] for Andtoid, iOS and MacOS.
/// Make sure to call [start] before using the [TeXRenderingServer].
class TeXRenderingServer {
  static final LocalhostServer _server = LocalhostServer();
  static final TeXRenderingController teXRenderingController =
      TeXRenderingController();

  static bool multiTeXView = false;

  static int? get port => _server.port;

  static Future<void> start({int port = 0}) async {
    await _server.start(port: port);
    await teXRenderingController.initController();
  }

  static Future<String> teX2SVG(
      {required String math, required TeXInputType teXInputType}) {
    try {
      return teXRenderingController.webViewControllerPlus
          .runJavaScriptReturningResult(
              "mathJaxLiteDOM.teX2SVG(${jsonEncode(math)}, '${teXInputType.value}');")
          .then((data) {
        if (math.trim().isNotEmpty && data.toString().isEmpty) {
          return Future.error('TeX input cannot be empty');
        }

        if (Platform.isAndroid) {
          if (data == "null") {
            return Future.error('');
          }

          return jsonDecode(data.toString()).toString();
        } else {
          return data.toString();
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error in teX2SVG: $e');
      }
      return Future.error('Error rendering TeX: $e');
    }
  }

  static Future<void> stop() async {
    await _server.close();
  }
}

//// A controller for rendering TeX in a WebView. This controller manages the
/// communication between the WebView and the Dart code, handling events like
/// page finished loading, tap events, and TeX view rendered events.
class TeXRenderingController {
  final WebViewControllerPlus webViewControllerPlus = WebViewControllerPlus();
  final String baseUrl =
      "http://localhost:${TeXRenderingServer.port!}/packages/flutter_tex_v2/core/flutter_tex.html";

  RenderingControllerCallback? onPageFinishedCallback,
      onTapCallback,
      onTeXViewRenderedCallback;

  Future<WebViewControllerPlus> initController() {
    var controllerCompleter = Completer<WebViewControllerPlus>();

    webViewControllerPlus
      ..addJavaScriptChannel(
        'OnTapCallback',
        onMessageReceived: (onTapCallbackMessage) =>
            onTapCallback?.call(onTapCallbackMessage.message),
      )
      ..addJavaScriptChannel(
        'OnTeXViewRenderedCallback',
        onMessageReceived: (teXViewRenderedCallbackMessage) =>
            onTeXViewRenderedCallback
                ?.call(teXViewRenderedCallbackMessage.message),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _debugPrint("Page finished loading: $url");
            onPageFinishedCallback?.call(url);
            controllerCompleter.complete(webViewControllerPlus);
          },
          onNavigationRequest: (request) {
            if (request.url.contains(
              baseUrl,
            )) {
              return NavigationDecision.navigate;
            } else {
              _launchURL(request.url);
              return NavigationDecision.prevent;
            }
          },
        ),
      )
      ..setOnConsoleMessage(
        (message) {
          _debugPrint(message.message);
        },
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(
        baseUrl,
      ));

    if (!Platform.isMacOS) {
      webViewControllerPlus.setBackgroundColor(Colors.transparent);
    }

    return controllerCompleter.future;
  }

  static void _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  static void _debugPrint(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}

typedef RenderingControllerCallback = void Function(dynamic message);
