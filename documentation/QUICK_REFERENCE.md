# Flutter TeX - Quick Reference Guide

## Table of Contents
- [Installation](#installation)
- [Basic Setup](#basic-setup)
- [TeXView Examples](#texview-examples)
- [TeXWidget Examples](#texwidget-examples)
- [TeX2SVG Examples](#tex2svg-examples)
- [Common Patterns](#common-patterns)
- [API Reference](#api-reference)
- [Troubleshooting](#troubleshooting)

---

## Installation

```yaml
dependencies:
  flutter_tex: ^5.1.10
```

```bash
flutter pub get
```

### Platform Setup

#### Android
Add to `AndroidManifest.xml`:
```xml
<application
    android:usesCleartextTraffic="true">
```

#### iOS
Add to `Info.plist`:
```xml
<key>io.flutter.embedded_views_preview</key>
<true/>
```

#### Web
No additional setup required.

#### macOS
Update `macos/Runner/DebugProfile.entitlements`:
```xml
<key>com.apple.security.network.client</key>
<true/>
```

---

## Basic Setup

```dart
import 'package:flutter_tex/flutter_tex.dart';

void main() async {
  // Required: Start rendering server before runApp
  await TeXRenderingServer.start();
  runApp(MyApp());
}
```

---

## TeXView Examples

### Simple Equation

```dart
TeXView(
  child: TeXViewDocument(
    r"When $a \ne 0$, the solution is $$x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}$$"
  ),
)
```

### With Styling

```dart
TeXView(
  child: TeXViewDocument(r"$$E = mc^2$$"),
  style: TeXViewStyle(
    padding: TeXViewPadding.all(16),
    backgroundColor: Colors.blue,
    contentColor: Colors.white,
    border: TeXViewBorder.all(
      TeXViewBorderDecoration(
        borderColor: Colors.black,
        borderWidth: 2,
      ),
    ),
    borderRadius: TeXViewBorderRadius.all(10),
  ),
)
```

### Multiple Sections (Column)

```dart
TeXView(
  child: TeXViewColumn(
    children: [
      TeXViewDocument(r"<h2>Introduction</h2>"),
      TeXViewDocument(r"$$\sum_{i=1}^{n} i = \frac{n(n+1)}{2}$$"),
      TeXViewDocument(r"<p>This is the sum formula.</p>"),
    ],
  ),
)
```

### Interactive (InkWell)

```dart
TeXView(
  child: TeXViewColumn(
    children: [
      TeXViewDocument(r"<h3>Quiz: What is 2 + 2?</h3>"),
      TeXViewInkWell(
        id: "option_3",
        onTap: (id) => print("Wrong!"),
        child: TeXViewDocument(r"<p>A) 3</p>"),
      ),
      TeXViewInkWell(
        id: "option_4",
        onTap: (id) => print("Correct!"),
        child: TeXViewDocument(r"<p>B) 4</p>"),
        rippleEffect: true,
      ),
    ],
  ),
)
```

### With Images

```dart
TeXView(
  child: TeXViewColumn(
    children: [
      TeXViewDocument(r"<h2>Diagram</h2>"),
      TeXViewImage.network("https://example.com/image.png"),
      TeXViewImage.asset("assets/diagram.png"),
      TeXViewDocument(r"$$F = ma$$"),
    ],
  ),
)
```

### With Markdown

```dart
TeXView(
  child: TeXViewMarkdown(r"""
# Title
This is **bold** and this is *italic*.

Math works too: $E = mc^2$

And display math:
$$\int_{0}^{\infty} e^{-x^2} dx = \frac{\sqrt{\pi}}{2}$$
  """),
)
```

### With Video (YouTube)

```dart
TeXView(
  child: TeXViewColumn(
    children: [
      TeXViewDocument(r"<h2>Video Tutorial</h2>"),
      TeXViewVideo.youtube("https://www.youtube.com/watch?v=dQw4w9WgXcQ"),
      TeXViewDocument(r"<p>Watch the video above.</p>"),
    ],
  ),
)
```

### Loading State

```dart
TeXView(
  child: TeXViewDocument(r"$$x^2$$"),
  loadingWidgetBuilder: (context) => Center(
    child: CircularProgressIndicator(),
  ),
  onRenderFinished: (height) {
    print("Rendered with height: $height");
  },
)
```

### Keep Alive (ListView)

```dart
ListView.builder(
  itemCount: equations.length,
  itemBuilder: (context, index) {
    return TeXView(
      child: TeXViewDocument(equations[index]),
      wantKeepAlive: true,  // Prevents re-rendering on scroll
    );
  },
)
```

---

## TeXWidget Examples

### Basic Usage

```dart
TeXWidget(
  math: r"The formula is $E = mc^2$ and display: $$x^2 + y^2 = z^2$$"
)
```

### Custom Builders

```dart
TeXWidget(
  math: r"Text with $inline$ and $$display$$ math",
  
  // Custom inline math rendering
  inlineFormulaWidgetBuilder: (context, formula) {
    return TeX2SVG(
      math: formula,
      formulaWidgetBuilder: (context, svg) {
        return SvgPicture.string(
          svg,
          colorFilter: ColorFilter.mode(Colors.red, BlendMode.srcIn),
          height: 18,
        );
      },
    );
  },
  
  // Custom display math rendering
  displayFormulaWidgetBuilder: (context, formula) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: TeX2SVG(math: formula),
      ),
    );
  },
  
  // Custom text rendering
  textWidgetBuilder: (context, text) {
    return TextSpan(
      text: text,
      style: TextStyle(fontSize: 16, color: Colors.black87),
    );
  },
)
```

---

## TeX2SVG Examples

### Simple

```dart
TeX2SVG(math: r"E = mc^2")
```

### In Text (RichText)

```dart
RichText(
  text: TextSpan(
    style: TextStyle(fontSize: 16, color: Colors.black),
    children: [
      TextSpan(text: "Einstein's famous equation "),
      WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: TeX2SVG(math: r"E = mc^2"),
      ),
      TextSpan(text: " relates energy and mass."),
    ],
  ),
)
```

### Custom SVG Rendering

```dart
TeX2SVG(
  math: r"\int_{0}^{\infty} e^{-x} dx = 1",
  formulaWidgetBuilder: (context, svg) {
    return SvgPicture.string(
      svg,
      height: 40,
      width: 200,
      fit: BoxFit.contain,
      colorFilter: ColorFilter.mode(Colors.purple, BlendMode.srcIn),
    );
  },
)
```

### With Error Handling

```dart
TeX2SVG(
  math: r"\invalid{syntax}",
  loadingWidgetBuilder: (context) => Text("Loading..."),
  errorWidgetBuilder: (context, error) => Text(
    "Error: $error",
    style: TextStyle(color: Colors.red),
  ),
)
```

### Different Input Types

```dart
// TeX (default)
TeX2SVG(
  math: r"x^2 + y^2 = z^2",
  teXInputType: TeXInputType.teX,
)

// MathML
TeX2SVG(
  math: r"""
<math>
  <mrow>
    <msup><mi>x</mi><mn>2</mn></msup>
    <mo>+</mo>
    <msup><mi>y</mi><mn>2</mn></msup>
  </mrow>
</math>
  """,
  teXInputType: TeXInputType.mathML,
)

// AsciiMath
TeX2SVG(
  math: r"sum_(i=1)^n i^3=((n(n+1))/2)^2",
  teXInputType: TeXInputType.asciiMath,
)
```

---

## Common Patterns

### Pattern 1: Quiz/Question App

```dart
class QuizQuestion extends StatefulWidget {
  @override
  _QuizQuestionState createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  String? selectedAnswer;
  
  void checkAnswer(String id) {
    setState(() {
      selectedAnswer = id;
    });
    
    if (id == "correct") {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Correct!"),
          content: Text("Well done!"),
        ),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return TeXView(
      child: TeXViewColumn(
        children: [
          TeXViewDocument(r"<h3>What is the derivative of $x^2$?</h3>"),
          
          TeXViewInkWell(
            id: "wrong1",
            onTap: checkAnswer,
            child: TeXViewDocument(r"<p>A) $x$</p>"),
            style: TeXViewStyle(
              backgroundColor: selectedAnswer == "wrong1" 
                ? Colors.red.shade100 
                : Colors.transparent,
            ),
          ),
          
          TeXViewInkWell(
            id: "correct",
            onTap: checkAnswer,
            child: TeXViewDocument(r"<p>B) $2x$</p>"),
            style: TeXViewStyle(
              backgroundColor: selectedAnswer == "correct" 
                ? Colors.green.shade100 
                : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
```

### Pattern 2: Dynamic Math Editor

```dart
class MathEditor extends StatefulWidget {
  @override
  _MathEditorState createState() => _MathEditorState();
}

class _MathEditorState extends State<MathEditor> {
  String latex = r"x^2";
  final controller = TextEditingController(text: r"x^2");
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(labelText: "Enter LaTeX"),
          onChanged: (value) {
            setState(() {
              latex = value;
            });
          },
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(border: Border.all()),
          child: TeX2SVG(math: latex),
        ),
      ],
    );
  }
}
```

### Pattern 3: Article/Document Viewer

```dart
class Article extends StatelessWidget {
  final String content = r"""
<h1>Introduction to Calculus</h1>
<p>Calculus is the study of change...</p>

<h2>The Derivative</h2>
<p>The derivative of a function $f(x)$ is defined as:</p>
$$f'(x) = \lim_{h \to 0} \frac{f(x+h) - f(x)}{h}$$

<h2>The Integral</h2>
<p>The integral is the reverse of the derivative:</p>
$$\int f(x) dx = F(x) + C$$

<p>where $F'(x) = f(x)$.</p>
  """;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Article")),
      body: SingleChildScrollView(
        child: TeXView(
          child: TeXViewDocument(content),
          style: TeXViewStyle(
            padding: TeXViewPadding.all(16),
          ),
        ),
      ),
    );
  }
}
```

### Pattern 4: Chemistry Equations

```dart
TeXView(
  child: TeXViewColumn(
    children: [
      TeXViewDocument(r"<h2>Chemical Reactions</h2>"),
      
      // Use \ce{} for chemistry
      TeXViewDocument(r"$$\ce{CO2 + C -> 2 CO}$$"),
      
      TeXViewDocument(r"$$\ce{H2O <=> H+ + OH-}$$"),
      
      TeXViewDocument(r"""
        $$\ce{Zn^2+  <=>[+ 2OH-][+ 2H+]  $\underset{\text{amphoteric hydroxide}}{\ce{Zn(OH)2 v}}$  <=>[+ 2OH-][+ 2H+]  $\underset{\text{tetrahydroxozincate}}{\ce{[Zn(OH)4]^2-}}$}$$
      """),
    ],
  ),
)
```

### Pattern 5: Mixed Content Card

```dart
class EquationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: TeXView(
        child: TeXViewContainer(
          child: TeXViewColumn(
            children: [
              TeXViewDocument(r"<h3>Pythagorean Theorem</h3>"),
              TeXViewImage.asset("assets/triangle.png"),
              TeXViewDocument(r"$$a^2 + b^2 = c^2$$"),
              TeXViewMarkdown(r"""
For a right triangle:
- $a$, $b$ are the legs
- $c$ is the hypotenuse
              """),
              TeXViewInkWell(
                id: "learn_more",
                onTap: (id) => print("Navigate to details"),
                child: TeXViewDocument(
                  r"<p style='color: blue;'>Learn More →</p>"
                ),
              ),
            ],
          ),
          style: TeXViewStyle(
            padding: TeXViewPadding.all(16),
          ),
        ),
      ),
    );
  }
}
```

---

## API Reference

### TeXView

```dart
TeXView({
  Key? key,
  required TeXViewWidget child,           // Widget tree to render
  TeXViewStyle? style,                     // CSS styling
  List<TeXViewFont>? fonts,                // Custom fonts (deprecated)
  double heightOffset = 5.0,               // Height adjustment
  bool wantKeepAlive = false,              // Keep alive in lists
  Widget Function(BuildContext)? loadingWidgetBuilder,  // Loading state
  Function(double height)? onRenderFinished,  // Render callback
})
```

### TeXWidget

```dart
TeXWidget({
  Key? key,
  required String math,                    // Mixed text/math content
  Widget Function(BuildContext, String)? inlineFormulaWidgetBuilder,
  Widget Function(BuildContext, String)? displayFormulaWidgetBuilder,
  InlineSpan Function(BuildContext, String)? textWidgetBuilder,
})
```

### TeX2SVG

```dart
TeX2SVG({
  Key? key,
  required String math,                    // LaTeX/TeX string
  TeXInputType teXInputType = TeXInputType.teX,  // Input format
  bool wantKeepAlive = false,
  WidgetBuilder? loadingWidgetBuilder,
  Widget Function(BuildContext, String svg)? formulaWidgetBuilder,
  Widget Function(BuildContext, Object? error)? errorWidgetBuilder,
})
```

### TeXViewStyle

```dart
TeXViewStyle({
  TeXViewPadding? padding,
  TeXViewMargin? margin,
  TeXViewSizeUnit? sizeUnit,               // px, em, rem, %, pt
  int? height,
  int? width,
  int? elevation,
  Color? contentColor,
  Color? backgroundColor,
  TeXViewBorder? border,
  TeXViewBorderRadius? borderRadius,
  TeXViewOverflow? overflow,               // visible, hidden, scroll
  TeXViewTextAlign? textAlign,             // left, center, right, justify
  TeXViewFontStyle? fontStyle,
})

// Or use raw CSS:
TeXViewStyle.fromCSS("color: red; padding: 10px;")
```

### TeXViewWidget Subclasses

```dart
TeXViewDocument(String data, {TeXViewStyle? style})

TeXViewContainer({
  required TeXViewWidget child,
  TeXViewStyle? style,
})

TeXViewColumn({
  required List<TeXViewWidget> children,
  TeXViewStyle? style,
})

TeXViewInkWell({
  required String id,
  required TeXViewWidget child,
  Function(String id)? onTap,
  bool? rippleEffect,
  TeXViewStyle? style,
})

TeXViewMarkdown(String markdown, {
  TeXViewStyle? style,
  Iterable<BlockSyntax> blockSyntaxes = const [],
  Iterable<InlineSyntax> inlineSyntaxes = const [],
  ExtensionSet? extensionSet,
  // ... more markdown options
})

TeXViewImage.asset(String path)
TeXViewImage.network(String url)

TeXViewVideo.youtube(String url)

TeXViewDetails({
  required TeXViewWidget summary,
  required TeXViewWidget child,
  bool isOpen = false,
  TeXViewStyle? style,
})
```

### Styling Helpers

```dart
// Padding
TeXViewPadding.all(double value)
TeXViewPadding.only({double? left, top, right, bottom})
TeXViewPadding.symmetric({double? horizontal, vertical})
TeXViewPadding.zero()

// Margin (same constructors as Padding)
TeXViewMargin.all(double value)
// ... etc

// Border
TeXViewBorder.all(TeXViewBorderDecoration decoration)
TeXViewBorder.only({
  TeXViewBorderDecoration? left, top, right, bottom
})

TeXViewBorderDecoration({
  Color? borderColor,
  int? borderWidth,
  TeXViewBorderStyle? borderStyle,  // solid, dashed, dotted
})

// Border Radius
TeXViewBorderRadius.all(int radius)
TeXViewBorderRadius.only({
  int? topLeft, topRight, bottomLeft, bottomRight
})

// Font Style
TeXViewFontStyle({
  String? fontFamily,
  int? fontSize,
  TeXViewFontWeight? fontWeight,  // normal, bold, lighter
  TeXViewFontStyle? fontStyle,    // normal, italic
})
```

### Enums

```dart
enum TeXInputType {
  teX,        // LaTeX/TeX format
  mathML,     // MathML format
  asciiMath,  // AsciiMath format
}

enum TeXViewSizeUnit {
  px,   // Pixels
  em,   // Relative to font size
  rem,  // Relative to root font size
  percent,  // Percentage
  pt,   // Points
}

enum TeXViewTextAlign {
  left,
  center,
  right,
  justify,
}

enum TeXViewOverflow {
  visible,
  hidden,
  scroll,
}
```

### TeXRenderingServer

```dart
class TeXRenderingServer {
  static bool multiTeXView = false;  // Enable multiple controllers
  
  static Future<void> start({int port = 0});  // Initialize server
  
  static Future<String> teX2SVG({
    required String math,
    required TeXInputType teXInputType,
  });  // Direct TeX to SVG conversion
  
  static Future<void> stop();  // Cleanup
}
```

---

## Troubleshooting

### Issue: TeXView not rendering

**Solutions:**
1. Ensure `TeXRenderingServer.start()` called before `runApp()`
2. Check platform configuration (AndroidManifest.xml, Info.plist, etc.)
3. Verify LaTeX syntax is valid
4. Check console for JavaScript errors

```dart
// Enable debugging
TeXView(
  loadingWidgetBuilder: (context) => Text("LOADING..."),
  onRenderFinished: (h) => print("Rendered: $h"),
  // ...
)
```

### Issue: Incorrect height

**Solutions:**
1. Increase `heightOffset` parameter
2. Wait for `onRenderFinished` callback
3. Ensure images have proper dimensions

```dart
TeXView(
  heightOffset: 10.0,  // Increase from default 5.0
  onRenderFinished: (height) {
    print("Final height: $height");
  },
  // ...
)
```

### Issue: Tap callbacks not working

**Solutions:**
1. Verify ID is unique and matches
2. Ensure parent widgets propagate `onTapCallback`
3. Check that widget tree includes the InkWell

```dart
// Correct implementation
class MyWidget extends TeXViewWidget {
  @override
  void onTapCallback(String id) {
    child.onTapCallback(id);  // Must forward!
  }
}
```

### Issue: Custom fonts not working

**Note:** Custom fonts are deprecated. Use CSS instead:

```dart
TeXViewDocument(
  r"""<p style="font-family: 'MyFont';">Custom font text</p>""",
)
```

### Issue: Slow performance with many equations

**Solutions:**
1. Use `TeX2SVG` instead of `TeXView` for simple equations
2. Use `TeXWidget` for mixed content
3. Enable `wantKeepAlive: false` in lists
4. Consider pagination

```dart
// Good for simple inline math
RichText(
  text: TextSpan(children: [
    TextSpan(text: "The equation "),
    WidgetSpan(child: TeX2SVG(math: r"E = mc^2")),
    TextSpan(text: " is famous."),
  ]),
)
```

### Issue: Web platform not working

**Solutions:**
1. Ensure `flutter pub get` has been run
2. Check browser console for errors
3. Verify iframe is allowed in CSP headers
4. Use `flutter run -d chrome` for debugging

### Issue: "localhost refused to connect" on Android

**Solutions:**
1. Add `android:usesCleartextTraffic="true"` to AndroidManifest.xml
2. For Android 9+, this is required for localhost connections
3. Alternatively, use HTTPS (more complex setup)

### Issue: Math not rendering in WebView

**Solutions:**
1. Check MathJax is loaded (check console)
2. Verify delimiters are correct (`$$`, `\[`, `\(`, etc.)
3. Test with simple equation first: `r"$$x^2$$"`
4. Ensure HTML is properly escaped

```dart
// Good
TeXViewDocument(r"$$x^2$$")

// Bad (unescaped backslashes)
TeXViewDocument("$$x^2$$")  // Missing r prefix!
```

---

## Performance Tips

1. **Use appropriate widget for use case:**
   - Simple inline math → `TeX2SVG`
   - Mixed text/math → `TeXWidget`
   - Complex HTML/CSS → `TeXView`

2. **Reuse rendering server:**
   ```dart
   // Default: All TeXViews share one controller (efficient)
   TeXRenderingServer.multiTeXView = false;
   ```

3. **Optimize lists:**
   ```dart
   ListView.builder(
     itemBuilder: (context, index) {
       return TeXView(
         wantKeepAlive: false,  // Don't cache off-screen
         // ...
       );
     },
   )
   ```

4. **Cache complex equations:**
   ```dart
   final _renderedEquations = <String, String>{};  // Cache SVG
   
   Future<String> getCachedSVG(String latex) async {
     if (_renderedEquations.containsKey(latex)) {
       return _renderedEquations[latex]!;
     }
     final svg = await TeXRenderingServer.teX2SVG(
       math: latex,
       teXInputType: TeXInputType.teX,
     );
     _renderedEquations[latex] = svg;
     return svg;
   }
   ```

---

## LaTeX Quick Reference

### Common Symbols

```latex
Greek letters: \alpha, \beta, \gamma, \delta, \theta, \pi
Operators: +, -, \times, \div, \pm, \mp
Relations: =, \neq, <, >, \leq, \geq, \approx
Arrows: \to, \rightarrow, \leftarrow, \leftrightarrow
Logic: \land, \lor, \neg, \implies, \iff
Sets: \in, \notin, \subset, \subseteq, \cup, \cap, \emptyset
Calculus: \int, \sum, \prod, \lim, \partial, \infty
```

### Common Structures

```latex
Fractions: \frac{numerator}{denominator}
Powers: x^2, x^{10}
Subscripts: x_1, x_{10}
Square root: \sqrt{x}, \sqrt[n]{x}
Limits: \lim_{x \to \infty}, \sum_{i=1}^{n}
Integrals: \int_{0}^{1} x dx
Matrices: \begin{matrix} a & b \\ c & d \end{matrix}
```

### Delimiters

```latex
Inline math: $...$  or  \(...\)
Display math: $$...$$  or  \[...\]
```

---

## Best Practices

1. **Always use raw strings for LaTeX:**
   ```dart
   r"$$x^2$$"  // Good
   "$$x^2$$"   // Bad (backslashes need escaping)
   ```

2. **Initialize server in main:**
   ```dart
   void main() async {
     await TeXRenderingServer.start();
     runApp(MyApp());
   }
   ```

3. **Handle loading states:**
   ```dart
   TeXView(
     loadingWidgetBuilder: (context) => CircularProgressIndicator(),
   )
   ```

4. **Validate user input:**
   ```dart
   // Sanitize before rendering user-supplied LaTeX
   final sanitized = HtmlEscape().convert(userInput);
   ```

5. **Use appropriate input type:**
   ```dart
   TeX2SVG(
     math: mathMLString,
     teXInputType: TeXInputType.mathML,  // Not TeX!
   )
   ```

6. **Test on all platforms:**
   - Rendering may differ slightly between platforms
   - WebView behavior varies (Android vs iOS vs Web)
   - Always test multi-platform apps on real devices

---

## Additional Resources

- **Package Repository**: https://github.com/Shahxad-Akram/flutter_tex
- **MathJax Documentation**: https://docs.mathjax.org/
- **LaTeX Symbol Reference**: https://oeis.org/wiki/List_of_LaTeX_mathematical_symbols
- **Package on pub.dev**: https://pub.dev/packages/flutter_tex

---

**Last Updated**: Based on flutter_tex v5.1.10
