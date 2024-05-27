import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class Quiz {
  final String statement;
  final List<QuizOption> options;
  final String correctOptionId;

  Quiz(
      {required this.statement,
      required this.options,
      required this.correctOptionId});
}

class QuizOption {
  final String id;
  final String option;

  QuizOption(this.id, this.option);
}

class TeXViewQuizExample extends StatefulWidget {
  final TeXViewRenderingEngine renderingEngine;

  const TeXViewQuizExample(
      {super.key, this.renderingEngine = const TeXViewRenderingEngine.katex()});

  @override
  State<TeXViewQuizExample> createState() => _TeXViewQuizExampleState();
}

class _TeXViewQuizExampleState extends State<TeXViewQuizExample> {
  int currentQuizIndex = 0;
  String selectedOptionId = "";
  bool isWrong = false;

  List<Quiz> quizList = [
    Quiz(
      statement:
          r"""<p><span style=\"font-size: 11.0pt; mso-bidi-font-size: 10.0pt; line-height: 115%; font-family: 'Times New Roman','serif'; mso-fareast-font-family: Calibri; mso-fareast-theme-font: minor-latin; mso-ansi-language: EN-US; mso-fareast-language: EN-US; mso-bidi-language: AR-SA;\">200 N</span></p>""",
      options: [
        QuizOption(
          "id_1",
          r""" <p><span class=\"__se__katex katex\" data-exp=\"\\frac{F - 32}{212 - 32} = \\frac{45 - 3}{107 - 3} \\Rightarrow F = 104.69^\\circ\\text{F}\" data-font-size=\"1em\" style=\"font-size: 16px\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\"><semantics><mrow><mfrac><mrow><mi>F</mi><mo>−</mo><mn>32</mn></mrow><mrow><mn>212</mn><mo>−</mo><mn>32</mn></mrow></mfrac><mo>=</mo><mfrac><mrow><mn>45</mn><mo>−</mo><mn>3</mn></mrow><mrow><mn>107</mn><mo>−</mo><mn>3</mn></mrow></mfrac><mo>⇒</mo><mi>F</mi><mo>=</mo><mn>104.6</mn><msup><mn>9</mn><mo>∘</mo></msup><mtext>F</mtext></mrow><annotation encoding=\"application/x-tex\">\\frac{F - 32}{212 - 32} = \\frac{45 - 3}{107 - 3} \\Rightarrow F = 104.69^\\circ\\text{F}</annotation></semantics></math></span><span class=\"katex-html\" aria-hidden=\"true\"><span class=\"base\"><span class=\"strut\" style=\"height:2.1297em;vertical-align:-0.7693em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.3603em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">212</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">32</span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord mathnormal\" style=\"margin-right:0.13889em;\">F</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">32</span></span></span></span><span class=\"vlist-s\"></span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.7693em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:2.0908em;vertical-align:-0.7693em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.3214em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">107</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">3</span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">45</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">3</span></span></span></span><span class=\"vlist-s\"></span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.7693em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">⇒</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.6833em;\"></span><span class=\"mord mathnormal\" style=\"margin-right:0.13889em;\">F</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.7241em;\"></span><span class=\"mord\">104.6</span><span class=\"mord\"><span class=\"mord\">9</span><span class=\"msupsub\"><span class=\"vlist-t\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.7241em;\"><span style=\"top:-3.113em;margin-right:0.05em;\"><span class=\"pstrut\" style=\"height:2.7em;\"></span><span class=\"sizing reset-size6 size3 mtight\"><span class=\"mbin mtight\">∘</span></span></span></span></span></span></span></span><span class=\"mord text\"><span class=\"mord\">F</span></span></span></span></span><br></p>""",
        ),
        QuizOption(
          "id_2",
          r""" <h2>(B)   \(x = {b \pm \sqrt{b^2-4ac} \over 2a}\)</h2>""",
        ),
        QuizOption(
          "id_3",
          r""" <h2>(C)   \(x = {-b \pm \sqrt{b^2-4ac} \over 2a}\)</h2>""",
        ),
        QuizOption(
          "id_4",
          r""" <h2>(D)   \(x = {-b + \sqrt{b^2+4ac} \over 2a}\)</h2>""",
        ),
      ],
      correctOptionId: "id_3",
    ),
    Quiz(
      statement:
          r"""<h3>Choose the correct mathematical form of Bohr's Radius.</h3>""",
      options: [
        QuizOption(
          "id_1",
          r""" <h2>(A)   \( a_0 = \frac{{\hbar ^2 }}{{m_e ke^2 }} \)</h2>""",
        ),
        QuizOption(
          "id_2",
          r""" <h2>(B)   \( a_0 = \frac{{\hbar ^2 }}{{m_e ke^3 }} \)</h2>""",
        ),
        QuizOption(
          "id_3",
          r""" <h2>(C)   \( a_0 = \frac{{\hbar ^3 }}{{m_e ke^2 }} \)</h2>""",
        ),
        QuizOption(
          "id_4",
          r""" <h2>(D)   \( a_0 = \frac{{\hbar }}{{m_e ke^2 }} \)</h2>""",
        ),
      ],
      correctOptionId: "id_1",
    ),
    Quiz(
      statement: r"""<h3>Select the correct Chemical Balanced Equation.</h3>""",
      options: [
        QuizOption(
          "id_1",
          r""" <h2>(A)   \( \ce{CO + C -> 2 CO} \)</h2>""",
        ),
        QuizOption(
          "id_2",
          r""" <h2>(B)   \( \ce{CO2 + C ->  CO} \)</h2>""",
        ),
        QuizOption(
          "id_3",
          r""" <h2>(C)   \( \ce{CO + C ->  CO} \)</h2>""",
        ),
        QuizOption(
          "id_4",
          r""" <h2>(D)   \( \ce{CO2 + C -> 2 CO} \)</h2>""",
        ),
      ],
      correctOptionId: "id_4",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("TeXView Quiz"),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: <Widget>[
          Text(
            'Quiz ${currentQuizIndex + 1}/${quizList.length}',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          TeXView(
            renderingEngine: widget.renderingEngine,
            child: TeXViewColumn(children: [
              TeXViewDocument(quizList[currentQuizIndex].statement,
                  style:
                      const TeXViewStyle(textAlign: TeXViewTextAlign.center)),
              TeXViewGroup(
                  children: quizList[currentQuizIndex]
                      .options
                      .map((QuizOption option) {
                    return TeXViewGroupItem(
                      rippleEffect: false,
                      id: option.id,
                      child: TeXViewDocument(
                        option.option,
                        style: const TeXViewStyle(
                          padding: TeXViewPadding.all(10),
                        ),
                      ),
                    );
                  }).toList(),
                  selectedItemStyle: TeXViewStyle(
                      borderRadius: const TeXViewBorderRadius.all(10),
                      border: TeXViewBorder.all(TeXViewBorderDecoration(
                          borderWidth: 3, borderColor: Colors.green[900])),
                      margin: const TeXViewMargin.all(10)),
                  normalItemStyle:
                      const TeXViewStyle(margin: TeXViewMargin.all(10)),
                  onTap: (id) {
                    selectedOptionId = id;
                    setState(() {
                      isWrong = false;
                    });
                  })
            ]),
            style: const TeXViewStyle(
              margin: TeXViewMargin.all(5),
              padding: TeXViewPadding.all(10),
              borderRadius: TeXViewBorderRadius.all(10),
              border: TeXViewBorder.all(
                TeXViewBorderDecoration(
                    borderColor: Colors.blue,
                    borderStyle: TeXViewBorderStyle.solid,
                    borderWidth: 5),
              ),
              backgroundColor: Colors.white,
            ),
          ),
          if (isWrong)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Wrong answer!!! Please choose a correct option.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (currentQuizIndex > 0) {
                      selectedOptionId = "";
                      currentQuizIndex--;
                    }
                  });
                },
                child: const Text("Previous"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (selectedOptionId ==
                        quizList[currentQuizIndex].correctOptionId) {
                      selectedOptionId = "";
                      if (currentQuizIndex != quizList.length - 1) {
                        currentQuizIndex++;
                      }
                    } else {
                      isWrong = true;
                    }
                  });
                },
                child: const Text("Next"),
              ),
            ],
          )
        ],
      ),
    );
  }
}
