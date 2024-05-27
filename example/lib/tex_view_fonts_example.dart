import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class TeXViewFontsExamples extends StatelessWidget {
  final TeXViewRenderingEngine renderingEngine;

  const TeXViewFontsExamples(
      {super.key, this.renderingEngine = const TeXViewRenderingEngine.katex()});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("TeXView Fonts"),
      ),
      body: TeXView(
          fonts: const [
            TeXViewFont(fontFamily: 'army', src: 'fonts/Army.ttf'),
            TeXViewFont(
                fontFamily: 'Lecture', src: 'assets/fonts/lecture-reguler.ttf'),
            TeXViewFont(fontFamily: 'budhrg', src: 'fonts/Budhrg.ttf'),
            TeXViewFont(fontFamily: 'celtg', src: 'fonts/CELTG.ttf'),
            TeXViewFont(fontFamily: 'hillock', src: 'fonts/hillock.ttf'),
            TeXViewFont(fontFamily: 'intimacy', src: 'fonts/intimacy.ttf'),
            TeXViewFont(
                fontFamily: 'sansation_light', src: 'fonts/SansationLight.ttf'),
            TeXViewFont(fontFamily: 'slenmini', src: 'fonts/slenmini.ttf'),
            TeXViewFont(
                fontFamily: 'subaccuz_regular',
                src: 'fonts/SubaccuzRegular.ttf'),
          ],
          renderingEngine: renderingEngine,
          child: TeXViewColumn(children: [
            _teXViewWidget("Army", 'army'),
            _teXViewWidget(
                "<p><strong><span style=\"font-size:16px;font-family:Lecture\">‰KRb ˆivMxi ˆ`Gni Zvcgvòv ‰KwU ò‚wUcƒYÆ ^vGgÆvwgUvGii mvnvGhÅ ˆgGc </span>45°C<span style=\"font-size:16px;font-family:Lecture\"> cvIqv ˆMj| hw` ‰B ^vGgÆvwgUvGii eidwe±`y ‰es evÓ·we±`y h^vKÌGg </span>3°C<span style=\"font-size:16px;font-family:Lecture\"> ‰es </span>107°C<span style=\"font-size:16px;font-family:Lecture\"> cvIqv hvq, ZvnGj ˆivMxi ˆ`Gn cÉK‡Z Zvcgvòv dvGibnvBU ˆÕ•Gj ˆei Ki|</span></strong><br></p>, <p><span class=\"__se__katex katex\" data-exp=\"\\frac{F - 32}{212 - 32} = \\frac{45 - 3}{107 - 3} \\Rightarrow F = 104.69^\\circ\\text{F}\" data-font-size=\"1em\" style=\"font-size: 16px\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\"><semantics><mrow><mfrac><mrow><mi>F</mi><mo>−</mo><mn>32</mn></mrow><mrow><mn>212</mn><mo>−</mo><mn>32</mn></mrow></mfrac><mo>=</mo><mfrac><mrow><mn>45</mn><mo>−</mo><mn>3</mn></mrow><mrow><mn>107</mn><mo>−</mo><mn>3</mn></mrow></mfrac><mo>⇒</mo><mi>F</mi><mo>=</mo><mn>104.6</mn><msup><mn>9</mn><mo>∘</mo></msup><mtext>F</mtext></mrow><annotation encoding=\"application/x-tex\">\\frac{F - 32}{212 - 32} = \\frac{45 - 3}{107 - 3} \\Rightarrow F = 104.69^\\circ\\text{F}</annotation></semantics></math></span><span class=\"katex-html\" aria-hidden=\"true\"><span class=\"base\"><span class=\"strut\" style=\"height:2.1297em;vertical-align:-0.7693em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.3603em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">212</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">32</span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord mathnormal\" style=\"margin-right:0.13889em;\">F</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">32</span></span></span></span><span class=\"vlist-s\"></span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.7693em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:2.0908em;vertical-align:-0.7693em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.3214em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">107</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">3</span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">45</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">3</span></span></span></span><span class=\"vlist-s\"></span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.7693em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">⇒</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.6833em;\"></span><span class=\"mord mathnormal\" style=\"margin-right:0.13889em;\">F</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.7241em;\"></span><span class=\"mord\">104.6</span><span class=\"mord\"><span class=\"mord\">9</span><span class=\"msupsub\"><span class=\"vlist-t\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.7241em;\"><span style=\"top:-3.113em;margin-right:0.05em;\"><span class=\"pstrut\" style=\"height:2.7em;\"></span><span class=\"sizing reset-size6 size3 mtight\"><span class=\"mbin mtight\">∘</span></span></span></span></span></span></span></span><span class=\"mord text\"><span class=\"mord\">F</span></span></span></span></span><br></p>",
                'Army'),
            _teXViewWidget(
                "<h2><img src=\"https://cdn.britannica.com/17/83817-050-67C814CD/Mount-Everest.jpg\" alt=\"Mount Everest\"> What is the tallest mountain in the world?</h2>",
                'budhrg'),
            _teXViewWidget("CELTG", 'celtg'),
            _teXViewWidget("Hillock", 'hillock'),
            _teXViewWidget("intimacy", 'intimacy'),
            _teXViewWidget("Sansation Light", 'sansation_light'),
            _teXViewWidget("Slenmini", 'slenmini'),
            _teXViewWidget("Subaccuz Regular'", 'subaccuz_regular')
          ]),
          style: const TeXViewStyle(
            margin: TeXViewMargin.all(10),
            elevation: 10,
            borderRadius: TeXViewBorderRadius.all(25),
            border: TeXViewBorder.all(
              TeXViewBorderDecoration(
                  borderColor: Colors.blue,
                  borderStyle: TeXViewBorderStyle.solid,
                  borderWidth: 5),
            ),
            backgroundColor: Colors.white,
          ),
          loadingWidgetBuilder: (context) => const Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Text("Rendering...")
                  ],
                ),
              )),
    );
  }

  static TeXViewWidget _teXViewWidget(String title, String fontFamily) {
    return TeXViewColumn(
        style: const TeXViewStyle(
            margin: TeXViewMargin.all(5),
            padding: TeXViewPadding.all(5),
            borderRadius: TeXViewBorderRadius.all(10),
            border: TeXViewBorder.all(TeXViewBorderDecoration(
                borderWidth: 2,
                borderStyle: TeXViewBorderStyle.groove,
                borderColor: Colors.green))),
        children: [
          TeXViewDocument(title,
              style: TeXViewStyle(
                  fontStyle: TeXViewFontStyle(
                      fontSize: 20,
                      sizeUnit: TeXViewSizeUnit.pt,
                      fontFamily: fontFamily),
                  padding: const TeXViewPadding.all(10),
                  borderRadius: const TeXViewBorderRadius.all(10),
                  textAlign: TeXViewTextAlign.center,
                  //  width: 250,
                  margin: const TeXViewMargin.zeroAuto())),
        ]);
  }
}
