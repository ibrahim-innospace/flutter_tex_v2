import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_tex_example/quiz/models/quiz_model.dart';

class OptimizedQuizRepository {
  final List<String> _quizFiles = [
    'assets/data/quiz.json',
    'assets/data/quiz1.json',
    'assets/data/quiz2.json'
  ];

  int _currentFileIndex = 0;
  int _totalQuestionsLoaded = 0;

  Future<QuizBatch> loadNextBatch(int batchNumber) async {
    try {
      // If no more files, return empty batch
      if (_currentFileIndex >= _quizFiles.length) {
        print(
            'No more files to load. Current index: $_currentFileIndex, Total files: ${_quizFiles.length}');
        return QuizBatch(
          questions: [],
          batchNumber: batchNumber,
          hasMore: false,
          totalQuestions: _totalQuestionsLoaded,
        );
      }

      // Load entire file as one batch
      print(
          'Loading quiz file #$_currentFileIndex: ${_quizFiles[_currentFileIndex]}');
      final String response =
          await rootBundle.loadString(_quizFiles[_currentFileIndex]);
      final data = json.decode(response);
      final quizResponse = QuizResponse.fromJson(data);

      final loadedFileIndex = _currentFileIndex;
      _currentFileIndex++;
      _totalQuestionsLoaded += quizResponse.questions.length;

      // Check if there are more files to load
      final hasMore = _currentFileIndex < _quizFiles.length;

      print(
          'Loaded ${quizResponse.questions.length} questions from file #$loadedFileIndex. '
          'Total questions so far: $_totalQuestionsLoaded. '
          'Has more files: $hasMore (Next index: $_currentFileIndex/${_quizFiles.length})');

      return QuizBatch(
        questions: quizResponse.questions,
        batchNumber: batchNumber,
        hasMore: hasMore,
        totalQuestions: _totalQuestionsLoaded,
      );
    } catch (e) {
      print('Error loading quiz batch: $e');
      throw Exception('Failed to load quiz batch: $e');
    }
  }

  void reset() {
    print('Resetting repository');
    _currentFileIndex = 0;
    _totalQuestionsLoaded = 0;
  }

  // Get total number of questions across all files (for initial count)
  Future<int> getTotalQuestionCount() async {
    int total = 0;
    for (String file in _quizFiles) {
      try {
        final String response = await rootBundle.loadString(file);
        final data = json.decode(response);
        final quizResponse = QuizResponse.fromJson(data);
        total += quizResponse.questions.length;
        print('File $file has ${quizResponse.questions.length} questions');
      } catch (e) {
        print('Error counting questions in $file: $e');
      }
    }
    print('Total questions across all files: $total');
    return total;
  }
}
