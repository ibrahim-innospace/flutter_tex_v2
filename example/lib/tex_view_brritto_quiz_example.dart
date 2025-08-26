import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tex_v2/flutter_tex.dart';
import './custom_widget.dart';

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
  final List<String>
      correctOptionIds; // Changed to List for multiple correct answers
  final String? explanation;
  final String difficulty;
  final String questionType;
  final AssociatedTopic? associatedWithTopic;
  final AssociatedChapter? associatedWithChapter;
  final AssociatedSubject? associatedWithSubject;
  List<String> selectedOptionIds; // Changed to List for multiple selections
  QuizState state;

  Quiz({
    required this.id,
    required this.questionText,
    required this.options,
    required this.correctOptionIds,
    this.explanation,
    required this.difficulty,
    required this.questionType,
    this.associatedWithTopic,
    this.associatedWithChapter,
    this.associatedWithSubject,
    List<String>? selectedOptionIds,
    this.state = QuizState.initial,
  }) : selectedOptionIds = selectedOptionIds ?? [];

  factory Quiz.fromJson(Map<String, dynamic> json) {
    List<QuizOption> options = [];
    List<String> correctOptionIds = [];

    // Parse options and find correct options
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

        // Add to correct option IDs list if correct
        if (option.isCorrect) {
          correctOptionIds.add(optionId);
        }
      }
    }

    return Quiz(
      id: json['_id'] as String,
      questionText: json['questionText'] as String,
      options: options,
      correctOptionIds: correctOptionIds,
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
      'correctOptionIds': correctOptionIds,
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
  bool showResult = false;

  Future<List<Quiz>> loadQuizzes() async {
    final String response = await rootBundle.loadString('assets/quiz.json');
    final data = json.decode(response);
    final quizResponse = QuizResponse.fromJson(data);
    return quizResponse.questions;
  }

  List<Quiz> quizList = [];

  TeXViewStyle _getOptionStyle(QuizOption option) {
    final currentQuiz = quizList[currentQuizIndex];
    bool isSelected = currentQuiz.selectedOptionIds.contains(option.id);

    if (showResult) {
      bool isCorrectOption = option.isCorrect;
      bool isSelectedOption = currentQuiz.selectedOptionIds.contains(option.id);

      if (isCorrectOption && isSelectedOption) {
        // Correctly selected
        return const TeXViewStyle(
          margin: TeXViewMargin.only(bottom: 12),
          padding: TeXViewPadding.all(16),
          borderRadius: TeXViewBorderRadius.all(12),
          backgroundColor: Color(0xFFE8F5E9),
          border: TeXViewBorder.all(
            TeXViewBorderDecoration(
              borderColor: Color(0xFFE8F5E9),
              borderStyle: TeXViewBorderStyle.solid,
              borderWidth: 1,
            ),
          ),
        );
      } else if (isCorrectOption && !isSelectedOption) {
        // Correct but not selected (missed)
        return const TeXViewStyle(
          margin: TeXViewMargin.only(bottom: 12),
          padding: TeXViewPadding.all(16),
          borderRadius: TeXViewBorderRadius.all(12),
          backgroundColor: Color(0xFFFFFFFF),
          border: TeXViewBorder.all(
            TeXViewBorderDecoration(
              borderColor: Color(0xFF4CAF50),
              borderStyle: TeXViewBorderStyle.solid,
              borderWidth: 1,
            ),
          ),
        );
      } else if (!isCorrectOption && isSelectedOption) {
        // Incorrectly selected
        return const TeXViewStyle(
          margin: TeXViewMargin.only(bottom: 12),
          padding: TeXViewPadding.all(16),
          borderRadius: TeXViewBorderRadius.all(12),
          backgroundColor: Color(0xFFFFEBEE),
          border: TeXViewBorder.all(
            TeXViewBorderDecoration(
              borderColor: Color(0xFFFFEBEE),
              borderStyle: TeXViewBorderStyle.solid,
              borderWidth: 1,
            ),
          ),
        );
      }
    } else if (isSelected) {
      return const TeXViewStyle(
        margin: TeXViewMargin.only(bottom: 12),
        padding: TeXViewPadding.all(16),
        borderRadius: TeXViewBorderRadius.all(12),
        backgroundColor: Color(0xFFF3EAFF),
        border: TeXViewBorder.all(
          TeXViewBorderDecoration(
            borderColor: Color(0xFFF3EAFF),
            borderStyle: TeXViewBorderStyle.solid,
            borderWidth: 1,
          ),
        ),
      );
    }

    return const TeXViewStyle(
      margin: TeXViewMargin.only(bottom: 12),
      padding: TeXViewPadding.all(16),
      borderRadius: TeXViewBorderRadius.all(12),
      border: TeXViewBorder.all(
        TeXViewBorderDecoration(
          borderColor: Color(0xFFE0E0E0),
          borderStyle: TeXViewBorderStyle.solid,
          borderWidth: 1,
        ),
      ),
    );
  }

  String _getOptionHtml(QuizOption option, int index) {
    final currentQuiz = quizList[currentQuizIndex];
    bool isSelected = currentQuiz.selectedOptionIds.contains(option.id);

    // Generate dynamic label based on index (A, B, C, D, etc.)
    String label = String.fromCharCode(65 + index); // 65 is ASCII for 'A'

    String checkboxHtml = isSelected
        ? r"""<img width="20px" height="20px" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIHZpZXdCb3g9IjAgMCAxOCAxOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTcuNiAxMC43NDYzTDUuMjc3IDguNDIzQzUuMTM4NSA4LjI4NDY3IDQuOTY0NDIgOC4yMTM4MyA0Ljc1NDc1IDguMjEwNUM0LjU0NTI1IDguMjA3MzMgNC4zNjggOC4yNzgxNyA0LjIyMyA4LjQyM0M0LjA3ODE3IDguNTY4IDQuMDA1NzUgOC43NDM2NyA0LjAwNTc1IDguOTVDNC4wMDU3NSA5LjE1NjMzIDQuMDc4MTcgOS4zMzIgNC4yMjMgOS40NzdMNi45NjcyNSAxMi4yMjEzQzcuMTQ4MDggMTIuNDAxOSA3LjM1OSAxMi40OTIzIDcuNiAxMi40OTIzQzcuODQxIDEyLjQ5MjMgOC4wNTE5MiAxMi40MDE5IDguMjMyNzUgMTIuMjIxM0wxMy43OTYyIDYuNjU3NzVDMTMuOTM0NiA2LjUxOTI1IDE0LjAwNTQgNi4zNDUxNyAxNC4wMDg3IDYuMTM1NUMxNC4wMTE5IDUuOTI2IDEzLjk0MTEgNS43NDg3NSAxMy43OTYyIDUuNjAzNzVDMTMuNjUxMiA1LjQ1ODkyIDEzLjQ3NTYgNS4zODY1IDEzLjI2OTMgNS4zODY1QzEzLjA2MjkgNS4zODY1IDEyLjg4NzMgNS40NTg5MiAxMi43NDIzIDUuNjAzNzVMNy42IDEwLjc0NjNaTTIuMzA3NzUgMTcuNUMxLjgwMjU4IDE3LjUgMS4zNzUgMTcuMzI1IDEuMDI1IDE2Ljk3NUMwLjY3NSAxNi42MjUgMC41IDE2LjE5NzQgMC41IDE1LjY5MjNWMi4zMDc3NUMwLjUgMS44MDI1OCAwLjY3NSAxLjM3NSAxLjAyNSAxLjAyNUMxLjM3NSAwLjY3NSAxLjgwMjU4IDAuNSAyLjMwNzc1IDAuNUgxNS42OTIzQzE2LjE5NzQgMC41IDE2LjYyNSAwLjY3NSAxNi45NzUgMS4wMjVDMTcuMzI1IDEuMzc1IDE3LjUgMS44MDI1OCAxNy41IDIuMzA3NzVWMTUuNjkyM0MxNy41IDE2LjE5NzQgMTcuMzI1IDE2LjYyNSAxNi45NzUgMTYuOTc1QzE2LjYyNSAxNy4zMjUgMTYuMTk3NCAxNy41IDE1LjY5MjMgMTcuNUgyLjMwNzc1WiIgZmlsbD0iIzc5MjlFNyIvPgo8L3N2Zz4K" alt="Selected"/>"""
        : r"""<img width="20px" height="20px" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIHZpZXdCb3g9IjAgMCAxOCAxOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTIuMzA3NzUgMTcuNUMxLjgwMjU4IDE3LjUgMS4zNzUgMTcuMzI1IDEuMDI1IDE2Ljk3NUMwLjY3NSAxNi42MjUgMC41IDE2LjE5NzQgMC41IDE1LjY5MjNWMi4zMDc3NUMwLjUgMS44MDI1OCAwLjY3NSAxLjM3NSAxLjAyNSAxLjAyNUMxLjM3NSAwLjY3NSAxLjgwMjU4IDAuNSAyLjMwNzc1IDAuNUgxNS42OTIzQzE2LjE5NzQgMC41IDE2LjYyNSAwLjY3NSAxNi45NzUgMS4wMjVDMTcuMzI1IDEuMzc1IDE3LjUgMS44MDI1OCAxNy41IDIuMzA3NzVWMTUuNjkyM0MxNy41IDE2LjE5NzQgMTcuMzI1IDE2LjYyNSAxNi45NzUgMTYuOTc1QzE2LjYyNSAxNy4zMjUgMTYuMTk3NCAxNy41IDE1LjY5MjMgMTcuNUgyLjMwNzc1Wk0yLjMwNzc1IDE2SDE1LjY5MjNDMTUuNzY5MiAxNiAxNS44Mzk4IDE1Ljk2NzkgMTUuOTAzOCAxNS45MDM4QzE1Ljk2NzkgMTUuODM5OCAxNiAxNS43NjkyIDE2IDE1LjY5MjNWMi4zMDc3NUMxNiAyLjIzMDc1IDE1Ljk2NzkgMi4xNjAyNSAxNS45MDM4IDIuMDk2MjVDMTUuODM5OCAyLjAzMjA4IDE1Ljc2OTIgMiAxNS42OTIzIDJIMi4zMDc3NUMyLjIzMDc1IDIgMi4xNjAyNSAyLjAzMjA4IDIuMDk2MjUgMi4wOTYyNUMyLjAzMjA4IDIuMTYwMjUgMiAyLjIzMDc1IDIgMi4zMDc3NVYxNS42OTIzQzIgMTUuNzY5MiAyLjAzMjA4IDE1LjgzOTggMi4wOTYyNSAxNS45MDM4QzIuMTYwMjUgMTUuOTY3OSAyLjIzMDc1IDE2IDIuMzA3NzUgMTZaIiBmaWxsPSIjQURCNUJEIi8+Cjwvc3ZnPgo=" alt="Not Selected"/>""";

    if (showResult) {
      bool isCorrectOption = option.isCorrect;
      bool isSelectedOption = currentQuiz.selectedOptionIds.contains(option.id);

      if (isCorrectOption) {
        // Correctly selected
        checkboxHtml =
            """<img width="20px" height="20px" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHZpZXdCb3g9IjAgMCAyMCAyMCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguNTgwNzUgMTIuMTQ2M0w2LjI1Nzc1IDkuODIzQzYuMTE5MjUgOS42ODQ2NyA1Ljk0NTE3IDkuNjEzODMgNS43MzU1IDkuNjEwNUM1LjUyNiA5LjYwNzMzIDUuMzQ4NzUgOS42NzgxNyA1LjIwMzc1IDkuODIzQzUuMDU4OTIgOS45NjggNC45ODY1IDEwLjE0MzcgNC45ODY1IDEwLjM1QzQuOTg2NSAxMC41NTYzIDUuMDU4OTIgMTAuNzMyIDUuMjAzNzUgMTAuODc3TDcuOTQ4IDEzLjYyMTJDOC4xMjg4MyAxMy44MDE5IDguMzM5NzUgMTMuODkyMyA4LjU4MDc1IDEzLjg5MjNDOC44MjE3NSAxMy44OTIzIDkuMDMyNjcgMTMuODAxOSA5LjIxMzUgMTMuNjIxMkwxNC43NzcgOC4wNTc3NUMxNC45MTUzIDcuOTE5MjUgMTQuOTg2MiA3Ljc0NTE3IDE0Ljk4OTUgNy41MzU1QzE0Ljk5MjcgNy4zMjYgMTQuOTIxOCA3LjE0ODc1IDE0Ljc3NyA3LjAwMzc1QzE0LjYzMiA2Ljg1ODkyIDE0LjQ1NjMgNi43ODY1IDE0LjI1IDYuNzg2NUMxNC4wNDM3IDYuNzg2NSAxMy44NjggNi44NTg5MiAxMy43MjMgNy4wMDM3NUw4LjU4MDc1IDEyLjE0NjNaTTEwLjAwMTcgMTkuNUM4LjY4Nzc1IDE5LjUgNy40NTI2NyAxOS4yNTA3IDYuMjk2NSAxOC43NTJDNS4xNDAzMyAxOC4yNTMzIDQuMTM0NjcgMTcuNTc2NiAzLjI3OTUgMTYuNzIxOEMyLjQyNDMzIDE1Ljg2NjkgMS43NDcyNSAxNC44NjE3IDEuMjQ4MjUgMTMuNzA2QzAuNzQ5NDE3IDEyLjU1MDMgMC41IDExLjMxNTYgMC41IDEwLjAwMTdDMC41IDguNjg3NzUgMC43NDkzMzMgNy40NTI2NyAxLjI0OCA2LjI5NjVDMS43NDY2NyA1LjE0MDMzIDIuNDIzNDIgNC4xMzQ2NyAzLjI3ODI1IDMuMjc5NUM0LjEzMzA4IDIuNDI0MzMgNS4xMzgzMyAxLjc0NzI1IDYuMjk0IDEuMjQ4MjVDNy40NDk2NyAwLjc0OTQxNyA4LjY4NDQyIDAuNSA5Ljk5ODI1IDAuNUMxMS4zMTIzIDAuNSAxMi41NDczIDAuNzQ5MzMzIDEzLjcwMzUgMS4yNDhDMTQuODU5NyAxLjc0NjY3IDE1Ljg2NTMgMi40MjM0MiAxNi43MjA1IDMuMjc4MjVDMTcuNTc1NyA0LjEzMzA4IDE4LjI1MjggNS4xMzgzMyAxOC43NTE4IDYuMjk0QzE5LjI1MDYgNy40NDk2NyAxOS41IDguNjg0NDIgMTkuNSA5Ljk5ODI1QzE5LjUgMTEuMzEyMyAxOS4yNTA3IDEyLjU0NzMgMTguNzUyIDEzLjcwMzVDMTguMjUzMyAxNC44NTk3IDE3LjU3NjYgMTUuODY1MyAxNi43MjE4IDE2LjcyMDVDMTUuODY2OSAxNy41NzU3IDE0Ljg2MTcgMTguMjUyOCAxMy43MDYgMTguNzUxOEMxMi41NTAzIDE5LjI1MDYgMTEuMzE1NiAxOS41IDEwLjAwMTcgMTkuNVoiIGZpbGw9IiMwREE0NUEiLz4KPC9zdmc+Cg==" alt="Correct" />""";
      } else if (!isCorrectOption && isSelectedOption) {
        // Incorrectly selected
        checkboxHtml =
            """<img width="20px" height="20px" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHZpZXdCb3g9IjAgMCAyMCAyMCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEwIDExLjA1MzhMMTMuMDczIDE0LjEyN0MxMy4yMTE1IDE0LjI2NTMgMTMuMzg1NiAxNC4zMzYyIDEzLjU5NTMgMTQuMzM5NUMxMy44MDQ4IDE0LjM0MjcgMTMuOTgyIDE0LjI3MTggMTQuMTI3IDE0LjEyN0MxNC4yNzE4IDEzLjk4MiAxNC4zNDQzIDEzLjgwNjMgMTQuMzQ0MyAxMy42QzE0LjM0NDMgMTMuMzkzNyAxNC4yNzE4IDEzLjIxOCAxNC4xMjcgMTMuMDczTDExLjA1MzggMTBMMTQuMTI3IDYuOTI3QzE0LjI2NTMgNi43ODg1IDE0LjMzNjIgNi42MTQ0MiAxNC4zMzk1IDYuNDA0NzVDMTQuMzQyNyA2LjE5NTI1IDE0LjI3MTggNi4wMTggMTQuMTI3IDUuODczQzEzLjk4MiA1LjcyODE3IDEzLjgwNjMgNS42NTU3NSAxMy42IDUuNjU1NzVDMTMuMzkzNyA1LjY1NTc1IDEzLjIxOCA1LjcyODE3IDEzLjA3MyA1Ljg3M0wxMCA4Ljk0NjI1TDYuOTI3IDUuODczQzYuNzg4NSA1LjczNDY3IDYuNjE0NDIgNS42NjM4MyA2LjQwNDc1IDUuNjYwNUM2LjE5NTI1IDUuNjU3MzMgNi4wMTggNS43MjgxNyA1Ljg3MyA1Ljg3M0M1LjcyODE3IDYuMDE4IDUuNjU1NzUgNi4xOTM2NyA1LjY1NTc1IDYuNEM1LjY1NTc1IDYuNjA2MzMgNS43MjgxNyA2Ljc4MiA1Ljg3MyA2LjkyN0w4Ljk0NjI1IDEwTDUuODczIDEzLjA3M0M1LjczNDY3IDEzLjIxMTUgNS42NjM4MyAxMy4zODU2IDUuNjYwNSAxMy41OTUzQzUuNjU3MzMgMTMuODA0OCA1LjcyODE3IDEzLjk4MiA1Ljg3MyAxNC4xMjdDNi4wMTggMTQuMjcxOCA2LjE5MzY3IDE0LjM0NDMgNi40IDE0LjM0NDNDNi42MDYzMyAxNC4zNDQzIDYuNzgyIDE0LjI3MTggNi45MjcgMTQuMTI3TDEwIDExLjA1MzhaTTEwLjAwMTcgMTkuNUM4LjY4Nzc1IDE5LjUgNy40NTI2NyAxOS4yNTA3IDYuMjk2NSAxOC43NTJDNS4xNDAzMyAxOC4yNTMzIDQuMTM0NjcgMTcuNTc2NiAzLjI3OTUgMTYuNzIxOEMyLjQyNDMzIDE1Ljg2NjkgMS43NDcyNSAxNC44NjE3IDEuMjQ4MjUgMTMuNzA2QzAuNzQ5NDE3IDEyLjU1MDMgMC41IDExLjMxNTYgMC41IDEwLjAwMTdDMC41IDguNjg3NzUgMC43NDkzMzMgNy40NTI2NyAxLjI0OCA2LjI5NjVDMS43NDY2NyA1LjE0MDMzIDIuNDIzNDIgNC4xMzQ2NyAzLjI3ODI1IDMuMjc5NUM0LjEzMzA4IDIuNDI0MzMgNS4xMzgzMyAxLjc0NzI1IDYuMjk0IDEuMjQ4MjVDNy40NDk2NyAwLjc0OTQxNyA4LjY4NDQyIDAuNSA5Ljk5ODI1IDAuNUMxMS4zMTIzIDAuNSAxMi41NDczIDAuNzQ5MzMzIDEzLjcwMzUgMS4yNDhDMTQuODU5NyAxLjc0NjY3IDE1Ljg2NTMgMi40MjM0MiAxNi43MjA1IDMuMjc4MjVDMTcuNTc1NyA0LjEzMzA4IDE4LjI1MjggNS4xMzgzMyAxOC43NTE4IDYuMjk0QzE5LjI1MDYgNy40NDk2NyAxOS41IDguNjg0NDIgMTkuNSA5Ljk5ODI1QzE5LjUgMTEuMzEyMyAxOS4yNTA3IDEyLjU0NzMgMTguNzUyIDEzLjcwMzVDMTguMjUzMyAxNC44NTk3IDE3LjU3NjYgMTUuODY1MyAxNi43MjE4IDE2LjcyMDVDMTUuODY2OSAxNy41NzU3IDE0Ljg2MTcgMTguMjUyOCAxMy43MDYgMTguNzUxOEMxMi41NTAzIDE5LjI1MDYgMTEuMzE1NiAxOS41IDEwLjAwMTcgMTkuNVoiIGZpbGw9IiNEQTNFMzMiLz4KPC9zdmc+Cg==" alt="Wrong" />""";
      } else {
        // Not selected and not correct
        checkboxHtml =
            r"""<img width="20px" height="20px" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIHZpZXdCb3g9IjAgMCAxOCAxOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTIuMzA3NzUgMTcuNUMxLjgwMjU4IDE3LjUgMS4zNzUgMTcuMzI1IDEuMDI1IDE2Ljk3NUMwLjY3NSAxNi42MjUgMC41IDE2LjE5NzQgMC41IDE1LjY5MjNWMi4zMDc3NUMwLjUgMS44MDI1OCAwLjY3NSAxLjM3NSAxLjAyNSAxLjAyNUMxLjM3NSAwLjY3NSAxLjgwMjU4IDAuNSAyLjMwNzc1IDAuNUgxNS42OTIzQzE2LjE5NzQgMC41IDE2LjYyNSAwLjY3NSAxNi45NzUgMS4wMjVDMTcuMzI1IDEuMzc1IDE3LjUgMS44MDI1OCAxNy41IDIuMzA3NzVWMTUuNjkyM0MxNy41IDE2LjE5NzQgMTcuMzI1IDE2LjYyNSAxNi45NzUgMTYuOTc1QzE2LjYyNSAxNy4zMjUgMTYuMTk3NCAxNy41IDE1LjY5MjMgMTcuNUgyLjMwNzc1Wk0yLjMwNzc1IDE2SDE1LjY5MjNDMTUuNzY5MiAxNiAxNS44Mzk4IDE1Ljk2NzkgMTUuOTAzOCAxNS45MDM4QzE1Ljk2NzkgMTUuODM5OCAxNiAxNS43NjkyIDE2IDE1LjY5MjNWMi4zMDc3NUMxNiAyLjIzMDc1IDE1Ljk2NzkgMi4xNjAyNSAxNS45MDM4IDIuMDk2MjVDMTUuODM5OCAyLjAzMjA4IDE1Ljc2OTIgMiAxNS42OTIzIDJIMi4zMDc3NUMyLjIzMDc1IDIgMi4xNjAyNSAyLjAzMjA4IDIuMDk2MjUgMi4wOTYyNUMyLjAzMjA4IDIuMTYwMjUgMiAyLjIzMDc1IDIgMi4zMDc3NVYxNS42OTIzQzIgMTUuNzY5MiAyLjAzMjA4IDE1LjgzOTggMi4wOTYyNSAxNS45MDM4QzIuMTYwMjUgMTUuOTY3OSAyLjIzMDc1IDE2IDIuMzA3NzUgMTZaIiBmaWxsPSIjQURCNUJEIi8+Cjwvc3ZnPgo=" alt="Not Selected"/>""";
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
    print("Selected option: $optionId");
    if (!showResult) {
      setState(() {
        final currentQuiz = quizList[currentQuizIndex];

        // Toggle selection
        if (currentQuiz.selectedOptionIds.contains(optionId)) {
          currentQuiz.selectedOptionIds.remove(optionId);
        } else {
          currentQuiz.selectedOptionIds.add(optionId);
        }

        // Update isSelected property for each option
        for (var option in currentQuiz.options) {
          option.isSelected = currentQuiz.selectedOptionIds.contains(option.id);
        }
      });
    }
  }

  void _checkAnswer() {
    final currentQuiz = quizList[currentQuizIndex];

    if (currentQuiz.selectedOptionIds.isNotEmpty) {
      setState(() {
        showResult = true;
        currentQuiz.state = QuizState.checked;
      });
    }
  }

  void _nextQuestion() {
    setState(() {
      if (currentQuizIndex < quizList.length - 1) {
        currentQuizIndex++;
        showResult = false;

        // Set the selected options for the next question
        final nextQuiz = quizList[currentQuizIndex];
        for (var option in nextQuiz.options) {
          option.isSelected = nextQuiz.selectedOptionIds.contains(option.id);
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
            icon: const Icon(Icons.refresh, color: Colors.black),
            onPressed: () {
              setState(() {
                currentQuizIndex = 0;
                showResult = false;
                for (var quiz in quizList) {
                  quiz.selectedOptionIds = [];
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
      persistentFooterButtons: [
        // Bottom Button
        Container(
          margin: const EdgeInsets.all(0),
          // color: Colors.white,
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: SizedBox(
              width: double.infinity,
              height: 50,
              child: AnimatedButton(
                  width: double.infinity,
                  borderRadius: 8,
                  height: 50,
                  gradientColors: const [
                    Color(0xFF852DFE),
                    Color(0xFFAD72FE),
                  ],
                  child: Text(
                    showResult
                        ? (currentQuizIndex < quizList.length - 1
                            ? 'Next Question'
                            : 'Finish')
                        : 'Check',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () {
                    showResult
                        ? (currentQuizIndex < quizList.length - 1
                            ? _nextQuestion()
                            : null)
                        : (currentQuiz.selectedOptionIds.isNotEmpty
                            ? _checkAnswer()
                            : null);
                  })),
        ),
      ],
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
                        padding: TeXViewPadding.only(top: 12, bottom: 24),
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
                    if (showResult && currentQuiz.explanation != null)
                      TeXViewDocument(
                        """
                        <div style="margin-top: 20px; padding: 16px; background-color: #E3F2FD; border-left: 4px solid #2196F3; border-radius: 8px;">
                          <strong style="color: #1976D2;">Explanation:</strong><br/>
                          ${currentQuiz.explanation}
                        </div>
                        """,
                        style: const TeXViewStyle(
                          padding: TeXViewPadding.only(top: 16),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
