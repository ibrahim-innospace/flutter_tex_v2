// ============== REPOSITORY (quiz_repository.dart) ==============

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tex_example/quiz/models/quiz_model.dart';
import 'package:flutter_tex_example/quiz/repository/quiz_repository.dart';
import 'package:flutter_tex_example/quiz/service/quiz_prebuilder_service.dart';

// ============== BLOC EVENTS (optimized_quiz_event.dart) ==============
abstract class OptimizedQuizEvent {
  const OptimizedQuizEvent();
}

class InitializeQuiz extends OptimizedQuizEvent {
  const InitializeQuiz();
}

class SelectQuizOption extends OptimizedQuizEvent {
  final String optionId;
  const SelectQuizOption(this.optionId);
}

class CheckQuizAnswer extends OptimizedQuizEvent {
  const CheckQuizAnswer();
}

class GoToNextQuestion extends OptimizedQuizEvent {
  const GoToNextQuestion();
}

class ResetOptimizedQuiz extends OptimizedQuizEvent {
  const ResetOptimizedQuiz();
}

// ============== BLOC STATES (optimized_quiz_state.dart) ==============

abstract class OptimizedQuizState {
  const OptimizedQuizState();
}

class OptimizedQuizInitial extends OptimizedQuizState {
  const OptimizedQuizInitial();
}

class OptimizedQuizLoading extends OptimizedQuizState {
  final String message;
  const OptimizedQuizLoading({this.message = 'Loading questions...'});
}

class OptimizedQuizReady extends OptimizedQuizState {
  final PrebuiltQuizContent currentContent;
  final PrebuiltQuizContent? nextContent;
  final int totalQuestionsAnswered;
  final int currentBatchIndex;
  final int batchSize;
  final bool showResult;
  final bool hasMoreQuestions;
  final String topicName;
  final int totalQuestions; // Total questions across all files

  const OptimizedQuizReady({
    required this.currentContent,
    this.nextContent,
    required this.totalQuestionsAnswered,
    required this.currentBatchIndex,
    required this.batchSize,
    this.showResult = false,
    required this.hasMoreQuestions,
    required this.topicName,
    this.totalQuestions = 0,
  });

  Quiz get currentQuiz => currentContent.quiz;

  // Current question number (1-based for display)
  int get currentQuestionNumber => totalQuestionsAnswered + 1;

  // Progress within current batch
  double get batchProgress {
    return batchSize > 0 ? (currentBatchIndex + 1) / batchSize : 0;
  }

  // Overall progress
  double get overallProgress {
    return totalQuestions > 0
        ? currentQuestionNumber / totalQuestions
        : batchProgress;
  }

  OptimizedQuizReady copyWith({
    PrebuiltQuizContent? currentContent,
    PrebuiltQuizContent? nextContent,
    int? totalQuestionsAnswered,
    int? currentBatchIndex,
    int? batchSize,
    bool? showResult,
    bool? hasMoreQuestions,
    String? topicName,
    int? totalQuestions,
  }) {
    return OptimizedQuizReady(
      currentContent: currentContent ?? this.currentContent,
      nextContent: nextContent,
      totalQuestionsAnswered:
          totalQuestionsAnswered ?? this.totalQuestionsAnswered,
      currentBatchIndex: currentBatchIndex ?? this.currentBatchIndex,
      batchSize: batchSize ?? this.batchSize,
      showResult: showResult ?? this.showResult,
      hasMoreQuestions: hasMoreQuestions ?? this.hasMoreQuestions,
      topicName: topicName ?? this.topicName,
      totalQuestions: totalQuestions ?? this.totalQuestions,
    );
  }
}

class OptimizedQuizError extends OptimizedQuizState {
  final String message;
  const OptimizedQuizError(this.message);
}

// ============== BLOC (optimized_quiz_bloc.dart) ==============

class OptimizedQuizBloc extends Bloc<OptimizedQuizEvent, OptimizedQuizState> {
  final OptimizedQuizRepository repository;

  QuizBatch? _currentBatch;
  QuizBatch? _nextBatch; // Preloaded next batch
  int _currentBatchIndex = 0;
  int _currentBatchNumber = 0;
  int _totalQuestionsAnswered = 0;
  int _totalQuestions = 0;

  OptimizedQuizBloc({required this.repository})
      : super(const OptimizedQuizInitial()) {
    on<InitializeQuiz>(_onInitializeQuiz);
    on<SelectQuizOption>(_onSelectOption);
    on<CheckQuizAnswer>(_onCheckAnswer);
    on<GoToNextQuestion>(_onNextQuestion);
    on<ResetOptimizedQuiz>(_onResetQuiz);
  }

