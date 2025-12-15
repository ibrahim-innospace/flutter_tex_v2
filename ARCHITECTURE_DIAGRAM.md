# Flutter TeX - Architecture Diagrams

## Complete System Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              FLUTTER APPLICATION                             │
│                                                                              │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐         │
│  │    TeXView       │  │    TeXWidget     │  │     TeX2SVG      │         │
│  │  (Rich content)  │  │  (Mixed text)    │  │   (Pure math)    │         │
│  └────────┬─────────┘  └────────┬─────────┘  └────────┬─────────┘         │
│           │                     │                     │                     │
└───────────┼─────────────────────┼─────────────────────┼─────────────────────┘
            │                     │                     │
            ▼                     ▼                     ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          SERIALIZATION LAYER                                 │
│                                                                              │
│  ┌─────────────────────────────────────────────────────────────────┐       │
│  │  Widget Tree → JSON → String                                     │       │
│  │  {meta: {tag, classList, node}, data: ..., style: "CSS..."}     │       │
│  └─────────────────────────────────────────────────────────────────┘       │
└───────────────────────────────┬──────────────────────────────────────────────┘
                                │
                    ┌───────────┴───────────┐
                    ▼                       ▼
┌────────────────────────────────┐  ┌──────────────────────────────┐
│      MOBILE/DESKTOP PATH       │  │        WEB PATH              │
│  (iOS, Android, macOS)         │  │      (Browser)               │
│                                │  │                              │
│  ┌──────────────────────────┐ │  │  ┌────────────────────────┐ │
│  │  TeXRenderingServer      │ │  │  │ TeXRenderingServerWeb  │ │
│  │  (Mobile)                │ │  │  │                        │ │
│  │                          │ │  │  │  - JS Interop          │ │
│  │  - LocalhostServer       │ │  │  │  - Global callbacks    │ │
│  │  - WebViewControllerPlus │ │  │  │  - iframe registry     │ │
│  │  - JavaScript channels   │ │  │  └────────────────────────┘ │
│  └──────────────────────────┘ │  │                              │
│              │                 │  │              │               │
│              ▼                 │  │              ▼               │
│  ┌──────────────────────────┐ │  │  ┌────────────────────────┐ │
│  │  HTTP Server (localhost) │ │  │  │  HTML IFrameElement    │ │
│  │  http://127.0.0.1:XXXXX  │ │  │  │  Platform View         │ │
│  └──────────────────────────┘ │  │  └────────────────────────┘ │
│              │                 │  │              │               │
│              ▼                 │  │              ▼               │
│  ┌──────────────────────────┐ │  │  ┌────────────────────────┐ │
│  │  WebView Widget          │ │  │  │  HtmlElementView       │ │
│  └──────────────────────────┘ │  │  └────────────────────────┘ │
└────────────────┬───────────────┘  └──────────────┬───────────────┘
                 │                                  │
                 └──────────────┬───────────────────┘
                                ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                          WEBVIEW/IFRAME CONTENT                              │
│                        flutter_tex.html                                      │
│                                                                              │
│  ┌────────────────────────────────────────────────────────────────┐        │
│  │  <div id="TeXView"></div>                                      │        │
│  │                                                                 │        │
│  │  Loaded Assets:                                                │        │
│  │  - flutter_tex.js    (DOM builder)                            │        │
│  │  - flutter_tex.css   (Base styles)                            │        │
│  │  - mathjax_core.js   (MathJax library)                        │        │
│  └────────────────────────────────────────────────────────────────┘        │
│                                                                              │
│  JavaScript Functions:                                                       │
│  ┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐         │
│  │initTeXViewMobile │  │  createTeXView   │  │ renderCompleted  │         │
│  │initTeXViewWeb    │  │ (recursive DOM)  │  │ (height calc)    │         │
│  └──────────────────┘  └──────────────────┘  └──────────────────┘         │
└───────────────────────────────────┬──────────────────────────────────────────┘
                                    ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                            MATHJAX ENGINE                                    │
