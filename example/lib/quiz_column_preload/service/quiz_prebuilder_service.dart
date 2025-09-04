// ============== PREBUILDER SERVICE (quiz_prebuilder_service.dart) ==============
import 'package:flutter_tex_example/quiz_column_preload/models/quiz_model.dart';
import 'package:flutter_tex_example/quiz_column_preload/ui/tex_view_group_quiz_example.dart';

class QuizPrebuilderService {
  // Prebuild only the question HTML
  static String prebuildQuestionHtml(Quiz quiz) {
    return quiz.questionText;
  }

  // Prebuild individual option HTML (content only, style handled separately)
  static Map<String, String> prebuildOptionsHtml(Quiz quiz, bool showResult) {
    final optionsHtml = <String, String>{};

    quiz.options.asMap().forEach((index, option) {
      optionsHtml[option.id] = QuizUIHelpers.getOptionHtml(
        option,
        index,
        quiz,
        showResult,
      );
    });

    return optionsHtml;
  }
}