  Future<void> _onInitializeQuiz(
    InitializeQuiz event,
    Emitter<OptimizedQuizState> emit,
  ) async {
    emit(const OptimizedQuizLoading(message: 'Loading questions...'));

    try {
      // Reset repository state
      repository.reset();
      _currentBatchNumber = 0;
      _currentBatchIndex = 0;
      _totalQuestionsAnswered = 0;
      _nextBatch = null;

      // Get total questions count
      _totalQuestions = await repository.getTotalQuestionCount();

      // Load first batch
      _currentBatch = await repository.loadNextBatch(0);

      if (_currentBatch!.questions.isEmpty) {
        emit(const OptimizedQuizError('No questions available'));
        return;
      }

      // Prebuild first question
      final firstQuestion = _currentBatch!.questions[0];
      final firstContent = PrebuiltQuizContent(
        quiz: firstQuestion,
        questionHtml: QuizPrebuilderService.prebuildQuestionHtml(firstQuestion),
        optionsHtml:
            QuizPrebuilderService.prebuildOptionsHtml(firstQuestion, false),
        buildTime: DateTime.now(),
      );

      // Prebuild second question if available
      PrebuiltQuizContent? secondContent;
      if (_currentBatch!.questions.length > 1) {
        final secondQuestion = _currentBatch!.questions[1];
        secondContent = PrebuiltQuizContent(
          quiz: secondQuestion,
          questionHtml:
              QuizPrebuilderService.prebuildQuestionHtml(secondQuestion),
          optionsHtml:
              QuizPrebuilderService.prebuildOptionsHtml(secondQuestion, false),
          buildTime: DateTime.now(),
        );
      }

      // Check if we need to preload next batch (if we have only 1-2 questions in current batch)
      if (_currentBatch!.questions.length <= 2 && _currentBatch!.hasMore) {
        print(
            'First batch has only ${_currentBatch!.questions.length} questions, preloading next batch...');
        await _preloadNextBatch();
      }

      emit(OptimizedQuizReady(
        currentContent: firstContent,
        nextContent: secondContent,
        totalQuestionsAnswered: 0,
        currentBatchIndex: 0,
        batchSize: _currentBatch!.questions.length,
        hasMoreQuestions:
            _currentBatch!.hasMore || _currentBatch!.questions.length > 1,
        topicName: _extractTopicName(firstQuestion),
        totalQuestions: _totalQuestions,
      ));
    } catch (e) {
      emit(OptimizedQuizError('Failed to initialize: $e'));
    }
  }

  void _onSelectOption(
    SelectQuizOption event,
    Emitter<OptimizedQuizState> emit,
  ) {
    if (state is OptimizedQuizReady) {
      final currentState = state as OptimizedQuizReady;

      if (currentState.showResult) return;

      final currentQuiz = currentState.currentQuiz;
      final updatedSelectedIds =
          List<String>.from(currentQuiz.selectedOptionIds);

      if (updatedSelectedIds.contains(event.optionId)) {
        updatedSelectedIds.remove(event.optionId);
      } else {
        updatedSelectedIds.add(event.optionId);
      }

      // Update quiz with new selection
      final updatedQuiz = currentQuiz.copyWith(
        selectedOptionIds: updatedSelectedIds,
      );

      // Rebuild content with updated selection
      final updatedContent = PrebuiltQuizContent(
        quiz: updatedQuiz,
        questionHtml: QuizPrebuilderService.prebuildQuestionHtml(updatedQuiz),
        optionsHtml:
            QuizPrebuilderService.prebuildOptionsHtml(updatedQuiz, false),
        buildTime: DateTime.now(),
      );

      emit(currentState.copyWith(
        currentContent: updatedContent,
        totalQuestions: _totalQuestions,
      ));
    }
  }

  Future<void> _onCheckAnswer(
    CheckQuizAnswer event,
    Emitter<OptimizedQuizState> emit,
  ) async {
    if (state is OptimizedQuizReady) {
      final currentState = state as OptimizedQuizReady;

      if (currentState.currentQuiz.selectedOptionIds.isEmpty) return;

      // Rebuild content with result view
      final updatedContent = PrebuiltQuizContent(
        quiz: currentState.currentQuiz,
        questionHtml: QuizPrebuilderService.prebuildQuestionHtml(
            currentState.currentQuiz),
        optionsHtml: QuizPrebuilderService.prebuildOptionsHtml(
            currentState.currentQuiz, true),
        buildTime: DateTime.now(),
      );

      // Check if we're on the last or second-to-last question and should preload next batch
      final isApproachingEnd =
          _currentBatchIndex >= _currentBatch!.questions.length - 2;
      final isLastQuestion =
          _currentBatchIndex >= _currentBatch!.questions.length - 1;

      if ((isApproachingEnd || isLastQuestion) &&
          _currentBatch!.hasMore &&
          _nextBatch == null) {
        print(
            'On question ${_currentBatchIndex + 1}/${_currentBatch!.questions.length} of batch, preloading next batch...');
        await _preloadNextBatch();
      }

      emit(currentState.copyWith(
        currentContent: updatedContent,
        showResult: true,
        totalQuestions: _totalQuestions,
      ));
    }
  }

