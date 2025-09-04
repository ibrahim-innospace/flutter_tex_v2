import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tex_example/icon_constant.dart';
import 'package:flutter_tex_example/katex_fonts.dart';
import 'package:flutter_tex_example/quiz_column_preload/bloc/quiz_bloc.dart';
import 'package:flutter_tex_example/quiz_column_preload/models/quiz_model.dart';
import 'package:flutter_tex_example/quiz_column_preload/repository/quiz_repository.dart';

import 'custom_widget.dart';

// ============== UI HELPERS (quiz_ui_helpers.dart) ==============

class QuizUIHelpers {
  static TeXViewStyle getUnselectedOptionStyle() => const TeXViewStyle(
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

  static TeXViewStyle getOptionStyleBasedOnState(
    QuizOption option,
    Quiz currentQuiz,
    bool showResult,
  ) {
    if (!showResult) {
      // Selected but not yet checked
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

    final isCorrectOption = option.isCorrect;
    final isSelectedOption = currentQuiz.selectedOptionIds.contains(option.id);

    if (isCorrectOption && isSelectedOption) {
      return _correctSelectedStyle();
    } else if (isCorrectOption && !isSelectedOption) {
      return _correctNotSelectedStyle();
    } else if (!isCorrectOption && isSelectedOption) {
      return _incorrectSelectedStyle();
    } else {
      return getUnselectedOptionStyle();
    }
  }

  static TeXViewStyle _correctSelectedStyle() => const TeXViewStyle(
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

  static TeXViewStyle _correctNotSelectedStyle() => const TeXViewStyle(
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

  static TeXViewStyle _incorrectSelectedStyle() => const TeXViewStyle(
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

  static String getOptionHtml(
    QuizOption option,
    int index,
    Quiz currentQuiz,
    bool showResult,
  ) {
    final label = String.fromCharCode(65 + index);
    final isSelected = currentQuiz.selectedOptionIds.contains(option.id);

    String checkboxHtml =
        isSelected ? IconConstant.selected : IconConstant.notSelected;
    if (showResult) {
      final isCorrectOption = option.isCorrect;
      final isSelectedOption =
          currentQuiz.selectedOptionIds.contains(option.id);

      if (isCorrectOption) {
        // Correct answer - show green checkmark
        checkboxHtml = IconConstant.greenCheck;
      } else if (!isCorrectOption && isSelectedOption) {
        // Wrong answer - show red X
        checkboxHtml = IconConstant.redCheck;
      } else {
        // Not selected and not correct - show gray empty checkbox
        checkboxHtml = IconConstant.notSelected;
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
}

// ============== MAIN WIDGET (modern_tex_view_quiz.dart) ==============

class OptimizedQuizViewGroup extends StatelessWidget {
  const OptimizedQuizViewGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OptimizedQuizBloc(
        repository: OptimizedQuizRepository(),
      )..add(const InitializeQuiz()),
      child: const _OptimizedQuizContent(),
    );
  }
}

class _OptimizedQuizContent extends StatelessWidget {
  const _OptimizedQuizContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OptimizedQuizBloc, OptimizedQuizState>(
      builder: (context, state) {
        if (state is OptimizedQuizInitial || state is OptimizedQuizLoading) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 239, 239, 239),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  if (state is OptimizedQuizLoading)
                    Text(
                      state.message,
                      style: const TextStyle(color: Colors.grey),
                    ),
                ],
              ),
            ),
          );
        }

        if (state is OptimizedQuizError) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 239, 239, 239),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    state.message.contains('completed')
                        ? Icons.check_circle_outline
                        : Icons.error_outline,
                    size: 48,
                    color: state.message.contains('completed')
                        ? Colors.green
                        : Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: state.message.contains('completed')
                          ? Colors.green
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (state.message.contains('completed'))
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.home),
                      label: const Text('Back to Home'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                    )
                  else
                    ElevatedButton(
                      onPressed: () => context
                          .read<OptimizedQuizBloc>()
                          .add(const InitializeQuiz()),
                      child: const Text('Retry'),
                    ),
                ],
              ),
            ),
          );
        }

        if (state is OptimizedQuizReady) {
          return _buildQuizScreen(context, state);
        }

        return const Scaffold(
          body: Center(child: Text('Unknown state')),
        );
      },
    );
  }

  Widget _buildQuizScreen(BuildContext context, OptimizedQuizReady state) {
    final bloc = context.read<OptimizedQuizBloc>();

    String buttonText;
    VoidCallback? onPressed;

    if (state.showResult) {
      buttonText = state.hasMoreQuestions ? 'Next Question' : 'Finish';
      onPressed = state.hasMoreQuestions
          ? () => bloc.add(const GoToNextQuestion())
          : null;
    } else {
      buttonText = 'Check';
      onPressed = state.currentQuiz.selectedOptionIds.isNotEmpty
          ? () => bloc.add(const CheckQuizAnswer())
          : null;
    }

    return Scaffold(
      persistentFooterButtons: [
        Container(
          margin: const EdgeInsets.all(0),
          padding: const EdgeInsets.only(top: 8, bottom: 20),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: AnimatedButton(
              width: double.infinity,
              borderRadius: 8,
              height: 50,
              // color: onPressed != null ? const Color(0xFF852DFE) : Colors.grey,
              gradientColors: const [
                Color(0xFF852DFE),
                Color(0xFFAD72FE),
              ],
              onPressed: onPressed ?? () {},
              child: Text(
                buttonText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
      backgroundColor: const Color.fromARGB(255, 239, 239, 239),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          state.topicName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      state.totalQuestions > 0
                          ? '${state.currentQuestionNumber}/${state.totalQuestions}'
                          : 'Batch: ${state.currentBatchIndex + 1}/${state.batchSize}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    Text(
                      '${(state.overallProgress * 100).toInt()}%',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: state.overallProgress,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                  minHeight: 4,
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: TeXView(
          fonts: teXViewFontList,
          style: const TeXViewStyle(
            padding: TeXViewPadding.all(12),
            borderRadius: TeXViewBorderRadius.all(12),
            backgroundColor: Colors.white,
          ),
          child: TeXViewColumn(children: [
            // Question
            TeXViewDocument(
              state.currentContent.questionHtml,
              style: const TeXViewStyle(
                textAlign: TeXViewTextAlign.left,
                padding: TeXViewPadding.only(top: 12, bottom: 24),
              ),
            ),
            // Options using TeXViewGroup
            TeXViewGroup(
              selectedIds: state.currentContent.quiz.selectedOptionIds,
              children: state.currentContent.quiz.options
                  .asMap()
                  .entries
                  .map((entry) {
                final option = entry.value;
                final index = entry.key;

                // Determine if this option should be shown as selected
                bool shouldUseSelectedStyle = state.showResult
                    ? (option.isCorrect ||
                        state.currentContent.quiz.selectedOptionIds
                            .contains(option.id))
                    : state.currentContent.quiz.selectedOptionIds
                        .contains(option.id);

                return TeXViewGroupItem(
                  id: option.id,
                  rippleEffect: false,
                  isSelected: shouldUseSelectedStyle,
                  normalStyle: QuizUIHelpers.getUnselectedOptionStyle(),
                  selectedStyle: QuizUIHelpers.getOptionStyleBasedOnState(
                    option,
                    state.currentContent.quiz,
                    state.showResult,
                  ),
                  onTap: !state.showResult
                      ? (selectedId) {
                          bloc.add(SelectQuizOption(selectedId));
                        }
                      : null,
                  child: TeXViewDocument(
                    QuizUIHelpers.getOptionHtml(
                      option,
                      index,
                      state.currentContent.quiz,
                      state.showResult,
                    ),
                    style: const TeXViewStyle(padding: TeXViewPadding.all(0)),
                  ),
                );
              }).toList(),
            ),
          ]),
        ),
      ),
    );
  }
}
