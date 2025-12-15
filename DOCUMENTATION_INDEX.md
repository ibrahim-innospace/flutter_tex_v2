# Flutter TeX Package - Complete Documentation Index

This directory contains comprehensive technical documentation for the **flutter_tex** package (v5.1.10).

## Documentation Files

### 📚 [COMPREHENSIVE_DOCUMENTATION.md](COMPREHENSIVE_DOCUMENTATION.md)
**Complete in-depth technical documentation** covering:
- Package overview and architecture
- Internal working mechanisms
- Detailed file-by-file analysis
- Communication flows between Dart and JavaScript
- Platform-specific implementations (Mobile vs Web)
- Rendering pipeline explained
- Advanced usage patterns
- Performance considerations
- Security guidelines
- Future enhancement ideas

**Who should read this**: Developers who want to deeply understand how flutter_tex works internally, contributors, or those debugging complex issues.

---

### 🏗️ [ARCHITECTURE_DIAGRAM.md](ARCHITECTURE_DIAGRAM.md)
**Visual architecture diagrams and system design** including:
- Complete system architecture diagram
- Data flow diagrams
- Tap event flow visualization
- TeX2SVG rendering flow
- Class relationship diagrams
- Platform abstraction layer
- File organization structure
- Communication patterns

**Who should read this**: Developers who prefer visual learning, architects planning system integration, or anyone wanting a high-level overview.

---

### ⚡ [QUICK_REFERENCE.md](QUICK_REFERENCE.md)
**Quick reference guide and cookbook** featuring:
- Installation and setup instructions
- Code examples for all widgets (TeXView, TeXWidget, TeX2SVG)
- Common usage patterns
- Complete API reference
- Troubleshooting guide
- Performance tips
- LaTeX syntax quick reference
- Best practices

**Who should read this**: Developers actively using the package, those looking for specific code examples, or anyone needing quick answers.

---

## Quick Navigation

### I want to...

