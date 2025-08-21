import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex/flutter_tex.dart';

class QuizResponse {
  final String message;
  final List<Quiz> questions;
  final int questionLength;
  final int totalQuestions;
  final int learnedCount;

  QuizResponse({
    required this.message,
    required this.questions,
    required this.questionLength,
    required this.totalQuestions,
    required this.learnedCount,
  });

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      message: json['message'] as String,
      questions:
          (json['questions'] as List).map((q) => Quiz.fromJson(q)).toList(),
      questionLength: json['questionLength'] as int,
      totalQuestions: json['totalQuestions'] as int,
      learnedCount: json['learnedCount'] as int,
    );
  }
}

class Quiz {
  final String id;
  final String questionText;
  final List<QuizOption> options;
  final String correctOptionId;
  final String? explanation;
  final String difficulty;
  final String questionType;
  final AssociatedTopic? associatedWithTopic;
  final AssociatedChapter? associatedWithChapter;
  final AssociatedSubject? associatedWithSubject;
  String? selectedOptionId;
  QuizState state;

  Quiz({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionId,
    this.explanation,
    required this.difficulty,
    required this.questionType,
    this.associatedWithTopic,
    this.associatedWithChapter,
    this.associatedWithSubject,
    this.selectedOptionId,
    this.state = QuizState.initial,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    List<QuizOption> options = [];
    String correctOptionId = '';

    // Parse options and find correct option
    if (json['options'] != null) {
      for (int i = 0; i < (json['options'] as List).length; i++) {
        var optionData = json['options'][i];
        String optionId = 'option_$i'; // Generate ID based on index

        QuizOption option = QuizOption(
          id: optionId,
          content: optionData['text'] as String,
          isCorrect: optionData['isCorrect'] as bool,
        );

        options.add(option);

        // Set correct option ID
        if (option.isCorrect) {
          correctOptionId = optionId;
        }
      }
    }

    return Quiz(
      id: json['_id'] as String,
      questionText: json['questionText'] as String,
      options: options,
      correctOptionId: correctOptionId,
      explanation: json['explanation'] as String?,
      difficulty: json['difficulty'] as String,
      questionType: json['questionType'] as String,
      associatedWithTopic: json['associatedWithTopic'] != null
          ? AssociatedTopic.fromJson(json['associatedWithTopic'])
          : null,
      associatedWithChapter: json['associatedWithChapter'] != null
          ? AssociatedChapter.fromJson(json['associatedWithChapter'])
          : null,
      associatedWithSubject: json['associatedWithSubject'] != null
          ? AssociatedSubject.fromJson(json['associatedWithSubject'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'questionText': questionText,
      'options': options.map((e) => e.toJson()).toList(),
      'correctOptionId': correctOptionId,
      'explanation': explanation,
      'difficulty': difficulty,
      'questionType': questionType,
    };
  }
}

enum QuizState { initial, checked, answered }

class QuizOption {
  final String id;
  final String content;
  final bool isCorrect;
  bool isSelected;
  TeXViewStyle? style;

  QuizOption({
    required this.id,
    required this.content,
    required this.isCorrect,
    this.isSelected = false,
    this.style,
  });

  factory QuizOption.fromJson(Map<String, dynamic> json) {
    return QuizOption(
      id: json['id'] as String,
      content: json['content'] as String,
      isCorrect: json['isCorrect'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isCorrect': isCorrect,
    };
  }
}

class AssociatedTopic {
  final String topicName;
  final String id;

  AssociatedTopic({
    required this.topicName,
    required this.id,
  });

  factory AssociatedTopic.fromJson(Map<String, dynamic> json) {
    return AssociatedTopic(
      topicName: json['topicName'] as String,
      id: json['_id'] as String,
    );
  }
}

class AssociatedChapter {
  final String chapterName;
  final String id;

  AssociatedChapter({
    required this.chapterName,
    required this.id,
  });

  factory AssociatedChapter.fromJson(Map<String, dynamic> json) {
    return AssociatedChapter(
      chapterName: json['chapterName'] as String,
      id: json['_id'] as String,
    );
  }
}

class AssociatedSubject {
  final String subjectName;
  final String id;

  AssociatedSubject({
    required this.subjectName,
    required this.id,
  });

  factory AssociatedSubject.fromJson(Map<String, dynamic> json) {
    return AssociatedSubject(
      subjectName: json['subjectName'] as String,
      id: json['_id'] as String,
    );
  }
}

class ModernTeXViewQuiz extends StatefulWidget {
  const ModernTeXViewQuiz({super.key});

  @override
  State<ModernTeXViewQuiz> createState() => _ModernTeXViewQuizState();
}

class _ModernTeXViewQuizState extends State<ModernTeXViewQuiz> {
  int currentQuizIndex = 0;
  String currentSelectedId = "";
  bool showResult = false;
  bool isCorrect = false;

  Future<List<Quiz>> loadQuizzes() async {
    final String response = await rootBundle.loadString('assets/quiz.json');
    final data = json.decode(response);
    final quizResponse = QuizResponse.fromJson(data);
    return quizResponse.questions;
  }

  List<Quiz> quizList = [];

  TeXViewStyle _getOptionStyle(QuizOption option) {
    if (showResult) {
      bool isCorrectOption = option.isCorrect;
      bool isSelectedOption = option.id == currentSelectedId;

      if (isCorrectOption) {
        return const TeXViewStyle(
          margin: TeXViewMargin.only(bottom: 12),
          padding: TeXViewPadding.all(16),
          borderRadius: TeXViewBorderRadius.all(12),
          backgroundColor: Color(0xFFE8F5E9),
          border: TeXViewBorder.all(
            TeXViewBorderDecoration(
              borderColor: Color(0xFF4CAF50),
              borderStyle: TeXViewBorderStyle.solid,
              borderWidth: 2,
            ),
          ),
        );
      } else if (isSelectedOption && !isCorrectOption) {
        return const TeXViewStyle(
          margin: TeXViewMargin.only(bottom: 12),
          padding: TeXViewPadding.all(16),
          borderRadius: TeXViewBorderRadius.all(12),
          backgroundColor: Color(0xFFFFEBEE),
          border: TeXViewBorder.all(
            TeXViewBorderDecoration(
              borderColor: Color(0xFFF44336),
              borderStyle: TeXViewBorderStyle.solid,
              borderWidth: 2,
            ),
          ),
        );
      }
    } else if (option.isSelected) {
      return const TeXViewStyle(
        margin: TeXViewMargin.only(bottom: 12),
        padding: TeXViewPadding.all(16),
        borderRadius: TeXViewBorderRadius.all(12),
        backgroundColor: Color(0xFFE8EAF6),
        border: TeXViewBorder.all(
          TeXViewBorderDecoration(
            borderColor: Color(0xFF7C4DFF),
            borderStyle: TeXViewBorderStyle.solid,
            borderWidth: 2,
          ),
        ),
      );
    }

    return const TeXViewStyle(
      margin: TeXViewMargin.only(bottom: 12),
      padding: TeXViewPadding.all(16),
      borderRadius: TeXViewBorderRadius.all(12),
      backgroundColor: Color(0xFFF5F5F5),
      border: TeXViewBorder.all(
        TeXViewBorderDecoration(
          borderColor: Color(0xFFE0E0E0),
          borderStyle: TeXViewBorderStyle.solid,
          borderWidth: 2,
        ),
      ),
    );
  }

  String _getOptionHtml(QuizOption option, int index) {
    // Generate dynamic label based on index (A, B, C, D, etc.)
    String label = String.fromCharCode(65 + index); // 65 is ASCII for 'A'

    String checkboxHtml = option.isSelected
        ? r"""<span style="display: inline-block; width: 20px; height: 20px; border: 2px solid #7C4DFF; border-radius: 20px; background-color: #7C4DFF; margin-left: 12px; vertical-align: middle; text-align: center; line-height: 16px;"><span style="color: white; font-size: 14px;">✓</span></span>"""
        : r"""<span style="display: inline-block; width: 20px; height: 20px; border: 2px solid #BDBDBD; border-radius: 4px; margin-left: 12px; vertical-align: middle;"></span>""";

    if (showResult) {
      bool isCorrectOption = option.isCorrect;
      bool isSelectedOption = option.id == currentSelectedId;

      if (isCorrectOption) {
        checkboxHtml =
            r"""<span style="display: inline-block; width: 20px; height: 20px; border: 2px solid #4CAF50; border-radius: 20px; background-color: #4CAF50; margin-left: 12px; vertical-align: middle; text-align: center; line-height: 16px;"><span style="color: white; font-size: 14px;">✓</span></span>""";
      } else if (isSelectedOption) {
        checkboxHtml =
            r"""<span style="display: inline-block; width: 20px; height: 20px; border: 2px solid #F44336; border-radius: 20px; background-color: #F44336; margin-left: 12px; vertical-align: middle; text-align: center; line-height: 16px;"><span style="color: white; font-size: 14px;">✗</span></span>""";
      }
    }

    return """
      <div style="display: flex; align-items: center; justify-content: space-between;">
        <div style="display: flex; align-items: center; flex: 1;">
          <span style="background-color: transparent; color: #333; padding: 2px 8px; border-radius: 20px; margin-right: 12px; font-weight: bold;">($label)</span>
          <span style="flex: 1;">${option.content}</span>
        </div>
        $checkboxHtml
      </div>
    """;
  }

  void _selectOption(String optionId) {
    if (!showResult) {
      setState(() {
        currentSelectedId = optionId;
        quizList[currentQuizIndex].selectedOptionId = optionId;
        for (var option in quizList[currentQuizIndex].options) {
          option.isSelected = option.id == optionId;
        }
      });
    }
  }

  void _checkAnswer() {
    if (currentSelectedId.isNotEmpty) {
      setState(() {
        showResult = true;
        isCorrect = quizList[currentQuizIndex]
            .options
            .firstWhere((option) => option.id == currentSelectedId)
            .isCorrect;
        quizList[currentQuizIndex].state = QuizState.checked;
      });
    }
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuizIndex < quizList.length - 1) {
        currentQuizIndex++;
        showResult = false;
        currentSelectedId = quizList[currentQuizIndex].selectedOptionId ?? "";
        for (var option in quizList[currentQuizIndex].options) {
          option.isSelected = option.id == currentSelectedId;
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initQuizList();
  }

  void _initQuizList() async {
    quizList = await loadQuizzes();
    setState(() {});
  }

  String _getTopicName() {
    if (quizList.isEmpty) return "Quiz";

    final currentQuiz = quizList[currentQuizIndex];
    if (currentQuiz.associatedWithTopic != null) {
      // Remove HTML tags from topic name
      String topicName = currentQuiz.associatedWithTopic!.topicName;
      topicName = topicName.replaceAll(RegExp(r'<[^>]*>'), '');
      return topicName;
    }
    return currentQuiz.associatedWithChapter?.chapterName ??
        currentQuiz.associatedWithSubject?.subjectName ??
        "Quiz";
  }

  @override
  Widget build(BuildContext context) {
    if (quizList.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    Quiz currentQuiz = quizList[currentQuizIndex];
    double progress = (currentQuizIndex + 1) / quizList.length;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _getTopicName(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {
                currentQuizIndex = 0;
                showResult = false;
                currentSelectedId = "";
                for (var quiz in quizList) {
                  quiz.selectedOptionId = null;
                  quiz.state = QuizState.initial;
                  for (var option in quiz.options) {
                    option.isSelected = false;
                  }
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${currentQuizIndex + 1}/${quizList.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 4,
                ),
              ],
            ),
          ),
          // Quiz Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: TeXView(
                fonts: [
                  TeXViewFont(
                    fontFamily: 'Lecture',
                    src: 'assets/fonts/Lecture.ttf',
                  ),
                ],
                style: const TeXViewStyle(
                  padding: TeXViewPadding.all(12),
                  borderRadius: TeXViewBorderRadius.all(12),
                  backgroundColor: Colors.white,
                ),
                child: TeXViewColumn(
                  children: [
                    // Question
                    TeXViewDocument(
                      currentQuiz.questionText,
                      style: const TeXViewStyle(
                        textAlign: TeXViewTextAlign.left,
                        padding: TeXViewPadding.only(top: 12, bottom: 12),
                      ),
                    ),
                    // Options
                    ...currentQuiz.options.map((option) {
                      return TeXViewInkWell(
                        id: option.id,
                        rippleEffect: false,
                        child: TeXViewDocument(
                          _getOptionHtml(
                              option, currentQuiz.options.indexOf(option)),
                          style: const TeXViewStyle(),
                        ),
                        style: _getOptionStyle(option),
                        onTap: (id) => _selectOption(id),
                      );
                    }).toList(),
                    // Show explanation after checking answer
                    // if (showResult && currentQuiz.explanation != null)
                    //   TeXViewDocument(
                    //     """
                    //     <div style="margin-top: 20px; padding: 16px; background-color: #E3F2FD; border-left: 4px solid #2196F3; border-radius: 8px;">
                    //       <strong style="color: #1976D2;">ব্যাখ্যা:</strong><br/>
                    //       ${currentQuiz.explanation}
                    //     </div>
                    //     """,
                    //     style: const TeXViewStyle(
                    //       padding: TeXViewPadding.only(top: 16),
                    //     ),
                    //   ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Button
          Container(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: showResult
                    ? (currentQuizIndex < quizList.length - 1
                        ? _nextQuestion
                        : null)
                    : (currentSelectedId.isNotEmpty ? _checkAnswer : null),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7C4DFF),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  showResult
                      ? (currentQuizIndex < quizList.length - 1
                          ? 'Next Question'
                          : 'Finish')
                      : 'Check',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
