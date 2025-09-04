import 'package:flutter_tex/flutter_tex.dart';

class QuizResponse {
  final String message;
  final List<Quiz> questions;
  final int questionLength;
  final int totalQuestions;
  final int learnedCount;

  const QuizResponse({
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
  final List<String> correctOptionIds;
  final String? explanation;
  final String difficulty;
  final String questionType;
  final AssociatedTopic? associatedWithTopic;
  final AssociatedChapter? associatedWithChapter;
  final AssociatedSubject? associatedWithSubject;
  final List<String> selectedOptionIds;
  final QuizState state;

  const Quiz({
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
    this.selectedOptionIds = const [],
    this.state = QuizState.initial,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final options = <QuizOption>[];
    final correctOptionIds = <String>[];

    if (json['options'] != null) {
      final optionsList = json['options'] as List;
      for (int i = 0; i < optionsList.length; i++) {
        final optionData = optionsList[i];
        final optionId = 'option_$i';

        final option = QuizOption(
          id: optionId,
          content: optionData['text'] as String,
          isCorrect: optionData['isCorrect'] as bool,
        );

        options.add(option);

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

  Quiz copyWith({
    List<String>? selectedOptionIds,
    QuizState? state,
    List<QuizOption>? options,
  }) {
    return Quiz(
      id: id,
      questionText: questionText,
      options: options ?? this.options,
      correctOptionIds: correctOptionIds,
      explanation: explanation,
      difficulty: difficulty,
      questionType: questionType,
      associatedWithTopic: associatedWithTopic,
      associatedWithChapter: associatedWithChapter,
      associatedWithSubject: associatedWithSubject,
      selectedOptionIds: selectedOptionIds ?? this.selectedOptionIds,
      state: state ?? this.state,
    );
  }
}

enum QuizState { initial, checked, answered }

class QuizOption {
  final String id;
  final String content;
  final bool isCorrect;
  final bool isSelected;
  final TeXViewStyle? style;

  const QuizOption({
    required this.id,
    required this.content,
    required this.isCorrect,
    this.isSelected = false,
    this.style,
  });

  QuizOption copyWith({
    bool? isSelected,
    TeXViewStyle? style,
  }) {
    return QuizOption(
      id: id,
      content: content,
      isCorrect: isCorrect,
      isSelected: isSelected ?? this.isSelected,
      style: style ?? this.style,
    );
  }
}

class AssociatedTopic {
  final String topicName;
  final String id;

  const AssociatedTopic({
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

  const AssociatedChapter({
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

  const AssociatedSubject({
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

// ============== MODELS (quiz_model_extended.dart) ==============

class QuizBatch {
  final List<Quiz> questions;
  final int batchNumber;
  final bool hasMore;
  final int totalQuestions;

  const QuizBatch({
    required this.questions,
    required this.batchNumber,
    required this.hasMore,
    this.totalQuestions = 0,
  });
}

class PrebuiltQuizContent {
  final Quiz quiz;
  final String questionHtml;
  final Map<String, String> optionsHtml;
  final DateTime buildTime;

  const PrebuiltQuizContent({
    required this.quiz,
    required this.questionHtml,
    required this.optionsHtml,
    required this.buildTime,
  });
}
