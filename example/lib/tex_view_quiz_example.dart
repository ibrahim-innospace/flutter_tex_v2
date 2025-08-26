import 'package:flutter/material.dart';
import 'package:flutter_tex_v2/flutter_tex.dart';

class Quiz {
  final String statement;
  final List<QuizOption> options;
  final String correctOptionId;
  String? selectedOptionId;

  Quiz(
      {required this.statement,
      required this.options,
      required this.correctOptionId,
      this.selectedOptionId});
}

const TeXViewStyle quizItemStyleNormal = TeXViewStyle(
  margin: TeXViewMargin.all(7),
  padding: TeXViewPadding.all(2),
  borderRadius: TeXViewBorderRadius.all(10),
  overflow: TeXViewOverflow.hidden,
  border: TeXViewBorder.all(
    TeXViewBorderDecoration(
        borderColor: Colors.grey,
        borderStyle: TeXViewBorderStyle.solid,
        borderWidth: 2),
  ),
);

const TeXViewStyle quizItemStyleError = TeXViewStyle(
  margin: TeXViewMargin.all(7),
  padding: TeXViewPadding.all(2),
  borderRadius: TeXViewBorderRadius.all(10),
  overflow: TeXViewOverflow.hidden,
  border: TeXViewBorder.all(
    TeXViewBorderDecoration(
        borderColor: Colors.red,
        borderStyle: TeXViewBorderStyle.solid,
        borderWidth: 5),
  ),
);

const TeXViewStyle quizItemStyleCorrect = TeXViewStyle(
  margin: TeXViewMargin.all(7),
  padding: TeXViewPadding.all(2),
  borderRadius: TeXViewBorderRadius.all(10),
  overflow: TeXViewOverflow.hidden,
  border: TeXViewBorder.all(
    TeXViewBorderDecoration(
        borderColor: Colors.green,
        borderStyle: TeXViewBorderStyle.solid,
        borderWidth: 5),
  ),
);

class QuizOption {
  final String id;
  final String option;
  bool isSelected;
  TeXViewStyle? style;

  QuizOption(this.id, this.option,
      {this.style = quizItemStyleNormal, this.isSelected = false});
}

class TeXViewQuizExample extends StatefulWidget {
  const TeXViewQuizExample({super.key});

  @override
  State<TeXViewQuizExample> createState() => _TeXViewQuizExampleState();
}

class _TeXViewQuizExampleState extends State<TeXViewQuizExample> {
  int currentQuizIndex = 0;
  String currentSelectedId = "";
  bool isWrong = false;

  List<Quiz> quizList = [
    Quiz(
      statement: r"""<h3>What is the correct form of quadratic formula?</h3>""",
      options: [
        QuizOption(
          "id_1",
          r""" <h2>(A)   \(x = {-b \pm \sqrt{b^2+4ac} \over 2a}\)</h2>""",
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

  final TeXViewStyle _teXViewStyleSelected = const TeXViewStyle(
    margin: TeXViewMargin.all(3),
    padding: TeXViewPadding.all(3),
    borderRadius: TeXViewBorderRadius.all(10),
    overflow: TeXViewOverflow.hidden,
    border: TeXViewBorder.all(
      TeXViewBorderDecoration(
          borderColor: Colors.blue,
          borderStyle: TeXViewBorderStyle.solid,
          borderWidth: 1),
    ),
  );

  String radioHtmlHelper(String label, bool isChecked) {
    var checked = isChecked ? 'checked' : 'unchecked';

    return r"""<input type="radio" """ +
        checked +
        r"""> <label""" +
        label +
        r"""</label>""";
  }

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
            child: TeXViewColumn(children: [
              TeXViewDocument(
                quizList[currentQuizIndex].statement,
                style: const TeXViewStyle(
                  textAlign: TeXViewTextAlign.center,
                  padding: TeXViewPadding.only(bottom: 10),
                ),
              ),
              ...quizList[currentQuizIndex].options.map((QuizOption option) {
                return TeXViewInkWell(
                  rippleEffect: true,
                  id: option.id,
                  child: TeXViewDocument(
                    radioHtmlHelper(
                      option.option,
                      option.isSelected,
                    ),
                    style: const TeXViewStyle(
                      padding: TeXViewPadding.all(10),
                    ),
                  ),
                  style: option.style,
                  onTap: (id) {
                    setState(() {
                      currentSelectedId = id;
                      isWrong = false;

                      quizList[currentQuizIndex].selectedOptionId = id;
                      for (var element in quizList[currentQuizIndex].options) {
                        if (element.id == id) {
                          element.isSelected = true;
                        } else {
                          element.isSelected = false;
                        }
                      }

                      for (var element in quizList[currentQuizIndex].options) {
                        element.style = quizItemStyleNormal;
                      }
                      option.style = _teXViewStyleSelected;
                    });
                  },
                );
              }),
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
                      currentQuizIndex--;
                    }
                  });
                },
                child: const Text("Previous"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (quizList[currentQuizIndex].selectedOptionId ==
                        quizList[currentQuizIndex].correctOptionId) {
                      if (currentQuizIndex != quizList.length - 1) {
                        currentQuizIndex++;
                      }
                    } else {
                      isWrong = true;

                      for (var element in quizList[currentQuizIndex].options) {
                        if (element.id ==
                            quizList[currentQuizIndex].correctOptionId) {
                          element.style = quizItemStyleCorrect;
                        }

                        if (element.id == currentSelectedId) {
                          element.style = quizItemStyleError;
                        }
                      }
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