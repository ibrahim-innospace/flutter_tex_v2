import 'package:flutter/material.dart';
import 'package:flutter_tex_v2/flutter_tex.dart';

class TeXViewFontsExamples extends StatelessWidget {
  const TeXViewFontsExamples({super.key});
  String convertToHTML(String input) {
    return input.replaceAllMapped(RegExp(r'\\([\[\]])'), (match) {
      if (match.group(1) == '[') {
        return '\\(';
      } else if (match.group(1) == ']') {
        return '\\)';
      }
      return match.group(0) as String;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("TeXView Fonts"),
      ),
      body: TeXView(
          child: TeXViewColumn(children: [
            _teXViewWidget(
                convertToHTML(
                    r"""<p><span style=\"font-size: 14.0pt; line-height: 107%; font-family: Lecture; mso-fareast-font-family: Calibri; mso-bidi-font-family: 'Times New Roman'; mso-font-kerning: 1.0pt; mso-ansi-language: EN-US; mso-fareast-language: EN-US; mso-bidi-language: AR-SA;\">&circ;Kvb we&aelig;vbx &lsquo;mvBGUvmj&rsquo; k&otilde;wU c&Eacute;^g e&Aring;envi KGib? </span></p>"""),
                'Lecture'),
            _teXViewWidget("Budhrg", 'budhrg'),
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
          border: TeXViewBorder.all(
            TeXViewBorderDecoration(
                borderWidth: 2,
                borderStyle: TeXViewBorderStyle.groove,
                borderColor: Colors.green),
          ),
        ),
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
                  width: 250,
                  margin: const TeXViewMargin.zeroAuto())),
        ]);
  }
}
