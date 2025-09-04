import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex_example/icon_constant.dart';
import 'dart:convert';

import 'package:flutter_tex_example/katex_fonts.dart';

// JSON Model Classes
class QuestionResponse {
  final String message;
  final List<Question> questions;
  final int questionLength;
  final int totalQuestions;
  final int learnedCount;

  QuestionResponse({
    required this.message,
    required this.questions,
    required this.questionLength,
    required this.totalQuestions,
    required this.learnedCount,
  });

  factory QuestionResponse.fromJson(Map<String, dynamic> json) {
    return QuestionResponse(
      message: json['message'] ?? '',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => Question.fromJson(q))
              .toList() ??
          [],
      questionLength: json['questionLength'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      learnedCount: json['learnedCount'] ?? 0,
    );
  }
}

class Question {
  final String id;
  final String questionText;
  final List<QuestionOption> options;
  final String difficulty;
  final String questionType;
  final bool isPassage;
  final int questionCompositeFactor;
  final bool isActive;
  final bool isDeleted;
  final bool isLearnMode;
  final bool isTestMode;
  final int sequenceInTopic;
  final int sequenceInChapter;
  final int sequenceInSubject;
  final int sequenceInCourse;

  Question({
    required this.id,
    required this.questionText,
    required this.options,
    required this.difficulty,
    required this.questionType,
    required this.isPassage,
    required this.questionCompositeFactor,
    required this.isActive,
    required this.isDeleted,
    required this.isLearnMode,
    required this.isTestMode,
    required this.sequenceInTopic,
    required this.sequenceInChapter,
    required this.sequenceInSubject,
    required this.sequenceInCourse,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['_id'] ?? '',
      questionText: json['questionText'] ?? '',
      options: (json['options'] as List<dynamic>?)
              ?.map((o) => QuestionOption.fromJson(o))
              .toList() ??
          [],
      difficulty: json['difficulty'] ?? 'Medium',
      questionType: json['questionType'] ?? 'MCQ',
      isPassage: json['isPassage'] ?? false,
      questionCompositeFactor: json['questionCompositeFactor'] ?? 1,
      isActive: json['isActive'] ?? true,
      isDeleted: json['isDeleted'] ?? false,
      isLearnMode: json['isLearnMode'] ?? true,
      isTestMode: json['isTestMode'] ?? true,
      sequenceInTopic: json['sequenceInTopic'] ?? 0,
      sequenceInChapter: json['sequenceInChapter'] ?? 0,
      sequenceInSubject: json['sequenceInSubject'] ?? 0,
      sequenceInCourse: json['sequenceInCourse'] ?? 0,
    );
  }
}

class QuestionOption {
  final String text;
  final bool isCorrect;

  QuestionOption({
    required this.text,
    required this.isCorrect,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> json) {
    return QuestionOption(
      text: json['text'] ?? '',
      isCorrect: json['isCorrect'] ?? false,
    );
  }
}

// Original Quiz Models (for compatibility with existing UI)
class Quiz {
  final String statement;
  final List<QuizOption> options;
  final String correctOptionId;
  List<String> selectedOptionIds = [];

  Quiz({
    required this.statement,
    required this.options,
    required this.correctOptionId,
  });

  // Factory method to convert from Question to Quiz
  factory Quiz.fromQuestion(Question question) {
    List<QuizOption> quizOptions = [];
    String correctId = '';

    for (int i = 0; i < question.options.length; i++) {
      String optionId = 'option_${i + 1}';
      quizOptions.add(
        QuizOption(
          optionId,
          question.options[i].text,
          isCorrect: question.options[i].isCorrect,
        ),
      );
      if (question.options[i].isCorrect) {
        correctId = optionId;
      }
    }

    return Quiz(
      statement: question.questionText,
      options: quizOptions,
      correctOptionId: correctId,
    );
  }
}

class QuizOption {
  final String id;
  final String content;
  final bool isCorrect;

  QuizOption(this.id, this.content, {this.isCorrect = false});
}

class TeXViewQuizExample extends StatefulWidget {
  final TeXViewRenderingEngine renderingEngine;

  const TeXViewQuizExample({
    super.key,
    this.renderingEngine = const TeXViewRenderingEngine.katex(),
  });

  @override
  State<TeXViewQuizExample> createState() => _TeXViewQuizExampleState();
}

class _TeXViewQuizExampleState extends State<TeXViewQuizExample> {
  int currentQuizIndex = 0;
  bool showAnswerResult = false;
  List<Quiz> quizList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadQuizData();
  }

  Future<void> loadQuizData() async {
    try {
      // Simulate loading JSON data
      // In real app, this would be an HTTP request
      await Future.delayed(const Duration(seconds: 1));

      // Sample JSON string (you would get this from API)
      String jsonString = await getJsonString();

      Map<String, dynamic> jsonData = json.decode(jsonString);
      QuestionResponse response = QuestionResponse.fromJson(jsonData);

      // Convert Question objects to Quiz objects
      setState(() {
        quizList = response.questions
            .map((question) => Quiz.fromQuestion(question))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load quiz data: $e';
        isLoading = false;
      });
    }
  }

  // This would be replaced with actual API response
  Future<String> getJsonString() async {
    // For testing with English
    // return await rootBundle.loadString('assets/data/quiz_questions_sample.json');

    // For production with Bengali
    return await rootBundle.loadString('assets/data/quiz_questions.json');
  }