│                                                                              │
│  Input: LaTeX, TeX, MathML, AsciiMath                                       │
│  Output: Rendered equations (MathML/SVG in DOM)                             │
│                                                                              │
│  MathJax.typesetPromise(['#TeXView'])                                       │
│      ↓                                                                       │
│  Parse delimiters ($$, \[, \(, etc.)                                        │
│      ↓                                                                       │
│  Convert to MathML/SVG                                                      │
│      ↓                                                                       │
│  Insert into DOM                                                            │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    USER CREATES WIDGET TREE                     │
│                                                                  │
│  TeXView(                                                       │
│    child: TeXViewColumn(                                        │
│      children: [                                                │
│        TeXViewDocument(r"$$E=mc^2$$"),                         │
│        TeXViewInkWell(id: "btn", onTap: ..., child: ...),      │
│      ]                                                          │
│    )                                                            │
│  )                                                              │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      SERIALIZATION PHASE                         │
│                                                                  │
│  getRawData(widget)                                             │
│      ↓                                                           │
│  widget.child.toJson() (recursive)                              │
│      ↓                                                           │
│  {                                                               │
│    meta: {tag: 'div', classList: 'tex-view', node: 'root'},    │
│    data: {                                                       │
│      meta: {tag: 'div', classList: 'tex-view-column', ...},    │
│      data: [                                                     │
│        {meta: {...}, data: "$$E=mc^2$$", style: "..."},        │
│        {meta: {...}, data: {...}, rippleEffect: true},         │
│      ],                                                          │
│      style: "..."                                                │
│    },                                                            │
│    style: "..."                                                  │
│  }                                                               │
│      ↓                                                           │
│  jsonEncode() → JSON string                                     │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    PLATFORM BRIDGE PHASE                         │
│                                                                  │
│  Mobile:                                                         │
│  webViewControllerPlus.runJavaScript(                           │
│    'initTeXViewMobile(' + jsonString + ');'                    │
│  )                                                              │
│                                                                  │
│  Web:                                                           │
│  initTeXViewWeb(iframeWindow, iframeId, jsonString)            │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    DOM CONSTRUCTION PHASE                        │
│                      (JavaScript Side)                           │
│                                                                  │
│  initTeXView[Mobile|Web](data)                                  │
│      ↓                                                           │
│  Parse JSON                                                     │
│      ↓                                                           │
│  createTeXView(data) [RECURSIVE]                                │
│      ↓                                                           │
│  For each node:                                                 │
│    1. createElement(meta.tag)  // <div>, <img>, etc.           │
│    2. element.classList.add(meta.classList)                     │
│    3. element.setAttribute('style', style)                      │
│    4. Based on meta.node:                                       │
│       - 'leaf': element.innerHTML = data                        │
│       - 'internal_child': appendChild(createTeXView(data))      │
│       - 'internal_children': data.forEach(appendChild)          │
│    5. If inkwell: attach clickManager()                         │
│      ↓                                                           │
│  Return complete DOM tree                                       │
│      ↓                                                           │
│  document.getElementById('TeXView').appendChild(tree)           │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     MATHJAX RENDERING PHASE                      │
│                                                                  │
│  renderTeXView(onCompleteCallback)                              │
│      ↓                                                           │
│  MathJax.typesetPromise(['#TeXView'])                           │
│      ↓                                                           │
│  MathJax scans DOM for delimiters:                              │
│    - $$...$$ (display)                                          │
│    - \[...\] (display)                                          │
│    - $...$ (inline)                                             │
│    - \(...\) (inline)                                           │
│      ↓                                                           │
│  Convert each to SVG/MathML                                     │
│      ↓                                                           │
│  Replace in DOM                                                 │
│      ↓                                                           │
│  onCompleteCallback() → renderCompleted()                       │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                   HEIGHT CALCULATION PHASE                       │
│                                                                  │
│  renderCompleted(teXViewElement, iframeId, isWeb)               │
│      ↓                                                           │
│  LOOP:                                                          │
│    currentHeight = getTeXViewHeight(teXViewElement)             │
│    if (currentHeight === lastHeight):                           │
│      → STABLE, stop polling                                     │
│    else:                                                         │
│      lastHeight = currentHeight                                 │
│      setTimeout(loop, 250ms)  → RETRY                           │
│      ↓                                                           │
│  getTeXViewHeight():                                            │
│    height = element.offsetHeight                                │
│    height += marginTop + marginBottom                           │
│    return height                                                │
│      ↓                                                           │
│  Send to Flutter:                                               │
│    Mobile: OnTeXViewRenderedCallback.postMessage(height)        │
│    Web: OnTeXViewRenderedCallback(height, iframeId)            │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      FLUTTER UPDATE PHASE                        │
│                                                                  │
│  JavaScript Channel receives message                            │
│      ↓                                                           │
│  onTeXViewRenderedCallback(height)                              │
│      ↓                                                           │
│  heightStreamController.add(height)                             │
│      ↓                                                           │
│  StreamBuilder rebuilds:                                        │
│    return SizedBox(                                             │
│      height: height,  // Exact height from JS                  │
│      child: WebViewWidget(...)                                  │
│    )                                                            │
│      ↓                                                           │
│  setState() triggers rebuild                                    │
│      ↓                                                           │
│  UI updated with correct WebView height                         │
└─────────────────────────────────────────────────────────────────┘
```

## Tap Event Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                      USER TAPS INKWELL                          │
│                                                                  │
│  TeXViewInkWell(id: "answer_a", onTap: checkAnswer, ...)       │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     JAVASCRIPT CLICK EVENT                       │
│                                                                  │
│  clickManager(iframeId, element, id="answer_a", ...)            │
│      ↓                                                           │
│  element.addEventListener('click', function(e) {                │
│    // Send tap ID to Flutter                                    │
│    if (isWeb):                                                  │
│      OnTapCallback(id, iframeId)                                │
│    else:                                                         │
│      OnTapCallback.postMessage(id)                              │
│                                                                  │
│    // Show ripple effect                                        │
│    if (rippleEffect):                                           │
│      create ripple div                                          │
│      position at click coordinates                              │
│      animate scale(0) → scale(2.5)                             │
│  })                                                             │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FLUTTER RECEIVES TAP ID                       │
│                                                                  │
│  Mobile: JavaScript channel 'OnTapCallback'                     │
│  Web: Global callback TeXRenderingControllerWeb._onTap()        │
│      ↓                                                           │
│  teXRenderingController.onTapCallback(id="answer_a")            │
│      ↓                                                           │
│  widget.child.onTapCallback("answer_a")                         │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                  RECURSIVE WIDGET TREE SEARCH                    │
│                                                                  │
│  TeXViewColumn.onTapCallback("answer_a"):                       │
│    for child in children:                                       │
│      child.onTapCallback("answer_a")  → Forward to all         │
│                                                                  │
│  TeXViewContainer.onTapCallback("answer_a"):                    │
│    child.onTapCallback("answer_a")  → Forward to single child  │
│                                                                  │
│  TeXViewInkWell.onTapCallback("answer_a"):                      │
│    if (this.id == "answer_a"):  ✓ MATCH                        │
│      onTap!("answer_a")  → Execute registered callback          │
│    else:                                                         │
│      child.onTapCallback("answer_a")  → Keep searching         │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                     USER CALLBACK EXECUTED                       │
│                                                                  │
│  void checkAnswer(String id) {                                  │
│    if (id == "answer_a") {                                      │
│      showDialog(..., "Wrong answer!");                          │
│    }                                                             │
│  }                                                              │
└─────────────────────────────────────────────────────────────────┘
```

## TeX2SVG Flow (Simplified)

```
┌─────────────────────────────────────────────────────────────────┐
│                    TeX2SVG WIDGET CREATED                        │
│                                                                  │
│  TeX2SVG(math: r"E = mc^2")                                     │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                        INITSTATE                                 │
│                                                                  │
│  _texRenderingFuture = TeXRenderingServer.teX2SVG(              │
│    math: "E = mc^2",                                            │
│    teXInputType: TeXInputType.teX                               │
│  )                                                              │
└─────────────────────────────┬───────────────────────────────────┘
                              │
                ┌─────────────┴─────────────┐
                ▼                           ▼
┌──────────────────────────────┐  ┌──────────────────────────┐
│       MOBILE PATH            │  │       WEB PATH           │
└──────────────────────────────┘  └──────────────────────────┘
                │                           │
                ▼                           ▼
┌──────────────────────────────┐  ┌──────────────────────────┐
│ runJavaScriptReturningResult │  │  mathJaxLiteDOMTeX2SVG   │
│ ("mathJaxLiteDOM.teX2SVG     │  │  (math, 'teX')           │
│   ('E = mc^2', 'teX')")      │  │                          │
│         ↓                    │  │  Direct JS Interop call  │
│ JavaScript executes in       │  │         ↓                │
│ hidden WebView               │  │  Returns SVG immediately │
│         ↓                    │  │                          │
│ Returns SVG string via       │  │                          │
│ return value                 │  │                          │
│         ↓                    │  │         ↓                │
│ Platform-specific parsing:   │  │                          │
│ - Android: jsonDecode()      │  │                          │
│ - iOS: direct string         │  │                          │
└──────────────┬───────────────┘  └──────────┬───────────────┘
               │                             │
               └──────────┬──────────────────┘
                          ▼
┌─────────────────────────────────────────────────────────────────┐
│                    FUTUREBUILDER RECEIVES SVG                    │
│                                                                  │
│  FutureBuilder<String>(                                         │
│    future: _texRenderingFuture,                                 │
│    builder: (context, snapshot) {                               │
│      if (snapshot.hasData) {                                    │
│        String svg = snapshot.data!;                             │
│        return SvgPicture.string(svg, ...);                      │
│      }                                                           │
│    }                                                            │
│  )                                                              │
│      ↓                                                           │
│  Renders SVG as Flutter widget                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Class Relationship Diagram

```
┌──────────────────────────────────────────────────────────────────┐
│                     TeXViewWidget (abstract)                     │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  + meta(): TeXViewWidgetMeta                               │ │
│  │  + onTapCallback(String id): void                          │ │
│  │  + toJson(): Map                                           │ │
│  └────────────────────────────────────────────────────────────┘ │
└────────────────────────┬─────────────────────────────────────────┘
                         │
                         │ implements
         ┌───────────────┼───────────────┬─────────────────┐
         ▼               ▼               ▼                 ▼
┌─────────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│TeXViewDocument  │ │TeXViewColumn│ │TeXViewInkWell│ │TeXViewImage │
│                 │ │             │ │             │ │             │
│- data: String   │ │- children:  │ │- id: String │ │- imageUri   │
│- style          │ │  List<>     │ │- onTap      │ │- _type      │
│                 │ │- style      │ │- child      │ │             │
│node: leaf       │ │node:        │ │node:        │ │node: leaf   │
│                 │ │ internal_   │ │ internal_   │ │             │
│                 │ │ children    │ │ child       │ │             │
└─────────────────┘ └─────────────┘ └─────────────┘ └─────────────┘

         ▼               ▼               ▼                 ▼
┌─────────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│TeXViewContainer │ │TeXViewMarkdown│ │TeXViewVideo│ │TeXViewDetails│
│                 │ │             │ │             │ │             │
│- child: Widget  │ │- markdown   │ │- url        │ │- summary    │
│- style          │ │  (converts  │ │- _type      │ │- child      │
│                 │ │   to HTML)  │ │             │ │- isOpen     │
│node: internal_  │ │node: leaf   │ │node: leaf   │ │node:        │
│ child           │ │             │ │             │ │ internal_   │
│                 │ │             │ │             │ │ child       │
└─────────────────┘ └─────────────┘ └─────────────┘ └─────────────┘


┌──────────────────────────────────────────────────────────────────┐
│                         TeXViewStyle                             │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  - padding: TeXViewPadding?                                │ │
│  │  - margin: TeXViewMargin?                                  │ │
│  │  - border: TeXViewBorder?                                  │ │
│  │  - backgroundColor: Color?                                 │ │
│  │  - contentColor: Color?                                    │ │
│  │  + initStyle(): String  (converts to CSS)                 │ │
│  └────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
                         │
         ┌───────────────┼───────────────┬─────────────────┐
         ▼               ▼               ▼                 ▼
┌─────────────────┐ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐
│TeXViewPadding   │ │TeXViewMargin│ │TeXViewBorder│ │TeXViewFont  │
│                 │ │             │ │             │ │  Style      │
│- top, right,    │ │- top, right,│ │- all()      │ │- fontFamily │
│  bottom, left   │ │  bottom,    │ │- only()     │ │- fontSize   │
│                 │ │  left       │ │             │ │- fontWeight │
│+ getPadding():  │ │+ getMargin()│ │+ getBorder()│ │+ initFont   │
│  String (CSS)   │ │  String     │ │  String     │ │  Style()    │
└─────────────────┘ └─────────────┘ └─────────────┘ └─────────────┘
```

## Platform Abstraction

```
┌───────────────────────────────────────────────────────────────────┐
│                    Platform-Agnostic Code                         │
│                                                                    │
│  lib/src/tex_view/tex_view.dart                                   │
│  lib/src/tex_server/tex_rendering_server.dart                     │
│                                                                    │
│  Uses conditional imports:                                         │
│    import 'xxx_mobile.dart'                                        │
│      if (dart.library.html) 'xxx_web.dart';                        │
└────────────────────────┬──────────────────────────────────────────┘
                         │
                         │ Conditional compilation
         ┌───────────────┴───────────────┐
         ▼                               ▼
┌──────────────────────────┐   ┌──────────────────────────┐
│   MOBILE/DESKTOP BUILD   │   │       WEB BUILD          │
│                          │   │                          │
│  Includes:               │   │  Includes:               │
│  - tex_view_mobile.dart  │   │  - tex_view_web.dart     │
│  - tex_rendering_server_ │   │  - tex_rendering_server_ │
│    mobile.dart           │   │    web.dart              │
│                          │   │                          │
│  Uses:                   │   │  Uses:                   │
│  - webview_flutter_plus  │   │  - dart:html / web       │
│  - dart:io               │   │  - dart:js_interop       │
│  - LocalhostServer       │   │  - HTMLIFrameElement     │
│  - WebViewControllerPlus │   │  - platformViewRegistry  │
│  - JavaScript channels   │   │  - JS function calls     │
└──────────────────────────┘   └──────────────────────────┘
```

## File Organization

```
flutter_tex/
│
├── lib/
│   ├── flutter_tex.dart                     ← Main export file
│   │
│   ├── core/                                ← Assets loaded in WebView
│   │   ├── flutter_tex.html                ← HTML template
│   │   ├── flutter_tex.js                  ← DOM builder
│   │   ├── flutter_tex.css                 ← Base styles
│   │   └── mathjax_core.js                 ← MathJax (empty, loaded from CDN)
│   │
│   └── src/
│       │
│       ├── tex_view/                       ← TeXView component
│       │   ├── tex_view.dart               ← Platform-agnostic interface
│       │   ├── tex_view_mobile.dart        ← iOS/Android/macOS impl
│       │   ├── tex_view_web.dart           ← Web impl
│       │   │
│       │   ├── styles/                     ← Styling system
│       │   │   ├── style.dart              ← Main style class
│       │   │   ├── padding.dart
│       │   │   ├── margin.dart
│       │   │   ├── border.dart
│       │   │   ├── font_style.dart
│       │   │   ├── size_unit.dart
│       │   │   ├── text_align.dart
│       │   │   └── overflow.dart
│       │   │
│       │   ├── widgets/                    ← Widget hierarchy
│       │   │   ├── widget.dart             ← Base abstract class
│       │   │   ├── document.dart           ← Raw HTML/TeX
│       │   │   ├── container.dart          ← Wrapper with style
│       │   │   ├── column.dart             ← Vertical layout
│       │   │   ├── ink_well.dart           ← Clickable
│       │   │   ├── markdown.dart           ← Markdown support
│       │   │   ├── image.dart              ← Images
│       │   │   ├── video.dart              ← YouTube embed
│       │   │   └── details.dart            ← Expandable
│       │   │
│       │   └── utils/                      ← Helper functions
│       │       ├── core_utils.dart         ← JSON serialization
│       │       ├── widget_meta.dart        ← HTML metadata
│       │       ├── style_utils.dart        ← CSS conversion
│       │       └── font.dart               ← Custom fonts
│       │
│       ├── tex_widget/                     ← TeXWidget component
│       │   ├── tex_widget.dart             ← Mixed text/math parser
│       │   ├── tex2svg.dart                ← Pure SVG rendering
│       │   └── utils/
│       │       ├── parse_tex.dart          ← Delimiter parsing
│       │       └── enums.dart              ← Input types, delimiters
│       │
│       └── tex_server/                     ← Rendering server
│           ├── tex_rendering_server.dart   ← Platform export
│           ├── tex_rendering_server_mobile.dart  ← Localhost server
│           └── tex_rendering_server_web.dart     ← JS Interop
│
└── example/                                ← Demo app
    └── lib/
        ├── main.dart                       ← Entry point
        ├── tex_view_document_example.dart
        ├── tex_widget_example.dart
        ├── tex2svg_example.dart
        ├── tex_view_quiz_example.dart
        └── ...
```

This architecture provides:
- **Separation of Concerns**: Widget layer, serialization, platform abstraction, rendering
- **Platform Independence**: Conditional compilation for mobile vs web
- **Extensibility**: Easy to add new widget types or styling options
- **Testability**: Clear boundaries between components
- **Performance**: Shared WebView controller, efficient height calculation
