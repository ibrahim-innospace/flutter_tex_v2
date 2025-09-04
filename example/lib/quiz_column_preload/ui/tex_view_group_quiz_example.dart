import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

    String checkboxHtml = isSelected
        ? r"""<img width="20px" height="20px" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIHZpZXdCb3g9IjAgMCAxOCAxOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTcuNiAxMC43NDYzTDUuMjc3IDguNDIzQzUuMTM4NSA4LjI4NDY3IDQuOTY0NDIgOC4yMTM4MyA0Ljc1NDc1IDguMjEwNUM0LjU0NTI1IDguMjA3MzMgNC4zNjggOC4yNzgxNyA0LjIyMyA4LjQyM0M0LjA3ODE3IDguNTY4IDQuMDA1NzUgOC43NDM2NyA0LjAwNTc1IDguOTVDNC4wMDU3NSA5LjE1NjMzIDQuMDc4MTcgOS4zMzIgNC4yMjMgOS40NzdMNi45NjcyNSAxMi4yMjEzQzcuMTQ4MDggMTIuNDAxOSA3LjM1OSAxMi40OTIzIDcuNiAxMi40OTIzQzcuODQxIDEyLjQ5MjMgOC4wNTE5MiAxMi40MDE5IDguMjMyNzUgMTIuMjIxM0wxMy43OTYyIDYuNjU3NzVDMTMuOTM0NiA2LjUxOTI1IDE0LjAwNTQgNi4zNDUxNyAxNC4wMDg3IDYuMTM1NUMxNC4wMTE5IDUuOTI2IDEzLjk0MTEgNS43NDg3NSAxMy43OTYyIDUuNjAzNzVDMTMuNjUxMiA1LjQ1ODkyIDEzLjQ3NTYgNS4zODY1IDEzLjI2OTMgNS4zODY1QzEzLjA2MjkgNS4zODY1IDEyLjg4NzMgNS40NTg5MiAxMi43NDIzIDUuNjAzNzVMNy42IDEwLjc0NjNaTTIuMzA3NzUgMTcuNUMxLjgwMjU4IDE3LjUgMS4zNzUgMTcuMzI1IDEuMDI1IDE2Ljk3NUMwLjY3NSAxNi42MjUgMC41IDE2LjE5NzQgMC41IDE1LjY5MjNWMi4zMDc3NUMwLjUgMS44MDI1OCAwLjY3NSAxLjM3NSAxLjAyNSAxLjAyNUMxLjM3NSAwLjY3NSAxLjgwMjU4IDAuNSAyLjMwNzc1IDAuNUgxNS42OTIzQzE2LjE5NzQgMC41IDE2LjYyNSAwLjY3NSAxNi45NzUgMS4wMjVDMTcuMzI1IDEuMzc1IDE3LjUgMS44MDI1OCAxNy41IDIuMzA3NzVWMTUuNjkyM0MxNy41IDE2LjE5NzQgMTcuMzI1IDE2LjYyNSAxNi45NzUgMTYuOTc1QzE2LjYyNSAxNy4zMjUgMTYuMTk3NCAxNy41IDE1LjY5MjMgMTcuNUgyLjMwNzc1WiIgZmlsbD0iIzc5MjlFNyIvPgo8L3N2Zz4K" alt="Selected"/>"""
        : r"""<img width="20px" height="20px" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMTgiIGhlaWdodD0iMTgiIHZpZXdCb3g9IjAgMCAxOCAxOCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTIuMzA3NzUgMTcuNUMxLjgwMjU4IDE3LjUgMS4zNzUgMTcuMzI1IDEuMDI1IDE2Ljk3NUMwLjY3NSAxNi42MjUgMC41IDE2LjE5NzQgMC41IDE1LjY5MjNWMi4zMDc3NUMwLjUgMS44MDI1OCAwLjY3NSAxLjM3NSAxLjAyNSAxLjAyNUMxLjM3NSAwLjY3NSAxLjgwMjU4IDAuNSAyLjMwNzc1IDAuNUgxNS42OTIzQzE2LjE5NzQgMC41IDE2LjYyNSAwLjY3NSAxNi45NzUgMS4wMjVDMTcuMzI1IDEuMzc1IDE3LjUgMS44MDI1OCAxNy41IDIuMzA3NzVWMTUuNjkyM0MxNy41IDE2LjE5NzQgMTcuMzI1IDE2LjYyNSAxNi45NzUgMTYuOTc1QzE2LjYyNSAxNy4zMjUgMTYuMTk3NCAxNy41IDE1LjY5MjMgMTcuNUgyLjMwNzc1Wk0yLjMwNzc1IDE2SDE1LjY5MjNDMTUuNzY5MiAxNiAxNS44Mzk4IDE1Ljk2NzkgMTUuOTAzOCAxNS45MDM4QzE1Ljk2NzkgMTUuODM5OCAxNiAxNS43NjkyIDE2IDE1LjY5MjNWMi4zMDc3NUMxNiAyLjIzMDc1IDE1Ljk2NzkgMi4xNjAyNSAxNS45MDM4IDIuMDk2MjVDMTUuODM5OCAyLjAzMjA4IDE1Ljc2OTIgMiAxNS42OTIzIDJIMi4zMDc3NUMyLjIzMDc1IDIgMi4xNjAyNSAyLjAzMjA4IDIuMDk2MjUgMi4wOTYyNUMyLjAzMjA4IDIuMTYwMjUgMiAyLjIzMDc1IDIgMi4zMDc3NVYxNS42OTIzQzIgMTUuNzY5MiAyLjAzMjA4IDE1LjgzOTggMi4wOTYyNSAxNS45MDM4QzIuMTYwMjUgMTUuOTY3OSAyLjIzMDc1IDE2IDIuMzA3NzUgMTZaIiBmaWxsPSIjQURCNUJEIi8+Cjwvc3ZnPgo=" alt="Not Selected"/>""";

    if (showResult) {
      final isCorrectOption = option.isCorrect;
      final isSelectedOption =
          currentQuiz.selectedOptionIds.contains(option.id);

      if (isCorrectOption) {
        // Correct answer - show green checkmark
        checkboxHtml =
            """<img width="20px" height="20px" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHZpZXdCb3g9IjAgMCAyMCAyMCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTguNTgwNzUgMTIuMTQ2M0w2LjI1Nzc1IDkuODIzQzYuMTE5MjUgOS42ODQ2NyA1Ljk0NTE3IDkuNjEzODMgNS43MzU1IDkuNjEwNUM1LjUyNiA5LjYwNzMzIDUuMzQ4NzUgOS42NzgxNyA1LjIwMzc1IDkuODIzQzUuMDU4OTIgOS45NjggNC45ODY1IDEwLjE0MzcgNC45ODY1IDEwLjM1QzQuOTg2NSAxMC41NTYzIDUuMDU4OTIgMTAuNzMyIDUuMjAzNzUgMTAuODc3TDcuOTQ4IDEzLjYyMTJDOC4xMjg4MyAxMy44MDE5IDguMzM5NzUgMTMuODkyMyA4LjU4MDc1IDEzLjg5MjNDOC44MjE3NSAxMy44OTIzIDkuMDMyNjcgMTMuODAxOSA5LjIxMzUgMTMuNjIxMkwxNC43NzcgOC4wNTc3NUMxNC45MTUzIDcuOTE5MjUgMTQuOTg2MiA3Ljc0NTE3IDE0Ljk4OTUgNy41MzU1QzE0Ljk5MjcgNy4zMjYgMTQuOTIxOCA3LjE0ODc1IDE0Ljc3NyA3LjAwMzc1QzE0LjYzMiA2Ljg1ODkyIDE0LjQ1NjMgNi43ODY1IDE0LjI1IDYuNzg2NUMxNC4wNDM3IDYuNzg2NSAxMy44NjggNi44NTg5MiAxMy43MjMgNy4wMDM3NUw4LjU4MDc1IDEyLjE0NjNaTTEwLjAwMTcgMTkuNUM4LjY4Nzc1IDE5LjUgNy40NTI2NyAxOS4yNTA3IDYuMjk2NSAxOC43NTJDNS4xNDAzMyAxOC4yNTMzIDQuMTM0NjcgMTcuNTc2NiAzLjI3OTUgMTYuNzIxOEMyLjQyNDMzIDE1Ljg2NjkgMS43NDcyNSAxNC44NjE3IDEuMjQ4MjUgMTMuNzA2QzAuNzQ5NDE3IDEyLjU1MDMgMC41IDExLjMxNTYgMC41IDEwLjAwMTdDMC41IDguNjg3NzUgMC43NDkzMzMgNy40NTI2NyAxLjI0OCA2LjI5NjVDMS43NDY2NyA1LjE0MDMzIDIuNDIzNDIgNC4xMzQ2NyAzLjI3ODI1IDMuMjc5NUM0LjEzMzA4IDIuNDI0MzMgNS4xMzgzMyAxLjc0NzI1IDYuMjk0IDEuMjQ4MjVDNy40NDk2NyAwLjc0OTQxNyA4LjY4NDQyIDAuNSA5Ljk5ODI1IDAuNUMxMS4zMTIzIDAuNSAxMi41NDczIDAuNzQ5MzMzIDEzLjcwMzUgMS4yNDhDMTQuODU5NyAxLjc0NjY3IDE1Ljg2NTMgMi40MjM0MiAxNi43MjA1IDMuMjc4MjVDMTcuNTc1NyA0LjEzMzA4IDE4LjI1MjggNS4xMzgzMyAxOC43NTE4IDYuMjk0QzE5LjI1MDYgNy40NDk2NyAxOS41IDguNjg0NDIgMTkuNSA5Ljk5ODI1QzE5LjUgMTEuMzEyMyAxOS4yNTA3IDEyLjU0NzMgMTguNzUyIDEzLjcwMzVDMTguMjUzMyAxNC44NTk3IDE3LjU3NjYgMTUuODY1MyAxNi43MjE4IDE2LjcyMDVDMTUuODY2OSAxNy41NzU3IDE0Ljg2MTcgMTguMjUyOCAxMy43MDYgMTguNzUxOEMxMi41NTAzIDE5LjI1MDYgMTEuMzE1NiAxOS41IDEwLjAwMTcgMTkuNVoiIGZpbGw9IiMwREE0NUEiLz4KPC9zdmc+Cg==" alt="Correct" />""";
      } else if (!isCorrectOption && isSelectedOption) {
        // Wrong answer - show red X
        checkboxHtml =
            """<img width="20px" height="20px" src="data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAiIGhlaWdodD0iMjAiIHZpZXdCb3g9IjAgMCAyMCAyMCIgZmlsbD0ibm9uZSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj4KPHBhdGggZD0iTTEwIDExLjA1MzhMMTMuMDczIDE0LjEyN0MxMy4yMTE1IDE0LjI2NTMgMTMuMzg1NiAxNC4zMzYyIDEzLjU5NTMgMTQuMzM5NUMxMy44MDQ4IDE0LjM0MjcgMTMuOTgyIDE0LjI3MTggMTQuMTI3IDE0LjEyN0MxNC4yNzE4IDEzLjk4MiAxNC4zNDQzIDEzLjgwNjMgMTQuMzQ0MyAxMy42QzE0LjM0NDMgMTMuMzkzNyAxNC4yNzE4IDEzLjIxOCAxNC4xMjcgMTMuMDczTDExLjA1MzggMTBMMTQuMTI3IDYuOTI3QzE0LjI2NTMgNi43ODg1IDE0LjMzNjIgNi42MTQ0MiAxNC4zMzk1IDYuNDA0NzVDMTQuMzQyNyA2LjE5NTI1IDE0LjI3MTggNi4wMTggMTQuMTI3IDUuODczQzEzLjk4MiA1LjcyODE3IDEzLjgwNjMgNS42NTU3NSAxMy42IDUuNjU1NzVDMTMuMzkzNyA1LjY1NTc1IDEzLjIxOCA1LjcyODE3IDEzLjA3MyA1Ljg3M0wxMCA4Ljk0NjI1TDYuOTI3IDUuODczQzYuNzg4NSA1LjczNDY3IDYuNjE0NDIgNS42NjM4MyA2LjQwNDc1IDUuNjYwNUM2LjE5NTI1IDUuNjU3MzMgNi4wMTggNS43MjgxNyA1Ljg3MyA1Ljg3M0M1LjcyODE3IDYuMDE4IDUuNjU1NzUgNi4xOTM2NyA1LjY1NTc1IDYuNEM1LjY1NTc1IDYuNjA2MzMgNS43MjgxNyA2Ljc4MiA1Ljg3MyA2LjkyN0w4Ljk0NjI1IDEwTDUuODczIDEzLjA3M0M1LjczNDY3IDEzLjIxMTUgNS42NjM4MyAxMy4zODU2IDUuNjYwNSAxMy41OTUzQzUuNjU3MzMgMTMuODA0OCA1LjcyODE3IDEzLjk4MiA1Ljg3MyAxNC4xMjdDNi4wMTggMTQuMjcxOCA2LjE5MzY3IDE0LjM0NDMgNi40IDE0LjM0NDNDNi42MDYzMyAxNC4zNDQzIDYuNzgyIDE0LjI3MTggNi45MjcgMTQuMTI3TDEwIDExLjA1MzhaTTEwLjAwMTcgMTkuNUM4LjY4Nzc1IDE5LjUgNy40NTI2NyAxOS4yNTA3IDYuMjk2NSAxOC43NTJDNS4xNDAzMyAxOC4yNTMzIDQuMTM0NjcgMTcuNTc2NiAzLjI3OTUgMTYuNzIxOEMyLjQyNDMzIDE1Ljg2NjkgMS43NDcyNSAxNC44NjE3IDEuMjQ4MjUgMTMuNzA2QzAuNzQ5NDE3IDEyLjU1MDMgMC41IDExLjMxNTYgMC41IDEwLjAwMTdDMC41IDguNjg3NzUgMC43NDkzMzMgNy40NTI2NyAxLjI0OCA2LjI5NjVDMS43NDY2NyA1LjE0MDMzIDIuNDIzNDIgNC4xMzQ2NyAzLjI3ODI1IDMuMjc5NUM0LjEzMzA4IDIuNDI0MzMgNS4xMzgzMyAxLjc0NzI1IDYuMjk0IDEuMjQ4MjVDNy40NDk2NyAwLjc0OTQxNyA4LjY4NDQyIDAuNSA5Ljk5ODI1IDAuNUMxMS4zMTIzIDAuNSAxMi41NDczIDAuNzQ5MzMzIDEzLjcwMzUgMS4yNDhDMTQuODU5NyAxLjc0NjY3IDE1Ljg2NTMgMi40MjM0MiAxNi43MjA1IDMuMjc4MjVDMTcuNTc1NyA0LjEzMzA4IDE4LjI1MjggNS4xMzgzMyAxOC43NTE4IDYuMjk0QzE5LjI1MDYgNy40NDk2NyAxOS41IDguNjg0NDIgMTkuNSA5Ljk5ODI1QzE5LjUgMTEuMzEyMyAxOS4yNTA3IDEyLjU0NzMgMTguNzUyIDEzLjcwMzVDMTguMjUzMyAxNC44NTk3IDE3LjU3NjYgMTUuODY1MyAxNi43MjE4IDE2LjcyMDVDMTUuODY2OSAxNy41NzU3IDE0Ljg2MTcgMTguMjUyOCAxMy43MDYgMTguNzUxOEMxMi41NTAzIDE5LjI1MDYgMTEuMzE1NiAxOS41IDEwLjAwMTcgMTkuNVoiIGZpbGw9IiNEQTNFMzMiLz4KPC9zdmc+Cg==" alt="Wrong" />""";
      } else {
        // Not selected and not correct - show gray empty checkbox
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
