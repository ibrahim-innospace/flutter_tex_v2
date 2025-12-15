# MathJax Integration in flutter_tex - Complete Documentation

## Table of Contents
1. [Overview](#overview)
2. [MathJax Build System](#mathjax-build-system)
3. [How HTML Tags Are Processed](#how-html-tags-are-processed)
4. [How LaTeX Equations Are Handled](#how-latex-equations-are-handled)
5. [Complete Processing Flow](#complete-processing-flow)
6. [Two Rendering Modes](#two-rendering-modes)
7. [Delimiter Detection](#delimiter-detection)
8. [Step-by-Step Examples](#step-by-step-examples)
9. [Technical Implementation](#technical-implementation)

---

## Overview

**flutter_tex** uses **MathJax v3.2.2** as its core rendering engine to convert mathematical notation (LaTeX, TeX, MathML, AsciiMath) into visual SVG graphics. The package handles both pure HTML content and mixed HTML+LaTeX content seamlessly.

### Key Questions Answered:
- ✅ How does the package process HTML tags?
- ✅ How does it detect and render LaTeX equations within HTML?
- ✅ What happens when you send `<p>Text with $x^2$</p>`?
- ✅ How is MathJax initialized and called?

---

## MathJax Build System

### Custom Bundle Location: `lib_mathjax/`

The package creates a **custom MathJax bundle** that includes only the necessary components:

```
lib_mathjax/
├── package.json          ← Dependencies (mathjax-full: ^3.2.2)
├── index.js              ← MathJax configuration & wrapper
├── webpack.config.js     ← Build configuration
└── dist/
    └── mathjax_core.js   ← Bundled output (deployed to lib/core/)
```

### Build Configuration (`lib_mathjax/index.js`)

```javascript
// Load MathJax components
require('mathjax-full/components/src/input/tex-full/tex-full.js');   // LaTeX/TeX support
require('mathjax-full/components/src/input/mml/mml.js');              // MathML support
require('mathjax-full/components/src/input/asciimath/asciimath.js'); // AsciiMath support
require('mathjax-full/components/src/output/svg/svg.js');             // SVG output

// Create custom wrapper for direct SVG conversion
class MathJaxLiteDOM {
  teX2SVG(math, inputType, options) {
    // Converts LaTeX → SVG without needing browser DOM
    return this.adapteor.innerHTML(
      mathjax.document('', {
        InputJax: this.getInputType(inputType),
        OutputJax: this.outputJax
      }).convert(math, options)
    );
  }
}

const mathJaxLiteDOM = new MathJaxLiteDOM();
module.exports = { mathJaxLiteDOM };
```

### Webpack Bundles It

```javascript
// lib_mathjax/webpack.config.js
module.exports = {
    output: {
        libraryTarget: 'umd',              // Works in browser & Node
        filename: 'mathjax_core.js',       // Output filename
        path: path.resolve(__dirname, 'dist/'),
        globalObject: 'this'
    }
};
```

**Build Command:**
```bash
cd lib_mathjax
npm install
webpack
# Output: lib_mathjax/dist/mathjax_core.js
# This gets copied to: lib/core/mathjax_core.js
```

---

## How HTML Tags Are Processed

### Step 1: Flutter Widget Tree → JSON Serialization

When you create a TeXView widget:

```dart
TeXView(
  child: TeXViewDocument(
    r"""
    <h2>Einstein's Equation</h2>
    <p>The famous equation is: $$E = mc^2$$</p>
    <p>Where $E$ is energy and $m$ is mass.</p>
    """
  ),
)
```

**Dart converts it to JSON:**

```dart
// lib/src/tex_view/utils/core_utils.dart
String getRawData(TeXView teXView) {
  return jsonEncode({
    'meta': {
      'tag': 'div',
      'classList': 'tex-view',
      'node': 'root'
    },
    'data': {
      'meta': {
        'tag': 'div',
        'classList': 'tex-view-document',
        'node': 'leaf'
      },
      'data': """
        <h2>Einstein's Equation</h2>
        <p>The famous equation is: $$E = mc^2$$</p>
        <p>Where $E$ is energy and $m$ is mass.</p>
      """,
      'style': '...'
    },
    'style': '...'
  });
}
```

### Step 2: JSON Sent to JavaScript

```dart
// lib/src/tex_view/tex_view_mobile.dart
await teXRenderingController.webViewControllerPlus
    .runJavaScript('initTeXViewMobile($jsonData);');
```

### Step 3: JavaScript Builds HTML DOM

```javascript
// lib/core/flutter_tex.js
function initTeXViewMobile(flutterTeXData) {
    var teXViewElement = document.getElementById('TeXView');
    teXViewElement.innerHTML = '';
    
    // Recursively builds DOM from JSON
    teXViewElement.appendChild(createTeXView(flutterTeXData));
    
    // Call MathJax to render equations
    renderTeXView(() => renderCompleted(teXViewElement));
}
```

### Step 4: createTeXView() Processes HTML

```javascript
function createTeXView(rootData, teXViewElement, iframeId, isWeb) {
    var meta = rootData['meta'];
    var data = rootData['data'];
    
    // Create HTML element
    var element = document.createElement(meta['tag']);  // <div>
    element.classList.add(meta['classList']);           // 'tex-view-document'
    element.setAttribute('style', rootData['style']);
    
    switch (meta['node']) {
        case 'leaf':
            // For leaf nodes, insert HTML directly
            if (meta['tag'] === 'img') {
                element.setAttribute('src', data);
            } else {
                element.innerHTML = data;  // ← HTML inserted here!
            }
            break;
        
        case 'internal_child':
            // For containers, recurse into child
            element.appendChild(createTeXView(data, ...));
            break;
        
        case 'internal_children':
            // For columns, recurse into all children
            data.forEach(childViewData => {
                element.appendChild(createTeXView(childViewData, ...));
            });
            break;
    }
    
    return element;
}
```

**Result in DOM:**

```html
<div id="TeXView" class="tex-view">
  <div class="tex-view-document">
    <h2>Einstein's Equation</h2>
    <p>The famous equation is: $$E = mc^2$$</p>
    <p>Where $E$ is energy and $m$ is mass.</p>
  </div>
</div>
```

**At this point:**
- ✅ HTML tags (`<h2>`, `<p>`) are in the DOM
- ❌ LaTeX equations (`$$E = mc^2$$`, `$E$`) are still plain text
- ⏳ MathJax has NOT run yet

---

## How LaTeX Equations Are Handled

### Step 5: MathJax Scans and Renders

After HTML is built, the code calls:

```javascript
// lib/core/flutter_tex.html
function renderTeXView(onCompleteCallback) {
    MathJax.typesetPromise(["#TeXView"]).then(() => {
        onCompleteCallback();
        console.log("MathJax typesetting complete.");
    }).catch((err) => {
        console.error("Error during MathJax typesetting:", err);
    });
}
```

**What MathJax.typesetPromise() does:**

1. **Scans the DOM** for LaTeX delimiters:
   - `$$...$$` → Display math (block)
   - `\[...\]` → Display math (block)
   - `$...$` → Inline math
   - `\(...\)` → Inline math

2. **Parses LaTeX** using TeX input processor

3. **Converts to SVG** using SVG output processor

4. **Replaces in DOM** - Swaps text with SVG elements

### MathJax Processing Example

**Before MathJax (plain text):**
```html
<p>The famous equation is: $$E = mc^2$$</p>
<p>Where $E$ is energy and $m$ is mass.</p>
```

**After MathJax (rendered SVG):**
```html
<p>The famous equation is: 
  <mjx-container class="MathJax" jax="SVG" display="true">
    <svg xmlns="http://www.w3.org/2000/svg" width="8ex" height="2ex" viewBox="0 -750 3500 900">
      <path d="M52 289Q59 289 66 295T74 303Q74 312 ..."/>
      <!-- SVG paths for E = mc^2 -->
    </svg>
  </mjx-container>
</p>
<p>Where 
  <mjx-container class="MathJax" jax="SVG">
    <svg xmlns="http://www.w3.org/2000/svg" width="1.5ex" height="2ex">
      <path d="M..."/>  <!-- SVG for E -->
    </svg>
  </mjx-container>
  is energy and 
  <mjx-container class="MathJax" jax="SVG">
    <svg><!-- SVG for m --></svg>
  </mjx-container>
  is mass.
</p>
```

---

## Complete Processing Flow

### TeXView Flow (Full HTML + LaTeX)

```
┌────────────────────────────────────────────────────────────────┐
│ STEP 1: Flutter Widget Creation                               │
│                                                                │
│ TeXViewDocument(r"<p>Equation: $$x^2$$</p>")                  │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 2: Serialization to JSON                                 │
│                                                                │
│ {                                                              │
│   meta: {tag: 'div', classList: 'tex-view-document', ...},    │
│   data: "<p>Equation: $$x^2$$</p>",                           │
│   style: "..."                                                 │
│ }                                                              │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 3: Send to WebView JavaScript                            │
│                                                                │
│ webViewControllerPlus.runJavaScript(                          │
│   'initTeXViewMobile(' + jsonString + ');'                    │
│ )                                                              │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 4: JavaScript Receives Data                              │
│                                                                │
│ function initTeXViewMobile(flutterTeXData) {                  │
│   var teXViewElement = document.getElementById('TeXView');    │
│   teXViewElement.innerHTML = '';                              │
│   teXViewElement.appendChild(createTeXView(flutterTeXData));  │
│   renderTeXView(() => renderCompleted(teXViewElement));       │
│ }                                                              │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 5: Build HTML DOM (createTeXView)                        │
│                                                                │
│ var element = document.createElement('div');                  │
│ element.innerHTML = "<p>Equation: $$x^2$$</p>";  ← HTML here! │
│ return element;                                                │
│                                                                │
│ DOM Result:                                                    │
│ <div id="TeXView">                                            │
│   <div class="tex-view-document">                             │
│     <p>Equation: $$x^2$$</p>  ← Still plain text!            │
│   </div>                                                       │
│ </div>                                                         │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 6: MathJax Scanning Phase                                │
│                                                                │
│ MathJax.typesetPromise(["#TeXView"])                          │
│   ↓                                                            │
│ Scans DOM for delimiters:                                     │
│   - Finds: "$$x^2$$"                                          │
│   - Type: Display math (block)                                │
│   - Content: "x^2"                                             │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 7: MathJax Parsing Phase                                 │
│                                                                │
│ TeX Input Processor:                                          │
│   Input: "x^2"                                                 │
│   Parse: x (identifier) ^ (superscript) 2 (number)           │
│   AST: SuperscriptNode(x, 2)                                  │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 8: MathJax SVG Generation                                │
│                                                                │
│ SVG Output Processor:                                         │
│   AST → SVG paths                                             │
│   Output: <svg><path d="M52..."/><path d="M234..."/></svg>   │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 9: DOM Replacement                                       │
│                                                                │
│ Before:                                                        │
│ <p>Equation: $$x^2$$</p>                                      │
│                                                                │
│ After:                                                         │
│ <p>Equation:                                                  │
│   <mjx-container jax="SVG" display="true">                    │
│     <svg width="2ex" height="2ex">                            │
│       <path d="M52 289Q59..."/>  ← Rendered x               │
│       <path d="M234 678Q..."/>   ← Rendered superscript 2    │
│     </svg>                                                     │
│   </mjx-container>                                             │
│ </p>                                                           │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 10: Height Calculation & Callback                        │
│                                                                │
│ function renderCompleted(teXViewElement) {                    │
│   const height = getTeXViewHeight(teXViewElement);            │
│   OnTeXViewRenderedCallback.postMessage(height);              │
│ }                                                              │
│                                                                │
│ getTeXViewHeight():                                           │
│   height = element.offsetHeight + marginTop + marginBottom    │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 11: Flutter Receives Height                              │
│                                                                │
│ JavaScript Channel: OnTeXViewRenderedCallback                 │
│   ↓                                                            │
│ onTeXViewRenderedCallback(height) {                           │
│   heightStreamController.add(height);                         │
│   setState(() {}); // Update UI with correct height           │
│ }                                                              │
└────────────────────────┬───────────────────────────────────────┘
                         ↓
┌────────────────────────────────────────────────────────────────┐
│ STEP 12: Final Rendering                                      │
│                                                                │
│ SizedBox(                                                      │
│   height: calculatedHeight,  ← From MathJax                   │
│   child: WebViewWidget(...), ← Shows rendered HTML+SVG        │
│ )                                                              │
└────────────────────────────────────────────────────────────────┘
```

---

## Two Rendering Modes

### Mode 1: TeXView (DOM-based with MathJax.typesetPromise)

**Use Case:** Full documents with HTML, CSS, JavaScript, and math

**Process:**
1. HTML inserted into DOM with `innerHTML`
2. MathJax scans DOM for delimiters
3. Equations replaced with SVG in-place
4. Height calculated from final DOM

**Example:**
```dart
TeXView(
  child: TeXViewDocument(r"""
    <div style="background: yellow; padding: 10px;">
      <h1>Title</h1>
      <p>Inline: $x^2$</p>
      <p>Display: $$\int_0^1 x dx$$</p>
    </div>
  """),
)
```

**JavaScript calls:**
```javascript
element.innerHTML = "..."; // HTML + LaTeX as text
MathJax.typesetPromise(["#TeXView"]); // Finds and renders equations
```

---

### Mode 2: TeX2SVG (Direct conversion with mathJaxLiteDOM)

**Use Case:** Simple equations without HTML overhead

**Process:**
1. LaTeX sent directly to MathJax
2. Converted to SVG string
3. Returned to Flutter
4. Rendered with SvgPicture.string()

**Example:**
```dart
TeX2SVG(math: r"E = mc^2")
```

**JavaScript calls:**
```javascript
// No DOM, direct conversion
mathJaxLiteDOM.teX2SVG("E = mc^2", "teX");
// Returns: "<svg>...</svg>"
```

**Dart receives:**
```dart
Future<String> teX2SVG({required String math, required TeXInputType type}) {
  return teXRenderingController.webViewControllerPlus
      .runJavaScriptReturningResult(
          "mathJaxLiteDOM.teX2SVG('${math}', '${type.value}');"
      )
      .then((svgString) => svgString);
}
```

---

## Delimiter Detection

### MathJax Configuration (Default)

MathJax automatically detects these delimiters:

| Delimiter | Type            | Example      | Result            |
| --------- | --------------- | ------------ | ----------------- |
| `$$...$$` | Display (block) | `$$E=mc^2$$` | Centered, large   |
| `\[...\]` | Display (block) | `\[x^2\]`    | Centered, large   |
| `$...$`   | Inline          | `$x^2$`      | In-line with text |
| `\(...\)` | Inline          | `\(E\)`      | In-line with text |

### How Detection Works

**Step 1: DOM Text Nodes Scanned**
```html
<p>The equation $$E = mc^2$$ is famous.</p>
```

MathJax finds text node: `"The equation $$E = mc^2$$ is famous."`

**Step 2: Regex Pattern Matching**
```javascript
// MathJax internal regex (simplified)
const displayMathRegex = /\$\$(.*?)\$\$/g;
const inlineMathRegex = /\$(.*?)\$/g;
```

Matches: `$$E = mc^2$$`
- Type: Display
- Content: `E = mc^2`

**Step 3: Replace Text with SVG Container**
```html
<p>The equation 
  <mjx-container display="true">
    <svg>...</svg>
  </mjx-container>
  is famous.
</p>
```

---

## Step-by-Step Examples

### Example 1: Simple HTML with Inline Math

**Input:**
```dart
TeXViewDocument(r"<p>The value of $\pi$ is approximately 3.14.</p>")
```

**Step 1 - JSON:**
```json
{
  "data": "<p>The value of $\\pi$ is approximately 3.14.</p>"
}
```

**Step 2 - DOM After createTeXView():**
```html
<div class="tex-view-document">
  <p>The value of $\pi$ is approximately 3.14.</p>
</div>
```

**Step 3 - MathJax Scans:**
- Finds: `$\pi$`
- Type: Inline math
- Content: `\pi`

**Step 4 - DOM After MathJax:**
```html
<div class="tex-view-document">
  <p>The value of 
    <mjx-container jax="SVG">
      <svg width="1.2ex" height="1.5ex">
        <path d="..."/>  <!-- π symbol -->
      </svg>
    </mjx-container>
    is approximately 3.14.
  </p>
</div>
```

---

### Example 2: Complex HTML with Multiple Equations

**Input:**
```dart
TeXViewColumn(
  children: [
    TeXViewDocument(r"<h2>Quadratic Formula</h2>"),
    TeXViewDocument(r"""
      <p>For $ax^2 + bx + c = 0$, the solution is:</p>
      <p>$$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$$</p>
    """),
  ],
)
```

**Step 1 - JSON:**
```json
{
  "meta": {"tag": "div", "classList": "tex-view-column", "node": "internal_children"},
  "data": [
    {
      "meta": {"tag": "div", "classList": "tex-view-document", "node": "leaf"},
      "data": "<h2>Quadratic Formula</h2>"
    },
    {
      "meta": {"tag": "div", "classList": "tex-view-document", "node": "leaf"},
      "data": "<p>For $ax^2 + bx + c = 0$, the solution is:</p><p>$$x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}$$</p>"
    }
  ]
}
```

**Step 2 - DOM After createTeXView():**
```html
<div class="tex-view-column">
  <div class="tex-view-document">
    <h2>Quadratic Formula</h2>
  </div>
  <div class="tex-view-document">
    <p>For $ax^2 + bx + c = 0$, the solution is:</p>
    <p>$$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$$</p>
  </div>
</div>
```

**Step 3 - MathJax Scans:**
- Finds: `$ax^2 + bx + c = 0$` (inline)
- Finds: `$$x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}$$` (display)

**Step 4 - DOM After MathJax:**
```html
<div class="tex-view-column">
  <div class="tex-view-document">
    <h2>Quadratic Formula</h2>
  </div>
  <div class="tex-view-document">
    <p>For 
      <mjx-container jax="SVG">
        <svg><!-- ax^2 + bx + c = 0 --></svg>
      </mjx-container>
      , the solution is:
    </p>
    <p>
      <mjx-container jax="SVG" display="true">
        <svg width="15ex" height="5ex">
          <!-- Full quadratic formula -->
        </svg>
      </mjx-container>
    </p>
  </div>
</div>
```

---

### Example 3: MathML Input

**Input:**
```dart
TeXViewDocument(r"""
  <p>MathML example:</p>
  <math xmlns="http://www.w3.org/1998/Math/MathML">
    <mrow>
      <msup><mi>x</mi><mn>2</mn></msup>
      <mo>+</mo>
      <msup><mi>y</mi><mn>2</mn></msup>
    </mrow>
  </math>
""")
```

**Process:**
1. HTML inserted into DOM
2. MathJax detects `<math>` tag (MathML)
3. MathML input processor parses
4. SVG output processor generates
5. Replaces `<math>` with `<mjx-container><svg>...`

---

## Technical Implementation

### MathJax Loading in HTML

```html
<!-- lib/core/flutter_tex.html -->
<!DOCTYPE html>
<html>
<head>
    <!-- Custom MathJax bundle -->
    <script src="mathjax_core.js" id="MathJax-script"></script>
    
    <!-- Other assets -->
    <script src="flutter_tex.js"></script>
    <link rel="stylesheet" href="flutter_tex.css">
</head>
<body>
    <div id="TeXView"></div>
    
    <script>
        // Wrapper function for MathJax rendering
        function renderTeXView(onCompleteCallback) {
            MathJax.typesetPromise(["#TeXView"]).then(() => {
                onCompleteCallback();
            }).catch((err) => {
                console.error("MathJax error:", err);
            });
        }
    </script>
</body>
</html>
```

### MathJax API Usage

**DOM-based (TeXView):**
```javascript
// Process all math in specified container
MathJax.typesetPromise(["#TeXView"])
  .then(() => {
    console.log("All equations rendered");
  });
```

**Direct SVG (TeX2SVG):**
```javascript
// Custom wrapper in mathjax_core.js
class MathJaxLiteDOM {
  teX2SVG(math, inputType) {
    const doc = mathjax.document('', {
      InputJax: this.getInputType(inputType),  // TeX, MathML, or AsciiMath
      OutputJax: this.outputJax                 // SVG
    });
    return this.adapteor.innerHTML(doc.convert(math));
  }
}
```

### Height Calculation Loop

```javascript
// lib/core/flutter_tex.js
function renderCompleted(texViewElement, iframeId, isWeb) {
    let lastHeight;
    
    function execute() {
        const height = getTeXViewHeight(texViewElement);
        const rendered = lastHeight === height;  // Stable?
        lastHeight = height;
        
        // Send current height to Flutter
        if (isWeb) {
            OnTeXViewRenderedCallback(height, iframeId);
        } else {
            OnTeXViewRenderedCallback.postMessage(height);
        }
        
        // If not stable, MathJax still processing
        if (!rendered) {
            console.log('Height changing, retrying in 250ms...');
            setTimeout(() => execute(), 250);  // Poll again
        } else {
            console.log('Rendering complete, height stable at:', height);
        }
    }
    
    execute();  // Start polling
}

function getTeXViewHeight(view) {
    var height = view.offsetHeight;
    var style = window.getComputedStyle(view);
    
    // Add margins
    return ['top', 'bottom']
        .map(side => parseInt(style["margin-" + side]))
        .reduce((total, side) => total + side, height);
}
```

**Why polling?**
- MathJax rendering is asynchronous
- SVG dimensions calculated after insertion
- Fonts may load after initial render
- Images in equations need loading time
- Multiple equations render sequentially

---

## Summary

### How HTML Tags Are Processed:
1. ✅ HTML strings from Dart are serialized to JSON
2. ✅ JavaScript receives JSON and builds DOM using `createElement()` and `innerHTML`
3. ✅ HTML elements (`<h1>`, `<p>`, `<div>`, etc.) are created normally
4. ✅ CSS styles applied via `setAttribute('style', ...)`
5. ✅ At this point, HTML is in DOM but equations are still plain text

### How LaTeX Equations Are Handled:
1. ✅ After DOM is built, `MathJax.typesetPromise()` is called
2. ✅ MathJax scans DOM text nodes for delimiters (`$$`, `$`, `\[`, `\(`)
3. ✅ Each equation is parsed by TeX/MathML/AsciiMath input processor
4. ✅ Converted to SVG by SVG output processor
5. ✅ Original text replaced with `<mjx-container><svg>` elements
6. ✅ Height calculated and sent back to Flutter
7. ✅ Flutter updates WebView size to match rendered content

### Key Points:
- 🔑 **HTML is standard** - Regular DOM manipulation
- 🔑 **LaTeX is transformed** - Text → SVG via MathJax
- 🔑 **Process is sequential** - DOM first, then MathJax
- 🔑 **Height is dynamic** - Calculated after rendering
- 🔑 **Two modes available** - Full DOM or direct conversion

This architecture allows seamless mixing of HTML layout and mathematical notation, with MathJax handling all the complex equation rendering behind the scenes.
