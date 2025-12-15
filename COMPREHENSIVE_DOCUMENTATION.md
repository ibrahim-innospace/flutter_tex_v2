# Flutter TeX - Comprehensive Technical Documentation

## Table of Contents
1. [Package Overview](#package-overview)
2. [Architecture](#architecture)
3. [Core Components](#core-components)
4. [Internal Working Mechanism](#internal-working-mechanism)
5. [File-by-File Analysis](#file-by-file-analysis)
6. [Communication Flow](#communication-flow)
7. [Platform-Specific Implementations](#platform-specific-implementations)
8. [Widget Hierarchy](#widget-hierarchy)
9. [Rendering Pipeline](#rendering-pipeline)
10. [Advanced Usage Patterns](#advanced-usage-patterns)

---

## Package Overview

**flutter_tex** is a Flutter package that renders mathematical, physical, and chemical equations using LaTeX, TeX, MathML, and AsciiMath formats. It leverages MathJax for rendering and provides a seamless integration with Flutter through WebView.

### Key Features
- **Multiple Input Formats**: LaTeX, TeX, MathML, AsciiMath
- **Full HTML/JavaScript Support**: Rich content beyond just equations
- **Cross-Platform**: Works on Android, iOS, macOS, and Web
- **Two Rendering Modes**:
  - `TeXView`: WebView-based rendering for complex layouts
  - `TeX2SVG` & `TeXWidget`: Pure Flutter widgets using SVG conversion

### Dependencies
```yaml
webview_flutter_plus: ^0.4.19  # Enhanced WebView functionality
flutter_svg: ^2.2.0            # SVG rendering
url_launcher: ^6.3.2           # External link handling
markdown: ^7.3.0               # Markdown to HTML conversion
web: ^1.1.1                    # Web platform APIs
```

---

## Architecture

The package follows a **layered architecture** with clear separation of concerns:

```
┌─────────────────────────────────────────────────┐
│          Flutter Application Layer              │
│  (TeXView, TeXWidget, TeX2SVG widgets)         │
└─────────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│         Abstraction Layer (Exports)             │
│       (flutter_tex.dart - main entry)           │
└─────────────────────────────────────────────────┘
                    ↓
┌──────────────────┬──────────────────┬───────────┐
│   TeXView Layer  │ TeXWidget Layer  │  Styling  │
│  (WebView-based) │   (SVG-based)    │   Layer   │
└──────────────────┴──────────────────┴───────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│         Platform Abstraction Layer              │
│  (Conditional imports for mobile/web)           │
└─────────────────────────────────────────────────┘
                    ↓
┌──────────────────┬──────────────────────────────┐
│   Mobile Layer   │        Web Layer             │
│  (localhost      │    (iframe + dart:html)      │
│   server +       │                              │
│   WebView)       │                              │
└──────────────────┴──────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────────┐
│         JavaScript/MathJax Layer                │
│   (flutter_tex.js + mathjax_core.js)           │
└─────────────────────────────────────────────────┘
```

---

## Core Components

### 1. **TeXView** (WebView-based Rendering)
The main widget for rendering complex TeX documents with full HTML/CSS/JavaScript support.

**Location**: `lib/src/tex_view/tex_view.dart`

**Key Responsibilities**:
- Manages a WebView instance
- Handles height calculations dynamically
- Supports custom fonts and styles
- Provides tap callbacks
- Manages loading states

**State Management**: Uses `StatefulWidget` with `AutomaticKeepAliveClientMixin`

### 2. **TeX2SVG** (Pure Flutter Rendering)
Converts TeX to SVG for lightweight, inline rendering without WebView overhead.

**Location**: `lib/src/tex_widget/tex2svg.dart`

**Key Features**:
- Direct TeX to SVG conversion
- FutureBuilder-based async rendering
- Customizable loading/error states
- No WebView dependency

### 3. **TeXWidget** (Hybrid Text + Math Widget)
Parses mixed text and math content, rendering text as Flutter widgets and math as SVG.

**Location**: `lib/src/tex_widget/tex_widget.dart`

**Parsing Logic**:
- Detects inline math: `\(...\)` or `$...$`
- Detects display math: `\[...\]` or `$$...$$`
- Renders text segments as TextSpan
- Renders math as TeX2SVG widgets

### 4. **TeXRenderingServer**
Backend server that manages MathJax rendering.

**Platforms**:
- **Mobile/Desktop**: `tex_rendering_server_mobile.dart` - Uses localhost server
- **Web**: `tex_rendering_server_web.dart` - Uses iframe communication

---

## Internal Working Mechanism

### Initialization Flow

```
┌────────────────────────────────────────────────────┐
│  1. Application Start                             │
│     main() {                                       │
│       await TeXRenderingServer.start();           │
│       runApp(...);                                 │
│     }                                              │
└────────────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────────────┐
│  2. Server Initialization                          │
│     Mobile: LocalhostServer.start()               │
│     - Starts HTTP server on random port           │
│     - Serves HTML/JS/CSS assets                    │
│     - Initializes WebView with MathJax            │
│                                                    │
│     Web: TeXRenderingControllerWeb.initialize()   │
│     - Sets up JS interop callbacks                │
│     - Prepares iframe communication               │
└────────────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────────────┐
│  3. Widget Creation                                │
│     TeXView(child: TeXViewDocument(...))          │
│     - Creates state object                        │
│     - Initializes rendering controller            │
│     - Sets up height stream                       │
└────────────────────────────────────────────────────┘
                    ↓
┌────────────────────────────────────────────────────┐
│  4. Rendering                                      │
│     - Converts widget tree to JSON                │
│     - Sends to JavaScript via runJavaScript()     │
│     - JavaScript builds DOM                        │
│     - MathJax processes equations                 │
│     - Returns height to Flutter                   │
│     - Updates UI with calculated height           │
└────────────────────────────────────────────────────┘
```

### Data Flow for TeXView

```
Flutter Dart Side                    JavaScript Side
─────────────────                    ───────────────

TeXViewDocument
    ↓
toJson() → {                         
  meta: {...},          ─────────→   createTeXView()
  data: "LaTeX...",                       ↓
  style: "..."                       DOM Element
}                                         ↓
                                     MathJax.typesetPromise()
                                          ↓
                      ←─────────     getTeXViewHeight()
heightStreamController                    ↓
    ↓                 ←─────────     OnTeXViewRenderedCallback
setState() → Update                       
WebView height
```

---

## File-by-File Analysis

### Main Entry Point

#### `lib/flutter_tex.dart`
**Purpose**: Single import point for the entire package

**Exports**:
- All widget classes (TeXView, TeXWidget, TeX2SVG)
- All style classes (TeXViewStyle, TeXViewPadding, etc.)
- All helper widgets (TeXViewDocument, TeXViewColumn, etc.)
- Utilities (TeXRenderingServer, TeXViewFont)

**Pattern**: Library file that re-exports from internal structure

---

### TeXView Component Files

#### `lib/src/tex_view/tex_view.dart`
**Purpose**: Platform-agnostic interface for TeXView

**Key Code**:
```dart
class TeXView extends StatefulWidget {
  final TeXViewWidget child;        // Widget tree to render
  final TeXViewStyle? style;         // CSS styling
  final double heightOffset;         // Height adjustment
  final Function(double)? onRenderFinished;  // Callback
}
```

**Conditional Import Pattern**:
```dart
import 'tex_view_mobile.dart'
    if (dart.library.html) 'tex_view_web.dart';
```
- Compiles to `tex_view_mobile.dart` for iOS/Android/macOS
- Compiles to `tex_view_web.dart` for web platform

#### `lib/src/tex_view/tex_view_mobile.dart`
**Purpose**: Mobile/Desktop implementation using WebView

**Key Components**:

1. **TeXViewState**:
```dart
class TeXViewState extends State<TeXView> {
  final StreamController<double> heightStreamController;
  late final TeXRenderingController teXRenderingController;
  bool _isReady = false;
  String _oldRawData = "";
```

2. **Initialization**:
```dart
void initState() {
  if (TeXRenderingServer.multiTeXView) {
    // Each TeXView gets its own controller
    teXRenderingController = TeXRenderingController();
  } else {
    // Reuse shared controller
    teXRenderingController = TeXRenderingServer.teXRenderingController;
  }
  
  teXRenderingController.onTeXViewRenderedCallback = (h) {
    double height = double.parse(h.toString()) + widget.heightOffset;
    heightStreamController.add(height);
  };
}
```

3. **Rendering**:
```dart
void _renderTeXView() async {
  var currentRawData = getRawData(widget);
  if (currentRawData != _oldRawData) {
    await teXRenderingController.webViewControllerPlus
        .runJavaScript('initTeXViewMobile($currentRawData);');
    _oldRawData = currentRawData;
  }
}
```

#### `lib/src/tex_view/tex_view_web.dart`
**Purpose**: Web implementation using iframes

**Key Differences from Mobile**:

1. **Uses HTML IFrame**:
```dart
final HTMLIFrameElement iframeElement = HTMLIFrameElement()
  ..src = "assets/packages/flutter_tex/core/flutter_tex.html"
  ..style.height = '100%'
  ..style.width = '100%';
```

2. **Platform View Registry**:
```dart
platformViewRegistry.registerViewFactory(
    _iframeId, (int id) => iframeElement..id = _iframeId);
```

3. **JS Interop Communication**:
```dart
void onTeXViewRendered(JSNumber h) {
  double height = double.parse(h.toString()) + widget.heightOffset;
  heightStreamController.add(height);
}
```

---

### TeXWidget Component Files

#### `lib/src/tex_widget/tex_widget.dart`
**Purpose**: Parse mixed text/math content and render as native Flutter widgets

**Algorithm**:
1. Parse input using regex to identify text/inline math/display math
2. Group consecutive inline math and text into RichText widgets
3. Render display math as separate centered widgets
4. Use TeX2SVG for all math rendering

**Code Flow**:
```dart
Widget build(BuildContext context) {
  final segments = parseTeX(math);  // Parse into segments
  return Column(
    children: _buildChildren(context, segments),
  );
}

List<Widget> _buildChildren(BuildContext context, List<TeXSegment> segments) {
  List<Widget> columnChildren = [];
  List<InlineSpan> currentRichTextSpans = [];
  
  for (final segment in segments) {
    switch (segment.type) {
      case TeXSegmentType.text:
        currentRichTextSpans.add(TextSpan(text: segment.text));
        break;
      case TeXSegmentType.inline:
        currentRichTextSpans.add(WidgetSpan(
          child: TeX2SVG(math: segment.text)));
        break;
      case TeXSegmentType.display:
        flushSpans();  // Add accumulated spans as RichText
        columnChildren.add(Center(child: TeX2SVG(...)));
        break;
    }
  }
  return columnChildren;
}
```

#### `lib/src/tex_widget/tex2svg.dart`
**Purpose**: Convert TeX to SVG without WebView

**Key Implementation**:
```dart
class _TeX2SVGState extends State<TeX2SVG> {
  late final Future<String> _texRenderingFuture;
  
  void initState() {
    _texRenderingFuture = TeXRenderingServer.teX2SVG(
      math: widget.math,
      teXInputType: widget.teXInputType,
    );
  }
  
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _texRenderingFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SvgPicture.string(snapshot.data);
        } else if (snapshot.hasError) {
          return errorWidget;
        }
        return loadingWidget;
      }
    );
  }
}
```

#### `lib/src/tex_widget/utils/parse_tex.dart`
**Purpose**: Parse TeX delimiters from mixed content

**Regex Pattern**:
```dart
final RegExp latexRegex = RegExp(
  "${TeXDelimiters.displayDollar.value}|"      // $$...$$
  "${TeXDelimiters.diplayBrackets.value}|"    // \[...\]
  "${TeXDelimiters.inlineDollar.value}|"      // $...$
  "${TeXDelimiters.inlineBrackets.value}"     // \(...\)
);
```

**Algorithm**:
1. Iterate through all regex matches
2. Extract text segments between matches
3. Determine segment type (display/inline) by which group matched
4. Return list of `TeXSegment` objects

---

### TeXRenderingServer Files

#### `lib/src/tex_server/tex_rendering_server.dart`
**Purpose**: Conditional export for platform-specific server

```dart
export 'tex_rendering_server_mobile.dart'
    if (dart.library.html) 'tex_rendering_server_web.dart'
    show TeXRenderingServer;
```

#### `lib/src/tex_server/tex_rendering_server_mobile.dart`
**Purpose**: Localhost HTTP server for serving assets and MathJax

**Components**:

1. **LocalhostServer** (from webview_flutter_plus):
```dart
static final LocalhostServer _server = LocalhostServer();

static Future<void> start({int port = 0}) async {
  await _server.start(port: port);  // Random available port
  await teXRenderingController.initController();
}
```

2. **TeXRenderingController**:
```dart
class TeXRenderingController {
  final WebViewControllerPlus webViewControllerPlus;
  final String baseUrl = "http://localhost:${port}/packages/flutter_tex/core/flutter_tex.html";
  
  Future<WebViewControllerPlus> initController() {
    webViewControllerPlus
      ..addJavaScriptChannel('OnTapCallback', ...)
      ..addJavaScriptChannel('OnTeXViewRenderedCallback', ...)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(baseUrl));
  }
}
```

3. **TeX to SVG Conversion**:
```dart
static Future<String> teX2SVG({required String math, required TeXInputType type}) {
  return teXRenderingController.webViewControllerPlus
      .runJavaScriptReturningResult(
          "mathJaxLiteDOM.teX2SVG(${jsonEncode(math)}, '${type.value}');"
      )
      .then((data) {
        // Platform-specific parsing (Android needs jsonDecode)
        if (Platform.isAndroid) {
          return jsonDecode(data.toString()).toString();
        }
        return data.toString();
      });
}
```

#### `lib/src/tex_server/tex_rendering_server_web.dart`
**Purpose**: Web platform server using JS interop

**Key Features**:

1. **JS Interop Declarations**:
```dart
@JS('initTeXViewWeb')
external void initTeXViewWeb(Window iframe, String id, String data);

@JS('mathJaxLiteDOM.teX2SVG')
external String mathJaxLiteDOMTeX2SVG(String math, String inputType);

@JS('OnTeXViewRenderedCallback')
external set onTeXViewRenderedCallback(JSFunction callback);
```

2. **Global Callback Management**:
```dart
class TeXRenderingControllerWeb {
  static final Map<String, TeXViewState> _instances = {};
  
  static void initialize() {
    onTeXViewRenderedCallback = _onTeXViewRendered.toJS;
    onTapCallback = _onTap.toJS;
  }
  
  static void _onTeXViewRendered(JSNumber h, JSString iframeId) {
    final instance = _instances[iframeId.toDart];
    instance?.onTeXViewRendered(h);
  }
}
```

---

### Widget Hierarchy Files

#### `lib/src/tex_view/widgets/widget.dart`
**Purpose**: Base abstract class for all TeXView widgets

```dart
abstract class TeXViewWidget {
  TeXViewWidgetMeta meta();           // HTML metadata
  void onTapCallback(String id) {}    // Tap handling
  Map<dynamic, dynamic> toJson();     // Serialization
}
```

#### `lib/src/tex_view/widgets/document.dart`
**Purpose**: Leaf widget containing raw HTML/TeX

```dart
class TeXViewDocument extends TeXViewWidget {
  final String data;    // Raw HTML + TeX content
  final TeXViewStyle? style;
  
  Map toJson() => {
    'meta': meta().toJson(),
    'data': data,
    'style': style?.initStyle() ?? teXViewDefaultStyle,
  };
}
```

#### `lib/src/tex_view/widgets/container.dart`
**Purpose**: Wrapper widget with styling

```dart
class TeXViewContainer implements TeXViewWidget {
  final TeXViewWidget child;
  final TeXViewStyle? style;
  
  TeXViewWidgetMeta meta() => TeXViewWidgetMeta(
    tag: 'div', 
    classList: 'tex-view-container', 
    node: Node.internalChild
  );
}
```

#### `lib/src/tex_view/widgets/column.dart`
**Purpose**: Vertical layout of multiple widgets

```dart
class TeXViewColumn implements TeXViewWidget {
  final List<TeXViewWidget> children;
  
  Map toJson() => {
    'meta': meta().toJson(),
    'data': children.map((child) => child.toJson()).toList(),
    'style': style?.initStyle() ?? teXViewDefaultStyle,
  };
}
```

#### `lib/src/tex_view/widgets/ink_well.dart`
**Purpose**: Clickable widget with tap callbacks

```dart
class TeXViewInkWell implements TeXViewWidget {
  final String id;                    // Unique identifier
  final TeXViewWidget child;
  final Function(String id)? onTap;   // Tap handler
  final bool? rippleEffect;           // Material ripple
  
  void onTapCallback(String id) {
    if (this.id == id) onTap!(id);
  }
}
```

**Tap Flow**:
1. User taps in WebView
2. JavaScript `clickManager()` detects click
3. Calls `OnTapCallback.postMessage(id)`
4. Dart receives via JavaScript channel
5. Calls `widget.child.onTapCallback(id)`
6. Recursively searches widget tree for matching ID
7. Executes registered `onTap` callback

#### `lib/src/tex_view/widgets/markdown.dart`
**Purpose**: Convert Markdown to HTML before rendering

```dart
class TeXViewMarkdown extends TeXViewWidget {
  final String markdown;
  
  Map toJson() => {
    'meta': meta().toJson(),
    'data': markdownToHtml(markdown, ...),  // Conversion
    'style': style?.initStyle() ?? teXViewDefaultStyle,
  };
}
```

#### `lib/src/tex_view/widgets/image.dart`
**Purpose**: Display images (asset or network)

```dart
class TeXViewImage extends TeXViewWidget {
  final String imageUri;
  final String _type;  // 'tex-view-asset-image' or 'tex-view-network-image'
  
  const TeXViewImage.asset(this.imageUri) : _type = 'tex-view-asset-image';
  const TeXViewImage.network(this.imageUri) : _type = 'tex-view-network-image';
}
```

#### `lib/src/tex_view/widgets/video.dart`
**Purpose**: Embed YouTube videos

```dart
class TeXViewVideo extends TeXViewWidget {
  final String url;
  
  String _getWidget() {
    return """<iframe width="100%" height="100%" 
      src="https://www.youtube.com/embed/${Uri.parse(url).queryParameters['v']}"
      allow="accelerometer; autoplay; encrypted-media; gyroscope">
      </iframe>""";
  }
}
```

---

### Styling System Files

#### `lib/src/tex_view/styles/style.dart`
**Purpose**: Main styling class that converts to CSS

**Two Construction Methods**:

1. **Declarative (Dart Objects)**:
```dart
TeXViewStyle(
  padding: TeXViewPadding.all(10),
  margin: TeXViewMargin.all(5),
  backgroundColor: Colors.blue,
  border: TeXViewBorder.all(
    TeXViewBorderDecoration(
      borderColor: Colors.red,
      borderWidth: 2,
    )
  ),
)
```

2. **Direct CSS**:
```dart
TeXViewStyle.fromCSS("color: red; font-size: 20px;")
```

**CSS Generation**:
```dart
String? initStyle() {
  return cascadingStyleSheets ??
    """${padding?.getPadding()}
       ${margin?.getMargin()}
       ${border?.getBorder()}
       height: ${getSizeWithUnit(height, sizeUnit)};
       background-color: ${getColor(backgroundColor)};
       ...""";
}
```

#### `lib/src/tex_view/styles/padding.dart`
**Purpose**: Generate CSS padding

```dart
class TeXViewPadding {
  final double? left, top, right, bottom;
  
  const TeXViewPadding.all(double padding) : 
    left = padding, top = padding, right = padding, bottom = padding;
  
  String getPadding() {
    return "padding: ${top}px ${right}px ${bottom}px ${left}px;";
  }
}
```

Similar files exist for:
- `margin.dart` - CSS margins
- `border.dart` - CSS borders with color/width/style
- `size_unit.dart` - px, em, rem, %, pt, etc.
- `text_align.dart` - left, center, right, justify
- `overflow.dart` - visible, hidden, scroll
- `font_style.dart` - Font family, size, weight

---

### JavaScript Files

#### `lib/core/flutter_tex.html`
**Purpose**: HTML template loaded in WebView/iframe

```html
<!DOCTYPE html>
<html>
<head>
    <!-- Load assets from Flutter app -->
    <script src="../../../assets/flutter_tex.js"></script>
    <link rel="stylesheet" href="../../../assets/flutter_tex.css">
    
    <!-- Load package core files -->
    <link rel="stylesheet" href="flutter_tex.css">
    <script src="flutter_tex.js"></script>
    <script src="mathjax_core.js" id="MathJax-script"></script>
</head>
<body>
    <div id="TeXView"></div>
    
    <script>
        function renderTeXView(onCompleteCallback) {
            MathJax.typesetPromise(["#TeXView"]).then(() => {
                onCompleteCallback();
            });
        }
    </script>
</body>
</html>
```

#### `lib/core/flutter_tex.js`
**Purpose**: Core JavaScript rendering logic

**Main Functions**:

1. **initTeXViewMobile** - Entry point for mobile platforms:
```javascript
function initTeXViewMobile(flutterTeXData) {
    var teXViewElement = document.getElementById('TeXView');
    teXViewElement.innerHTML = '';
    teXViewElement.appendChild(createTeXView(flutterTeXData));
    renderTeXView(() => renderCompleted(teXViewElement));
}
```

2. **initTeXViewWeb** - Entry point for web platform:
```javascript
function initTeXViewWeb(iframeContentWindow, iframeId, flutterTeXData) {
    var teXViewElement = iframeContentWindow.document.getElementById('TeXView');
    teXViewElement.innerHTML = '';
    teXViewElement.appendChild(
        createTeXView(JSON.parse(flutterTeXData), teXViewElement, iframeId, true)
    );
    iframeContentWindow.renderTeXView(() => renderCompleted(teXViewElement, iframeId, true));
}
```

3. **createTeXView** - Recursive DOM builder:
```javascript
function createTeXView(rootData, teXViewElement, iframeId, isWeb) {
    var meta = rootData['meta'];
    var data = rootData['data'];
    var element = document.createElement(meta['tag']);
    element.classList.add(meta['classList']);
    element.setAttribute('style', rootData['style']);
    element.setAttribute('id', meta['id']);
    
    switch (meta['node']) {
        case 'root':
            element.appendChild(createTeXView(data, ...));
            break;
        case 'leaf':
            if (meta['tag'] === 'img') {
                element.setAttribute('src', data);
            } else {
                element.innerHTML = data;
            }
            break;
        case 'internal_child':
            element.appendChild(createTeXView(data, ...));
            if (meta['classList'] === 'tex-view-ink-well') {
                clickManager(iframeId, element, meta['id'], ...);
            }
            break;
        default: // internal_children
            data.forEach(childViewData => {
                element.appendChild(createTeXView(childViewData, ...));
            });
    }
    return element;
}
```

4. **renderCompleted** - Height calculation loop:
```javascript
function renderCompleted(texViewElement, iframeId, isWeb) {
    let lastHeight;
    
    function execute() {
        const height = getTeXViewHeight(texViewElement);
        const rendered = lastHeight === height;
        lastHeight = height;
        
        if (isWeb) {
            OnTeXViewRenderedCallback(height, iframeId);
        } else {
            OnTeXViewRenderedCallback.postMessage(height);
        }
        
        if (!rendered) {
            setTimeout(() => execute(), 250);  // Retry until stable
        }
    }
    execute();
}
```

5. **clickManager** - Handle tap events:
```javascript
function clickManager(iframeId, element, id, rippleEffect, isWeb) {
    element.addEventListener('click', function (e) {
        if (isWeb) {
            OnTapCallback(id, iframeId);
        } else {
            OnTapCallback.postMessage(id);
        }
        
        if (rippleEffect) {
            // Create material ripple effect
            var ripple = document.createElement('div');
            this.appendChild(ripple);
            ripple.classList.add('ripple');
            // Position and animate ripple
        }
    });
}
```

6. **getTeXViewHeight** - Calculate total height including margins:
```javascript
function getTeXViewHeight(view) {
    var height = view.offsetHeight;
    var style = window.getComputedStyle(view);
    return ['top', 'bottom']
        .map(side => parseInt(style["margin-" + side]))
        .reduce((total, side) => total + side, height);
}
```

#### `lib/core/flutter_tex.css`
**Purpose**: Base styles for TeXView container

```css
* {
    margin: 0;
    padding: 0;
}

#TeXView {
    overflow: hidden;
    position: relative;
}

.tex-view-ink-well .ripple {
    border-radius: 50%;
    background-color: lightgrey;
    position: absolute;
    transform: scale(0);
    animation: ripple 0.5s linear;
}

@keyframes ripple {
    to {
        transform: scale(2.5);
        opacity: 0;
    }
}
```

#### `lib/core/mathjax_core.js`
**Purpose**: MathJax configuration and initialization

This file is empty in the current version, likely because MathJax is loaded from CDN or bundled separately. The package relies on MathJax's `mathJaxLiteDOM.teX2SVG()` API.

---

### Utility Files

#### `lib/src/tex_view/utils/core_utils.dart`
**Purpose**: Serialize widget tree to JSON

```dart
String getRawData(TeXView teXView) {
  return jsonEncode({
    'meta': TeXViewWidgetMeta(
      tag: 'div', 
      classList: 'tex-view', 
      node: Node.root
    ).toJson(),
    'fonts': (teXView.fonts ?? []).map((f) => f.toJson()).toList(),
    'data': teXView.child.toJson(),
    'style': teXView.style?.initStyle() ?? teXViewDefaultStyle
  });
}
```

#### `lib/src/tex_view/utils/widget_meta.dart`
**Purpose**: Metadata for HTML element generation

```dart
enum Node { root, internalChild, internalChildren, leaf }

class TeXViewWidgetMeta {
  final String? id;         // HTML id attribute
  final String? classList;  // CSS class
  final String? tag;        // HTML tag (div, img, iframe, etc.)
  final Node? node;         // Node type for rendering logic
  
  Map toJson() => {
    'id': id,
    'classList': classList,
    'tag': tag,
    'node': _getNodeValue(node),
  };
}
```

#### `lib/src/tex_view/utils/style_utils.dart`
**Purpose**: CSS conversion utilities

```dart
const String teXViewDefaultStyle = 'overflow-wrap: break-word;';

String getColor(Color? color) {
  if (color == null) return '';
  return 'rgba(${color.red}, ${color.green}, ${color.blue}, ${color.opacity})';
}

String getSizeWithUnit(int? size, TeXViewSizeUnit? unit) {
  if (size == null) return '';
  String unitStr = TeXViewSizeUnitHelper.getValue(unit) ?? 'px';
  return '$size$unitStr';
}

String getElevation(int? elevation, TeXViewSizeUnit? unit) {
  if (elevation == null) return '';
  String size = getSizeWithUnit(elevation, unit);
  return '0 ${size} ${size} 0 rgba(0, 0, 0, 0.3)';
}
```

---

## Communication Flow

### Mobile Platform Communication

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter Dart Side                    │
└─────────────────────────────────────────────────────────┘
                          ↓
        TeXView.child.toJson() → JSON serialization
                          ↓
        jsonEncode({meta, data, style, fonts})
                          ↓
   webViewControllerPlus.runJavaScript(
       'initTeXViewMobile(' + jsonData + ');'
   )
                          ↓
┌─────────────────────────────────────────────────────────┐
│                   JavaScript Side                       │
└─────────────────────────────────────────────────────────┘
                          ↓
        initTeXViewMobile(flutterTeXData)
                          ↓
        createTeXView() → Recursive DOM building
                          ↓
        MathJax.typesetPromise() → Process LaTeX
                          ↓
        getTeXViewHeight() → Calculate height
                          ↓
        OnTeXViewRenderedCallback.postMessage(height)
                          ↓
┌─────────────────────────────────────────────────────────┐
│                    Flutter Dart Side                    │
└─────────────────────────────────────────────────────────┘
                          ↓
   JavaScript Channel receives message
                          ↓
   onTeXViewRenderedCallback(height)
                          ↓
   heightStreamController.add(height)
                          ↓
   setState() → Update UI with new height
```

### Web Platform Communication

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter Dart Side                    │
└─────────────────────────────────────────────────────────┘
                          ↓
        getRawData(widget) → JSON serialization
                          ↓
        initTeXViewWeb(
            iframeContentWindow,
            iframeId,
            rawData
        ) // JS Interop direct call
                          ↓
┌─────────────────────────────────────────────────────────┐
│            JavaScript Side (in iframe)                  │
└─────────────────────────────────────────────────────────┘
                          ↓
        Parse JSON, build DOM
                          ↓
        MathJax rendering
                          ↓
        OnTeXViewRenderedCallback(height, iframeId)
                          ↓
┌─────────────────────────────────────────────────────────┐
│                    Flutter Dart Side                    │
└─────────────────────────────────────────────────────────┘
                          ↓
   Global callback handler
                          ↓
   TeXRenderingControllerWeb._onTeXViewRendered(h, id)
                          ↓
   _instances[id].onTeXViewRendered(h)
                          ↓
   heightStreamController.add(height)
                          ↓
   setState() → Update UI
```

### TeX2SVG Communication (Direct)

```
┌─────────────────────────────────────────────────────────┐
│                    Flutter Dart Side                    │
└─────────────────────────────────────────────────────────┘
                          ↓
        TeX2SVG widget created
                          ↓
        TeXRenderingServer.teX2SVG(math: "...", type: ...)
                          ↓
┌──────────────┬──────────────────────────────────────────┐
│   Mobile     │              Web                         │
└──────────────┴──────────────────────────────────────────┘
      ↓                           ↓
webViewControllerPlus        mathJaxLiteDOMTeX2SVG() // JS Interop
.runJavaScriptReturningResult(       ↓
  "mathJaxLiteDOM.teX2SVG(...)"   Returns SVG string immediately
)                                    ↓
      ↓                         ┌────┘
      ↓                         ↓
  Returns Future<String> (SVG data)
                ↓
┌─────────────────────────────────────────────────────────┐
│                    Flutter Dart Side                    │
└─────────────────────────────────────────────────────────┘
                ↓
   FutureBuilder receives SVG
                ↓
   SvgPicture.string(svg) → Render
```

---

## Platform-Specific Implementations

### Mobile/Desktop (iOS, Android, macOS)

**Key Technologies**:
- `webview_flutter_plus` package
- Localhost HTTP server
- JavaScript channels for communication

**Advantages**:
- Full MathJax functionality
- Consistent rendering across platforms
- Supports complex HTML/CSS/JS

**Limitations**:
- Requires HTTP server startup
- Higher memory footprint
- WebView overhead

**Initialization**:
```dart
main() async {
  await TeXRenderingServer.start();  // Starts localhost server
  runApp(MyApp());
}
```

### Web Platform

**Key Technologies**:
- `dart:html` / `web` package
- HTML iframes
- JS Interop (`package:js`)
- Platform view factory

**Advantages**:
- Native browser rendering
- No server needed
- Direct JS function calls

**Limitations**:
- More complex state management
- Global callback handling required
- iframe security considerations

**State Management**:
```dart
class TeXRenderingControllerWeb {
  static final Map<String, TeXViewState> _instances = {};
  
  // Register each iframe instance
  static void registerInstance(String id, TeXViewState state) {
    _instances[id] = state;
  }
  
  // Global callbacks route to specific instances
  static void _onTeXViewRendered(JSNumber h, JSString iframeId) {
    _instances[iframeId.toDart]?.onTeXViewRendered(h);
  }
}
```

---

## Widget Hierarchy

### TeXView Widget Tree Example

```dart
TeXView(
  child: TeXViewColumn(                    // Node: internalChildren
    children: [
      TeXViewContainer(                    // Node: internalChild
        child: TeXViewDocument(            // Node: leaf
          r"$$E = mc^2$$"
        ),
        style: TeXViewStyle(
          backgroundColor: Colors.blue,
        ),
      ),
      TeXViewInkWell(                      // Node: internalChild
        id: "button1",
        onTap: (id) => print("Tapped: $id"),
        child: TeXViewDocument(            // Node: leaf
          "<p>Click me!</p>"
        ),
      ),
      TeXViewImage.network(                // Node: leaf
        "https://example.com/image.png"
      ),
      TeXViewMarkdown(                     // Node: leaf
        "# Title\n\n$$x^2$$"
      ),
    ],
  ),
)
```

**JSON Output**:
```json
{
  "meta": {
    "tag": "div",
    "classList": "tex-view",
    "node": "root"
  },
  "data": {
    "meta": {
      "tag": "div",
      "classList": "tex-view-column",
      "node": "internal_children"
    },
    "data": [
      {
        "meta": {
          "tag": "div",
          "classList": "tex-view-container",
          "node": "internal_child"
        },
        "data": {
          "meta": {"tag": "div", "classList": "tex-view-document", "node": "leaf"},
          "data": "$$E = mc^2$$",
          "style": "..."
        },
        "style": "background-color: rgba(33, 150, 243, 1);"
      },
      {
        "meta": {
          "id": "button1",
          "tag": "div",
          "classList": "tex-view-ink-well",
          "node": "internal_child"
        },
        "data": {
          "meta": {"tag": "div", "classList": "tex-view-document", "node": "leaf"},
          "data": "<p>Click me!</p>",
          "style": "..."
        },
        "rippleEffect": true
      }
    ],
    "style": "..."
  },
  "style": "..."
}
```

**DOM Output**:
```html
<div id="TeXView" class="tex-view" style="...">
  <div class="tex-view-column" style="...">
    <div class="tex-view-container" style="background-color: rgba(33, 150, 243, 1);">
      <div class="tex-view-document">$$E = mc^2$$</div>
    </div>
    <div class="tex-view-ink-well" id="button1" style="...">
      <div class="tex-view-document"><p>Click me!</p></div>
    </div>
    <img class="tex-view-network-image" src="https://example.com/image.png" />
    <div class="tex-view-markdown"><h1>Title</h1><p>$$x^2$$</p></div>
  </div>
</div>
```

---

## Rendering Pipeline

### Complete Rendering Flow

```
┌──────────────────────────────────────────────────────────┐
│ Stage 1: Widget Construction                             │
└──────────────────────────────────────────────────────────┘
    User creates widget tree in Dart
                 ↓
┌──────────────────────────────────────────────────────────┐
│ Stage 2: Serialization                                   │
└──────────────────────────────────────────────────────────┘
    widget.toJson() called recursively
    Style objects converted to CSS strings
    Metadata extracted (tag, classList, node type)
                 ↓
┌──────────────────────────────────────────────────────────┐
│ Stage 3: JSON Encoding                                   │
└──────────────────────────────────────────────────────────┘
    getRawData() creates root JSON structure
    jsonEncode() serializes to string
                 ↓
┌──────────────────────────────────────────────────────────┐
│ Stage 4: Platform Bridge                                 │
└──────────────────────────────────────────────────────────┘
    Mobile: runJavaScript('initTeXViewMobile(...)')
    Web: initTeXViewWeb(iframe, id, data)
                 ↓
┌──────────────────────────────────────────────────────────┐
│ Stage 5: DOM Construction (JavaScript)                   │
└──────────────────────────────────────────────────────────┘
    createTeXView() recursively builds DOM
    - Creates HTML elements based on 'tag'
    - Applies CSS from 'style'
    - Adds classes from 'classList'
    - Handles special cases (images, inkwells)
                 ↓
┌──────────────────────────────────────────────────────────┐
│ Stage 6: MathJax Processing                              │
└──────────────────────────────────────────────────────────┘
    MathJax.typesetPromise(['#TeXView'])
    - Finds all TeX delimiters ($$, \[, etc.)
    - Converts to MathML/SVG
    - Renders equations
                 ↓
┌──────────────────────────────────────────────────────────┐
│ Stage 7: Height Calculation                              │
└──────────────────────────────────────────────────────────┘
    getTeXViewHeight() measures rendered content
    Polls every 250ms until height stabilizes
                 ↓
┌──────────────────────────────────────────────────────────┐
│ Stage 8: Callback to Flutter                             │
└──────────────────────────────────────────────────────────┘
    OnTeXViewRenderedCallback(height)
    JavaScript channel → Dart callback
                 ↓
┌──────────────────────────────────────────────────────────┐
│ Stage 9: UI Update                                       │
└──────────────────────────────────────────────────────────┘
    heightStreamController.add(height)
    StreamBuilder rebuilds with correct height
    WebView displayed with proper sizing
```

### Height Stabilization Algorithm

MathJax rendering is asynchronous and may take multiple layout passes. The height calculation uses a polling approach:

```javascript
function renderCompleted(texViewElement, iframeId, isWeb) {
    let lastHeight;
    
    function execute() {
        const height = getTeXViewHeight(texViewElement);
        const rendered = lastHeight === height;  // Check if stable
        lastHeight = height;
        
        // Always notify Flutter of current height
        if (isWeb) {
            OnTeXViewRenderedCallback(height, iframeId);
        } else {
            OnTeXViewRenderedCallback.postMessage(height);
        }
        
        // If not stable, retry in 250ms
        if (!rendered) {
            console.log('TeXView not fully rendered yet! Retrying in 250ms...');
            setTimeout(() => execute(texViewElement), 250);
        }
    }
    execute();
}
```

**Why Polling?**
- MathJax renders asynchronously
- Images may load after initial render
- Fonts may cause reflow
- Ensures accurate final height

---

## Advanced Usage Patterns

### Pattern 1: Custom Fonts

```dart
// Define custom font
final font = TeXViewFont(
  fontFamily: 'MyFont',
  src: 'url(assets/fonts/MyFont.ttf)',
);

// Use in TeXView
TeXView(
  fonts: [font],
  child: TeXViewDocument(
    r"<p style='font-family: MyFont;'>Custom font text</p>",
  ),
)
```

### Pattern 2: Interactive Quiz

```dart
TeXViewColumn(
  children: [
    TeXViewDocument(r"<h3>What is the solution?</h3>"),
    TeXViewDocument(r"$$ax^2 + bx + c = 0$$"),
    TeXViewInkWell(
      id: "option_a",
      onTap: (id) => checkAnswer(id),
      child: TeXViewDocument(r"<p>A: \(x = \frac{-b}{2a}\)</p>"),
    ),
    TeXViewInkWell(
      id: "option_b",
      onTap: (id) => checkAnswer(id),
      child: TeXViewDocument(
        r"<p>B: \(x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}\)</p>"
      ),
    ),
  ],
)
```

### Pattern 3: Mixed Media Content

```dart
TeXViewColumn(
  children: [
    TeXViewDocument(r"<h2>Physics Lecture</h2>"),
    TeXViewVideo.youtube("https://youtube.com/watch?v=..."),
    TeXViewDocument(r"$$E = mc^2$$"),
    TeXViewImage.network("https://example.com/diagram.png"),
    TeXViewMarkdown("""
      # Summary
      - Energy equals mass times speed of light squared
      - Derived by Einstein in 1905
    """),
  ],
)
```

### Pattern 4: Dynamic Content Updates

```dart
class DynamicTeXExample extends StatefulWidget {
  @override
  State<DynamicTeXExample> createState() => _DynamicTeXExampleState();
}

class _DynamicTeXExampleState extends State<DynamicTeXExample> {
  String _formula = r"$$x^2$$";
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TeXView(
          child: TeXViewDocument(_formula),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _formula = r"$$x^3$$";  // Updates automatically
            });
          },
          child: Text("Change Formula"),
        ),
      ],
    );
  }
}
```

**Note**: TeXView automatically detects changes via `_oldRawData` comparison and only re-renders when data changes.

### Pattern 5: Custom Rendering with TeX2SVG

```dart
TeX2SVG(
  math: r"E = mc^2",
  formulaWidgetBuilder: (context, svg) {
    return GestureDetector(
      onTap: () => print("Formula tapped!"),
      child: SvgPicture.string(
        svg,
        colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
        height: 50,
      ),
    );
  },
  errorWidgetBuilder: (context, error) {
    return Text("Failed to render: $error");
  },
  loadingWidgetBuilder: (context) {
    return CircularProgressIndicator();
  },
)
```

### Pattern 6: Multi-TeXView Mode

By default, all TeXViews share one WebView controller for performance. Enable independent controllers:

```dart
main() async {
  TeXRenderingServer.multiTeXView = true;
  await TeXRenderingServer.start();
  runApp(MyApp());
}
```

**When to use**:
- Multiple TeXViews with different configurations
- Need isolated rendering contexts
- Different MathJax configs per view

**Trade-off**: Higher memory usage, slower initialization

---

## Performance Considerations

### 1. WebView Initialization
**Problem**: WebView startup is slow on first load

**Solution**: Initialize server in `main()` before `runApp()`
```dart
main() async {
  await TeXRenderingServer.start();  // Pre-warm WebView
  runApp(MyApp());
}
```

### 2. Multiple TeXViews
**Problem**: Creating many TeXViews is memory-intensive

**Solutions**:
- Use `ListView.builder` with `wantKeepAlive: false`
- Reuse single TeXView controller (default behavior)
- Consider TeX2SVG for simple equations

### 3. Large Documents
**Problem**: Rendering large documents causes lag

**Solutions**:
- Split into multiple smaller TeXViewDocuments
- Use pagination
- Implement lazy loading with visibility detection

### 4. Height Calculation
**Problem**: Polling for height uses CPU

**Impact**: Minimal - only runs during rendering, stops when stable

**Optimization**: `heightOffset` parameter reduces unnecessary updates

### 5. TeX2SVG vs TeXView

| Feature | TeX2SVG | TeXView |
|---------|---------|---------|
| Performance | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Memory | ⭐⭐⭐⭐⭐ | ⭐⭐ |
| HTML Support | ❌ | ✅ |
| JavaScript | ❌ | ✅ |
| Styling | Limited | Full CSS |
| Use Case | Simple equations | Complex documents |

**Recommendation**:
- Use TeX2SVG/TeXWidget for inline math in text
- Use TeXView for rich documents with HTML/CSS

---

## Debugging and Troubleshooting

### Common Issues

#### 1. "Rendering server not started"
**Cause**: Forgot to call `TeXRenderingServer.start()`

**Solution**:
```dart
main() async {
  await TeXRenderingServer.start();
  runApp(MyApp());
}
```

#### 2. TeXView shows blank
**Causes**:
- Invalid LaTeX syntax
- Network image failed to load
- JavaScript error

**Debug**:
```dart
TeXView(
  loadingWidgetBuilder: (context) => 
    Text("Loading..."),  // Should disappear
  onRenderFinished: (height) => 
    print("Rendered with height: $height"),  // Should be called
)
```

Enable WebView console logging:
```dart
webViewControllerPlus.setOnConsoleMessage((message) {
  print("WebView: ${message.message}");
});
```

#### 3. Height calculation incorrect
**Causes**:
- `heightOffset` too small/large
- Custom CSS interfering
- Images not loaded

**Solutions**:
- Adjust `heightOffset: 10.0` (default: 5.0)
- Ensure images have load event listeners
- Wait for `onRenderFinished` callback

#### 4. Tap callbacks not working
**Causes**:
- ID mismatch
- Callback not propagated through widget tree

**Debug**:
```dart
TeXViewInkWell(
  id: "test",
  onTap: (id) {
    print("Tapped: $id");  // Should print "test"
  },
  child: ...,
)
```

Ensure parent widgets propagate callbacks:
```dart
@override
void onTapCallback(String id) {
  child.onTapCallback(id);  // Forward to children
}
```

---

## Security Considerations

### 1. WebView Security
**Risk**: Loading untrusted HTML/JavaScript

**Mitigations**:
- Server runs on localhost only
- No external URL loading (except via `url_launcher`)
- Sanitize user input before rendering

### 2. XSS Prevention
**Risk**: User-supplied LaTeX containing script tags

**Protection**:
```dart
// BAD - Vulnerable
TeXViewDocument(userInput)

// GOOD - Escaped
TeXViewDocument(
  HtmlEscape().convert(userInput)
)
```

### 3. Resource Loading
**Risk**: External images/videos from untrusted sources

**Best Practice**:
```dart
// Validate URLs before rendering
TeXViewImage.network(
  isValidImageUrl(url) ? url : fallbackImage
)
```

---

## Future Enhancement Ideas

Based on the codebase analysis, potential improvements:

1. **Server-Side Rendering**: Pre-render equations on backend
2. **Caching**: Cache rendered SVGs for repeated equations
3. **Progressive Enhancement**: Show raw TeX while rendering
4. **Accessibility**: Add ARIA labels, alt text for equations
5. **Dark Mode**: Auto-detect and adjust equation colors
6. **Responsive Math**: Auto-scale equations for screen size
7. **Copy Support**: Allow copying rendered equations as LaTeX
8. **Animation**: Animated equation transitions
9. **PDF Export**: Export rendered content as PDF

---

## Conclusion

**flutter_tex** is a sophisticated package that bridges Flutter and MathJax through multiple architectural layers:

1. **Widget Layer**: Flutter-friendly API (TeXView, TeX2SVG, TeXWidget)
2. **Serialization Layer**: Converts Dart objects to JSON
3. **Platform Layer**: Handles mobile (WebView) vs web (iframe) differences
4. **JavaScript Layer**: DOM construction and MathJax integration
5. **Communication Layer**: Bidirectional Dart ↔ JavaScript messaging

**Key Strengths**:
- Clean API with multiple usage patterns
- Robust platform abstraction
- Efficient rendering with height auto-calculation
- Rich feature set (tap callbacks, custom fonts, styling)

**Key Limitations**:
- WebView overhead for simple equations
- Requires async initialization
- Platform-specific quirks (Android JSON parsing, etc.)

This documentation provides a complete understanding of how flutter_tex works internally, enabling developers to effectively use, debug, and potentially contribute to the package.