#### Learn the Basics
1. Start with [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Installation & Basic Setup
2. Review examples in [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - TeXView/TeXWidget/TeX2SVG Examples

#### Understand How It Works
1. Read [COMPREHENSIVE_DOCUMENTATION.md](COMPREHENSIVE_DOCUMENTATION.md) - Package Overview
2. Study [ARCHITECTURE_DIAGRAM.md](ARCHITECTURE_DIAGRAM.md) - System Architecture
3. Deep dive into [COMPREHENSIVE_DOCUMENTATION.md](COMPREHENSIVE_DOCUMENTATION.md) - Internal Working Mechanism

#### Solve a Problem
1. Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Troubleshooting section
2. Review [COMPREHENSIVE_DOCUMENTATION.md](COMPREHENSIVE_DOCUMENTATION.md) - Debugging section
3. Look at [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Common Patterns

#### Contribute to the Package
1. Study [COMPREHENSIVE_DOCUMENTATION.md](COMPREHENSIVE_DOCUMENTATION.md) - File-by-File Analysis
2. Understand [ARCHITECTURE_DIAGRAM.md](ARCHITECTURE_DIAGRAM.md) - Complete System Architecture
3. Review [COMPREHENSIVE_DOCUMENTATION.md](COMPREHENSIVE_DOCUMENTATION.md) - Communication Flow

#### Build a Specific Feature
1. Browse [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - Common Patterns section
2. Check [QUICK_REFERENCE.md](QUICK_REFERENCE.md) - API Reference
3. Reference [COMPREHENSIVE_DOCUMENTATION.md](COMPREHENSIVE_DOCUMENTATION.md) - Advanced Usage Patterns

---

## Package Overview

**flutter_tex** is a Flutter package that renders mathematical and scientific equations using LaTeX, TeX, MathML, and AsciiMath. It leverages MathJax for rendering and works across Android, iOS, macOS, and Web platforms.

### Key Features
- ✅ Multiple input formats (LaTeX, TeX, MathML, AsciiMath)
- ✅ Full HTML, CSS, and JavaScript support
- ✅ Cross-platform (Mobile & Web)
- ✅ Interactive elements with tap callbacks
- ✅ Custom styling and fonts
- ✅ Markdown support
- ✅ Image and video embedding
- ✅ Three rendering modes: TeXView, TeXWidget, TeX2SVG

### Three Main Components

#### 1. **TeXView** (Full-Featured WebView)
- **Best for**: Complex documents with HTML/CSS/JavaScript
- **Uses**: WebView with MathJax rendering
- **Supports**: Everything (HTML, images, videos, interactivity)
- **Performance**: Moderate (WebView overhead)

#### 2. **TeXWidget** (Hybrid Text + Math)
- **Best for**: Mixed text and math content
- **Uses**: Flutter widgets + SVG for equations
- **Supports**: Text paragraphs with inline/display math
- **Performance**: Good (native Flutter rendering)

#### 3. **TeX2SVG** (Pure Math Widget)
- **Best for**: Simple inline equations
- **Uses**: Direct TeX to SVG conversion
- **Supports**: Single equations only
- **Performance**: Excellent (lightweight SVG)

---

## Architecture Summary

```
Flutter App (Dart)
       ↓
Widget Layer (TeXView, TeXWidget, TeX2SVG)
       ↓
Serialization Layer (JSON)
       ↓
Platform Bridge
   ├── Mobile: WebView + Localhost Server
   └── Web: iframe + JS Interop
       ↓
JavaScript Layer (DOM Builder)
       ↓
MathJax Engine
       ↓
Rendered Output
```

---

## Quick Start Example

```dart
import 'package:flutter_tex/flutter_tex.dart';

void main() async {
  // Required: Initialize rendering server
  await TeXRenderingServer.start();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Flutter TeX Demo")),
        body: Center(
          child: TeXView(
            child: TeXViewDocument(
              r"""
              <h2>Einstein's Equation</h2>
              <p>The famous mass-energy equivalence:</p>
              $$E = mc^2$$
              <p>Where:</p>
              <ul>
                <li>$E$ is energy</li>
                <li>$m$ is mass</li>
                <li>$c$ is the speed of light</li>
              </ul>
              """
            ),
          ),
        ),
      ),
    );
  }
}
```

---

## File Structure

```
flutter_tex/
├── COMPREHENSIVE_DOCUMENTATION.md  ← Deep technical docs
├── ARCHITECTURE_DIAGRAM.md         ← Visual architecture
├── QUICK_REFERENCE.md              ← Quick guide & examples
├── README.md                       ← Official package README
├── CHANGELOG.md                    ← Version history
├── pubspec.yaml                    ← Package configuration
│
├── lib/
│   ├── flutter_tex.dart           ← Main export file
│   ├── core/                      ← WebView assets (HTML/JS/CSS)
│   └── src/
│       ├── tex_view/              ← TeXView component
│       ├── tex_widget/            ← TeXWidget component
│       └── tex_server/            ← Rendering server
│
└── example/                       ← Demo application
    └── lib/
        ├── main.dart
        ├── tex_view_document_example.dart
        ├── tex_widget_example.dart
        ├── tex2svg_example.dart
        └── ...
```

---

## Documentation Maintenance

### Version Information
- **Package Version**: 5.1.10
- **Documentation Date**: December 2025
- **Flutter SDK**: >=3.2.3 <4.0.0

### How to Update These Docs
When the package is updated:

1. **COMPREHENSIVE_DOCUMENTATION.md**:
   - Update file-by-file analysis for changed files
   - Add new features to "Advanced Usage Patterns"
   - Update API changes section

2. **ARCHITECTURE_DIAGRAM.md**:
   - Revise diagrams if architecture changes
   - Add new components to system diagram
   - Update data flow if communication changes

3. **QUICK_REFERENCE.md**:
   - Add examples for new widgets/features
   - Update API reference with new parameters
   - Add troubleshooting for new issues

---

## Comparison with Original README

The original [README.md](README.md) focuses on:
- Quick start and installation
- Basic usage examples
- Screenshots and demos
- Platform setup instructions

This documentation suite extends that with:
- **Deep technical internals** (how code actually works)
- **Visual architecture** (system design diagrams)
- **Comprehensive API reference** (every parameter explained)
- **Advanced patterns** (real-world usage scenarios)
- **Troubleshooting** (common issues and solutions)
- **Performance optimization** (best practices)

---

## Community Resources

- **GitHub Repository**: https://github.com/Shahxad-Akram/flutter_tex
- **pub.dev Package**: https://pub.dev/packages/flutter_tex
- **Web Demo**: https://flutter-tex.web.app
- **Issues & Discussions**: https://github.com/Shahxad-Akram/flutter_tex/issues

---

## Contributing

If you find errors or want to improve this documentation:

1. Fork the repository
2. Make your changes to the relevant .md file
3. Submit a pull request with:
   - Clear description of changes
   - Reason for the change
   - Affected documentation files

---

## License

This documentation is part of the flutter_tex package and follows the same license.
See [LICENSE](LICENSE) file in the package root.

---

## Credits

**Package Author**: Shah Xad  
**Documentation**: Comprehensive technical analysis of flutter_tex v5.1.10  
**MathJax**: Original rendering engine (https://www.mathjax.org/)

---

**Happy Coding with Flutter TeX! 🧮📐📊**