  Future<void> _onNextQuestion(
    GoToNextQuestion event,
    Emitter<OptimizedQuizState> emit,
  ) async {
    if (state is OptimizedQuizReady) {
      final currentState = state as OptimizedQuizReady;

      _totalQuestionsAnswered++;
      _currentBatchIndex++;

      // Check if we need to switch to next batch
      if (_currentBatchIndex >= _currentBatch!.questions.length) {
        // Use preloaded batch if available
        if (_nextBatch != null && _nextBatch!.questions.isNotEmpty) {
          print(
              'Using preloaded batch. Switching to batch #${_currentBatchNumber + 1} with ${_nextBatch!.questions.length} questions');

          _currentBatch = _nextBatch;
          _nextBatch = null;
          _currentBatchNumber++;
          _currentBatchIndex = 0;
        } else if (_currentBatch!.hasMore) {
          // Load next batch if not preloaded
          print(
              'Next batch not preloaded. Loading batch #${_currentBatchNumber + 1}...');
          emit(const OptimizedQuizLoading(message: 'Loading next batch...'));

          _currentBatchNumber++;
          _currentBatch = await repository.loadNextBatch(_currentBatchNumber);
          _currentBatchIndex = 0;

          if (_currentBatch!.questions.isEmpty) {
            emit(const OptimizedQuizError(
                'Quiz completed! No more questions available.'));
            return;
          }
        } else {
          emit(const OptimizedQuizError(
              'Quiz completed! No more questions available.'));
          return;
        }
      }

      try {
        // Get current question
        final currentQuestion = _currentBatch!.questions[_currentBatchIndex];
        final newCurrentContent = PrebuiltQuizContent(
          quiz: currentQuestion,
          questionHtml:
              QuizPrebuilderService.prebuildQuestionHtml(currentQuestion),
          optionsHtml:
              QuizPrebuilderService.prebuildOptionsHtml(currentQuestion, false),
          buildTime: DateTime.now(),
        );

        // Prebuild next question
        PrebuiltQuizContent? nextContent;
        final nextIndex = _currentBatchIndex + 1;

        if (nextIndex < _currentBatch!.questions.length) {
          final nextQuestion = _currentBatch!.questions[nextIndex];
          nextContent = PrebuiltQuizContent(
            quiz: nextQuestion,
            questionHtml:
                QuizPrebuilderService.prebuildQuestionHtml(nextQuestion),
            optionsHtml:
                QuizPrebuilderService.prebuildOptionsHtml(nextQuestion, false),
            buildTime: DateTime.now(),
          );
        }

        // Preload next batch when approaching the end of current batch
        final isApproachingEnd =
            _currentBatchIndex >= _currentBatch!.questions.length - 2;
        if (isApproachingEnd && _currentBatch!.hasMore && _nextBatch == null) {
          print(
              'Approaching end of batch (question ${_currentBatchIndex + 1}/${_currentBatch!.questions.length}), preloading next batch...');
          _preloadNextBatch();
        }

        emit(OptimizedQuizReady(
          currentContent: newCurrentContent,
          nextContent: nextContent,
          totalQuestionsAnswered: _totalQuestionsAnswered,
          currentBatchIndex: _currentBatchIndex,
          batchSize: _currentBatch!.questions.length,
          showResult: false,
          hasMoreQuestions: _currentBatch!.hasMore ||
              nextIndex < _currentBatch!.questions.length ||
              (_nextBatch != null && _nextBatch!.questions.isNotEmpty),
          topicName: _extractTopicName(newCurrentContent.quiz),
          totalQuestions: _totalQuestions,
        ));
      } catch (e) {
        emit(OptimizedQuizError('Failed to load next question: $e'));
      }
    }
  }

  Future<void> _preloadNextBatch() async {
    try {
      _nextBatch = await repository.loadNextBatch(_currentBatchNumber + 1);
      print(
          'Preloaded next batch with ${_nextBatch?.questions.length ?? 0} questions');
    } catch (e) {
      print('Failed to preload next batch: $e');
      _nextBatch = null;
    }
  }

  Future<void> _onResetQuiz(
    ResetOptimizedQuiz event,
    Emitter<OptimizedQuizState> emit,
  ) async {
    // Clear all state
    _currentBatch = null;
    _nextBatch = null;
    _currentBatchIndex = 0;
    _currentBatchNumber = 0;
    _totalQuestionsAnswered = 0;
    _totalQuestions = 0;

    // Re-initialize
    add(const InitializeQuiz());
  }

  String _extractTopicName(Quiz quiz) {
    if (quiz.associatedWithTopic != null) {
      String topicName = quiz.associatedWithTopic!.topicName;
      return topicName.replaceAll(RegExp(r'<[^>]*>'), '');
    }
    return quiz.associatedWithChapter?.chapterName ??
        quiz.associatedWithSubject?.subjectName ??
        "Quiz";
  }

  // Future<void> _preloadNextBatch() async {
  //   try {
  //     _nextBatch = await repository.loadNextBatch(_currentBatchNumber + 1);
  //     print(
  //         'Preloaded next batch with ${_nextBatch?.questions.length ?? 0} questions');
  //   } catch (e) {
  //     print('Failed to preload next batch: $e');
  //     _nextBatch = null;
  //   }
  // }
}
