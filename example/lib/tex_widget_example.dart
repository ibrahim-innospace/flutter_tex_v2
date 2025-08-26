import 'package:flutter/material.dart';
import 'package:flutter_tex_v2/flutter_tex.dart';

class TeXWidgetExamples extends StatelessWidget {
  const TeXWidgetExamples({super.key});

  final String _formula =
      r"""Flutter $ \rm\TeX $ is a Flutter Package to render so many types of equations based on \( \rm\LaTeX \), It also includes full HTML with JavaScript support. Here's a simple example of $ \rm\TeX $ rendering:
          
          When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) and they are $$x = {-b \pm \sqrt{b^2-4ac} \over 2a}$$
          
          Another display formula is:
          
          \[ E = mc^2 + \frac{p^2}{2m} + \sum_{i} \frac{(p_i - qA_i)^2}{2m_i} + V(r) + ... \]
          
          """;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("TeXWidget Example"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        shrinkWrap: true,
        children: [
          Text("Default TeXWidget",
              style: Theme.of(context).textTheme.headlineSmall),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 4),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TeXWidget(math: _formula),
          ),
          Divider(
            height: 30,
            color: Colors.transparent,
          ),
          Text("Custom TeXWidget",
              style: Theme.of(context).textTheme.headlineSmall),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.lime, width: 4),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: TeXWidget(
              math: _formula,
              displayFormulaWidgetBuilder: (context, displayFormula) {
                return Center(
                  child: TeX2SVG(
                    math: displayFormula,
                    formulaWidgetBuilder: (context, svg) {
                      double displayFontSize = 50;
                      return SvgPicture.string(
                        svg,
                        colorFilter:
                            const ColorFilter.mode(Colors.red, BlendMode.srcIn),
                        height: displayFontSize,
                        width: displayFontSize,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      );
                    },
                  ),
                );
              },
              inlineFormulaWidgetBuilder: (context, inlineFormula) {
                return TeX2SVG(
                  math: inlineFormula,
                  formulaWidgetBuilder: (context, svg) {
                    double displayFontSize = 16;
                    return SvgPicture.string(
                      svg,
                      colorFilter: const ColorFilter.mode(
                          Colors.purple, BlendMode.srcIn),
                      height: displayFontSize,
                      width: displayFontSize,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                    );
                  },
                );
              },
              textWidgetBuilder: (context, text) {
                return TextSpan(
                  text: text,
                  style: const TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