  @override
  Widget build(BuildContext context) {
    print("Rebuilding TeXViewQuizExample");
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("TeXView Quiz")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("TeXView Quiz")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 60, color: Colors.red),
              const SizedBox(height: 16),
              Text(errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  loadQuizData();
                },
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    if (quizList.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("TeXView Quiz")),
        body: const Center(child: Text("No quiz questions available")),
      );
    }

    Quiz currentQuiz = quizList[currentQuizIndex];

    return Scaffold(
      backgroundColor: Color(0xFFF7FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("TeXView Quiz"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                isLoading = true;
                currentQuizIndex = 0;
                showAnswerResult = false;
                for (var quiz in quizList) {
                  quiz.selectedOptionIds.clear();
                }
              });
              loadQuizData();
            },
          ),
        ],
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: <Widget>[
          ColoredBox(
            color: Colors.white,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Quiz ${currentQuizIndex + 1}/${quizList.length}',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    borderRadius: BorderRadius.circular(10),
                    minHeight: 8,
                    value: quizList.isEmpty
                        ? 0
                        : (currentQuizIndex + 1) / quizList.length,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.cyan,
                    ),
                  ),
                ),

                //percentage
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    quizList.isEmpty
                        ? '0%'
                        : '${(((currentQuizIndex + 1) / quizList.length) * 100).floor()}%',
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          TeXView(
            fonts: teXViewFontList,
            renderingEngine: widget.renderingEngine,
            child: TeXViewColumn(children: [
              TeXViewDocument(currentQuiz.statement,
                  style: const TeXViewStyle(
                      textAlign: TeXViewTextAlign.center,
                      padding: TeXViewPadding.all(16))),
              TeXViewGroup(
                selectedIds: currentQuiz.selectedOptionIds,
                children: currentQuiz.options.asMap().entries.map((entry) {
                  final option = entry.value;
                  final index = entry.key;

                  // Determine if this option should be shown as selected
                  bool shouldUseSelectedStyle = showAnswerResult
                      ? (option.isCorrect ||
                          currentQuiz.selectedOptionIds.contains(option.id))
                      : currentQuiz.selectedOptionIds.contains(option.id);

                  return TeXViewGroupItem(
                    id: option.id,
                    rippleEffect: false,
                    isSelected: shouldUseSelectedStyle,
                    normalStyle: QuizUIHelpers.getUnselectedOptionStyle(),
                    selectedStyle: QuizUIHelpers.getOptionStyleBasedOnState(
                      option,
                      currentQuiz,
                      showAnswerResult,
                    ),
                    onTap: !showAnswerResult
                        ? (selectedId) {
                            setState(() {
                              if (currentQuiz.selectedOptionIds
                                  .contains(selectedId)) {
                                currentQuiz.selectedOptionIds
                                    .remove(selectedId);
                              } else {
                                // currentQuiz.selectedOptionIds.clear();
                                currentQuiz.selectedOptionIds.add(selectedId);
                              }
                            });
                          }
                        : null,
                    child: TeXViewDocument(
                      QuizUIHelpers.getOptionDisplayHtml(
                          option, index, currentQuiz, showAnswerResult),
                      style: const TeXViewStyle(padding: TeXViewPadding.all(0)),
                    ),
                  );
                }).toList(),
              ),
              // TeXViewGroup(
              //   selectedIds: currentQuiz.selectedOptionIds,
              //   children: currentQuiz.options.asMap().entries.map((entry) {
              //     int optionIndex = entry.key;
              //     QuizOption currentOption = entry.value;

              //     bool shouldUseSelectedStyle = showAnswerResult
              //         ? (currentOption.isCorrect ||
              //             currentQuiz.selectedOptionIds
              //                 .contains(currentOption.id))
              //         : currentQuiz.selectedOptionIds
              //             .contains(currentOption.id);

              //     return TeXViewGroupItem(
              //       id: currentOption.id,
              //       rippleEffect: false,
              //       isSelected: shouldUseSelectedStyle,
              //       normalStyle: QuizUIHelpers.getUnselectedOptionStyle(),
              //       selectedStyle: QuizUIHelpers.getOptionStyleBasedOnState(
              //           currentOption, currentQuiz, showAnswerResult),
              //       onTap: !showAnswerResult
              //           ? (selectedId) {
              //               setState(() {
              //                 if (currentQuiz.selectedOptionIds
              //                     .contains(selectedId)) {
              //                   currentQuiz.selectedOptionIds
              //                       .remove(selectedId);
              //                 } else {
              //                   currentQuiz.selectedOptionIds.clear();
              //                   currentQuiz.selectedOptionIds.add(selectedId);
              //                 }
              //               });
              //             }
              //           : null,
              //       child: TeXViewDocument(
              //           QuizUIHelpers.getOptionDisplayHtml(currentOption,
              //               optionIndex, currentQuiz, showAnswerResult),
              //           style:
              //               const TeXViewStyle(padding: TeXViewPadding.all(0))),
              //     );
              //   }).toList(),
              // )
            ]),
            style: const TeXViewStyle(
              margin: TeXViewMargin.all(16),
              padding: TeXViewPadding.all(12),
              borderRadius: TeXViewBorderRadius.all(12),
              border: TeXViewBorder.all(
                TeXViewBorderDecoration(
                    // borderColor: Colors.blue,
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
