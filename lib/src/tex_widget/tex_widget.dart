import 'package:flutter/material.dart';
import 'package:flutter_tex_v2/flutter_tex.dart';
import 'package:flutter_tex_v2/src/tex_widget/utils/parse_tex.dart';

/// A widget to render TeX segments, which can be inline or display math.
/// Currently, it only supports rendering TeX.

class TeXWidget extends StatelessWidget {
  /// A raw TeX string to be rendered.
  final String math;

  /// Optional builder for inline formulas.
  /// If not provided, it defaults to using [TeX2SVG] to render inline math.
  final Widget Function(BuildContext context, String inlineFormula)?
      inlineFormulaWidgetBuilder;

  /// Optional builder for display formulas.
  /// If not provided, it defaults to using [TeX2SVG] to render display math.
  final Widget Function(BuildContext context, String displayFormula)?
      displayFormulaWidgetBuilder;

  /// Optional builder for text segments.
  /// If not provided, it defaults to using a [TextSpan] with black color.
  final InlineSpan Function(BuildContext context, String text)?
      textWidgetBuilder;

  const TeXWidget({
    super.key,
    required this.math,
    this.inlineFormulaWidgetBuilder,
    this.displayFormulaWidgetBuilder,
    this.textWidgetBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final segments = parseTeX(math);
    if (segments.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: _buildChildren(context, segments),
    );
  }

  List<Widget> _buildChildren(BuildContext context, List<TeXSegment> segments) {
    final List<Widget> columnChildren = [];
    final List<InlineSpan> currentRichTextSpans = [];

    void flushSpans() {
      if (currentRichTextSpans.isNotEmpty) {
        columnChildren.add(
          RichText(
            text: TextSpan(
              children: List.of(currentRichTextSpans),
            ),
          ),
        );
        currentRichTextSpans.clear();
      }
    }

    for (final segment in segments) {
      switch (segment.type) {
        case TeXSegmentType.text:
          currentRichTextSpans
              .add(textWidgetBuilder?.call(context, segment.text) ??
                  TextSpan(
                      text: segment.text,
                      style: TextStyle(
                        color: Colors.black,
                      )));
          break;
        case TeXSegmentType.inline:
          currentRichTextSpans.add(WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: inlineFormulaWidgetBuilder?.call(context, segment.text) ??
                  TeX2SVG(
                    math: segment.text,
                  )));
          break;
        case TeXSegmentType.display:
          flushSpans();

          columnChildren
              .add(displayFormulaWidgetBuilder?.call(context, segment.text) ??
                  Center(
                    child: TeX2SVG(
                      math: segment.text,
                      formulaWidgetBuilder: (context, svg) {
                        double displayFontSize = 42;
                        return SvgPicture.string(
                          svg,
                          height: displayFontSize,
                          width: displayFontSize,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        );
                      },
                    ),
                  ));
          break;
      }
    }

    flushSpans();

    return columnChildren;
  }
}
