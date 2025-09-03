import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/icon_constant.dart';

class Quiz {
  final String statement;
  final List<QuizOption> options;
  final String correctOptionId;
  List<String> selectedOptionIds = [];

  Quiz(
      {required this.statement,
      required this.options,
      required this.correctOptionId});
}

class QuizOption {
  final String id;
  final String content;
  final bool isCorrect;

  QuizOption(this.id, this.content, {this.isCorrect = false});
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
  bool showAnswerResult = false;

  List<Quiz> quizList = [
    Quiz(
      statement: r"""<h3>What is the correct form of quadratic formula?</h3>""",
      options: [
        QuizOption(
          "id_1",
          r"""\(x = {-b \pm \sqrt{b^2+4ac} \over 2a}\)""",
        ),
        QuizOption(
          "id_2",
          r"""\(x = {b \pm \sqrt{b^2-4ac} \over 2a}\)""",
        ),
        QuizOption(
          "id_3",
          r"""\(x = {-b \pm \sqrt{b^2-4ac} \over 2a}\)""",
          isCorrect: true,
        ),
        QuizOption(
          "id_4",
          r"""\(x = {-b + \sqrt{b^2+4ac} \over 2a}\)""",
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
          r"""\( a_0 = \frac{{\hbar ^2 }}{{m_e ke^2 }} \)""",
          isCorrect: true,
        ),
        QuizOption(
          "id_2",
          r"""\( a_0 = \frac{{\hbar ^2 }}{{m_e ke^3 }} \)""",
        ),
        QuizOption(
          "id_3",
          r"""\( a_0 = \frac{{\hbar ^3 }}{{m_e ke^2 }} \)""",
        ),
        QuizOption(
          "id_4",
          r"""\( a_0 = \frac{{\hbar }}{{m_e ke^2 }} \)""",
        ),
      ],
      correctOptionId: "id_1",
    ),
    Quiz(
      statement: r"""<h3>Select the correct Chemical Balanced Equation.</h3>""",
      options: [
        QuizOption(
          "id_1",
          r"""\( \ce{CO + C -> 2 CO} \)""",
        ),
        QuizOption(
          "id_2",
          r"""\( \ce{CO2 + C ->  CO} \)""",
        ),
        QuizOption(
          "id_3",
          r"""\( \ce{CO + C ->  CO} \)""",
        ),
        QuizOption(
          "id_4",
          r"""\( \ce{CO2 + C -> 2 CO} \)""",
          isCorrect: true,
        ),
      ],
      correctOptionId: "id_4",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    Quiz currentQuiz = quizList[currentQuizIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("TeXView Quiz"),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Quiz ${currentQuizIndex + 1}/${quizList.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          TeXView(
            renderingEngine: widget.renderingEngine,
            child: TeXViewColumn(children: [
              TeXViewDocument(currentQuiz.statement,
                  style: const TeXViewStyle(
                      textAlign: TeXViewTextAlign.center,
                      padding: TeXViewPadding.all(16))),
              TeXViewGroup(
                selectedIds: currentQuiz.selectedOptionIds,
                children: currentQuiz.options.asMap().entries.map((entry) {
                  int optionIndex = entry.key;
                  QuizOption currentOption = entry.value;

                  bool shouldUseSelectedStyle = showAnswerResult
                      ? (currentOption.isCorrect ||
                          currentQuiz.selectedOptionIds
                              .contains(currentOption.id))
                      : currentQuiz.selectedOptionIds
                          .contains(currentOption.id);

                  return TeXViewGroupItem(
                    id: currentOption.id,
                    rippleEffect: false,
                    isSelected: shouldUseSelectedStyle,
                    normalStyle: QuizUIHelpers.getUnselectedOptionStyle(),
                    selectedStyle: QuizUIHelpers.getOptionStyleBasedOnState(
                        currentOption, currentQuiz, showAnswerResult),
                    onTap: !showAnswerResult
                        ? (selectedId) {
                            setState(() {
                              if (currentQuiz.selectedOptionIds
                                  .contains(selectedId)) {
                                currentQuiz.selectedOptionIds
                                    .remove(selectedId);
                              } else {
                                currentQuiz.selectedOptionIds.clear();
                                currentQuiz.selectedOptionIds.add(selectedId);
                              }
                            });
                          }
                        : null,
                    child: TeXViewDocument(
                        QuizUIHelpers.getOptionDisplayHtml(currentOption,
                            optionIndex, currentQuiz, showAnswerResult),
                        style:
                            const TeXViewStyle(padding: TeXViewPadding.all(0))),
                  );
                }).toList(),
              )
            ]),
            style: const TeXViewStyle(
              margin: TeXViewMargin.all(16),
              padding: TeXViewPadding.all(16),
              borderRadius: TeXViewBorderRadius.all(12),
              border: TeXViewBorder.all(
                TeXViewBorderDecoration(
                    borderColor: Colors.blue,
                    borderStyle: TeXViewBorderStyle.solid,
                    borderWidth: 2),
              ),
              backgroundColor: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: currentQuizIndex > 0
                      ? () {
                          setState(() {
                            currentQuizIndex--;
                            showAnswerResult = false;
                          });
                        }
                      : null,
                  child: const Text("Previous"),
                ),
                if (!showAnswerResult &&
                    currentQuiz.selectedOptionIds.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showAnswerResult = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Check Answer"),
                  ),
                if (showAnswerResult)
                  ElevatedButton(
                    onPressed: currentQuizIndex < quizList.length - 1
                        ? () {
                            setState(() {
                              currentQuizIndex++;
                              showAnswerResult = false;
                            });
                          }
                        : () {
                            // Quiz completed
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Quiz Completed!"),
                                content: const Text(
                                    "Congratulations! You've completed all questions."),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        currentQuizIndex = 0;
                                        showAnswerResult = false;
                                        for (var quiz in quizList) {
                                          quiz.selectedOptionIds.clear();
                                        }
                                      });
                                    },
                                    child: const Text("Restart Quiz"),
                                  ),
                                ],
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(currentQuizIndex < quizList.length - 1
                        ? "Next"
                        : "Finish"),
                  ),
              ],
            ),
          ),
          if (showAnswerResult)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: currentQuiz.selectedOptionIds
                          .contains(currentQuiz.correctOptionId)
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: currentQuiz.selectedOptionIds
                            .contains(currentQuiz.correctOptionId)
                        ? Colors.green
                        : Colors.red,
                    width: 1,
                  ),
                ),
                child: Text(
                  currentQuiz.selectedOptionIds
                          .contains(currentQuiz.correctOptionId)
                      ? "✅ Correct! Well done!"
                      : "❌ Incorrect. The correct answer is highlighted in green.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: currentQuiz.selectedOptionIds
                            .contains(currentQuiz.correctOptionId)
                        ? Colors.green.shade800
                        : Colors.red.shade800,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class QuizUIHelpers {
  static TeXViewStyle getUnselectedOptionStyle() => const TeXViewStyle(
        margin: TeXViewMargin.only(bottom: 12),
        padding: TeXViewPadding.all(16),
        borderRadius: TeXViewBorderRadius.all(12),
        border: TeXViewBorder.all(
          TeXViewBorderDecoration(
            borderColor: Color(0xFFE0E0E0),
            borderStyle: TeXViewBorderStyle.solid,
            borderWidth: 2,
          ),
        ),
      );

  static TeXViewStyle getOptionStyleBasedOnState(
    QuizOption option,
    Quiz currentQuiz,
    bool showAnswerResult,
  ) {
    if (!showAnswerResult) {
      return getSelectedButNotYetCheckedStyle();
    }

    bool isCorrectAnswer = option.isCorrect;
    bool isUserSelectedOption =
        currentQuiz.selectedOptionIds.contains(option.id);

    if (isCorrectAnswer && isUserSelectedOption) {
      return getCorrectAndSelectedStyle();
    } else if (isCorrectAnswer && !isUserSelectedOption) {
      return getCorrectButNotSelectedStyle();
    } else if (!isCorrectAnswer && isUserSelectedOption) {
      return getWrongAndSelectedStyle();
    } else {
      return getUnselectedOptionStyle();
    }
  }

  static TeXViewStyle getSelectedButNotYetCheckedStyle() {
    return const TeXViewStyle(
      margin: TeXViewMargin.only(bottom: 12),
      padding: TeXViewPadding.all(16),
      borderRadius: TeXViewBorderRadius.all(12),
      backgroundColor: Color(0xFFF3EAFF),
      border: TeXViewBorder.all(
        TeXViewBorderDecoration(
          borderColor: Color(0xFFF3EAFF),
          borderStyle: TeXViewBorderStyle.solid,
          borderWidth: 2,
        ),
      ),
    );
  }

  static TeXViewStyle getCorrectAndSelectedStyle() {
    return const TeXViewStyle(
      margin: TeXViewMargin.only(bottom: 12),
      padding: TeXViewPadding.all(16),
      borderRadius: TeXViewBorderRadius.all(12),
      backgroundColor: Color(0xFFE8F5E9),
      border: TeXViewBorder.all(
        TeXViewBorderDecoration(
          borderColor: Color(0xFFE8F5E9),
          borderStyle: TeXViewBorderStyle.solid,
          borderWidth: 2,
        ),
      ),
    );
  }

  static TeXViewStyle getCorrectButNotSelectedStyle() {
    return const TeXViewStyle(
      margin: TeXViewMargin.only(bottom: 12),
      padding: TeXViewPadding.all(16),
      borderRadius: TeXViewBorderRadius.all(12),
      backgroundColor: Color(0xFFFFFFFF),
      border: TeXViewBorder.all(
        TeXViewBorderDecoration(
          borderColor: Color(0xFF0DA45A),
          borderStyle: TeXViewBorderStyle.solid,
          borderWidth: 2,
        ),
      ),
    );
  }

  static TeXViewStyle getWrongAndSelectedStyle() {
    return const TeXViewStyle(
      margin: TeXViewMargin.only(bottom: 12),
      padding: TeXViewPadding.all(16),
      borderRadius: TeXViewBorderRadius.all(12),
      backgroundColor: Color(0xFFFFEBEE),
      border: TeXViewBorder.all(
        TeXViewBorderDecoration(
          borderColor: Color(0xFFFFEBEE),
          borderStyle: TeXViewBorderStyle.solid,
          borderWidth: 2,
        ),
      ),
    );
  }

  static String getOptionDisplayHtml(
    QuizOption option,
    int optionIndex,
    Quiz currentQuiz,
    bool showAnswerResult,
  ) {
    final optionLabel = String.fromCharCode(65 + optionIndex);
    final isUserSelectedOption =
        currentQuiz.selectedOptionIds.contains(option.id);

    String checkboxIconHtml =
        isUserSelectedOption ? IconConstant.selected : IconConstant.notSelected;

    if (showAnswerResult) {
      bool isCorrectAnswer = option.isCorrect;
      bool isUserSelectedOption =
          currentQuiz.selectedOptionIds.contains(option.id);

      if (isCorrectAnswer) {
        checkboxIconHtml = IconConstant.greenCheck;
      } else if (!isCorrectAnswer && isUserSelectedOption) {
        checkboxIconHtml = IconConstant.redCheck;
      } else {
        checkboxIconHtml = IconConstant.notSelected;
      }
    }

    return """
      <div style="display: flex; align-items: center; justify-content: space-between;">
        <div style="display: flex; align-items: center; flex: 1;">
          <span style="background-color: transparent; color: #333; padding: 2px 8px; border-radius: 20px; margin-right: 12px; font-weight: bold;">($optionLabel)</span>
          <span style="flex: 1;">${option.content}</span>
        </div>
        $checkboxIconHtml
      </div>
    """;
  }
}
