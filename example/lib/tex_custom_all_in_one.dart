// import 'package:flutter/material.dart';
// import 'package:flutter_tex/flutter_tex.dart';

// class QuizCustom {
//   final String statement;
//   final List<QuizCustomOption> options;
//   final String correctOptionId;

//   QuizCustom(
//       {required this.statement,
//       required this.options,
//       required this.correctOptionId});
// }

// class QuizCustomOption {
//   final String id;
//   final String option;

//   QuizCustomOption(this.id, this.option);
// }

// class TeXViewQuizCustomExample extends StatefulWidget {
//   final TeXViewRenderingEngine renderingEngine;

//   const TeXViewQuizCustomExample(
//       {super.key, this.renderingEngine = const TeXViewRenderingEngine.katex()});

//   @override
//   State<TeXViewQuizCustomExample> createState() =>
//       _TeXViewQuizCustomExampleState();
// }

// class _TeXViewQuizCustomExampleState extends State<TeXViewQuizCustomExample> {
//   int currentQuizIndex = 0;
//   String selectedOptionId = "";
//   bool isWrong = false;

//   List<QuizCustom> quizList = [
//     QuizCustom(
//       statement:
//           "<p>​<strong><span style=\"font-size:16px;font-family:Lecture\">‰KRb ˆivMxi ˆ`Gni Zvcgvòv ‰KwU ò‚wUcƒYÆ ^vGgÆvwgUvGii mvnvGhÅ ˆgGc </span>45°C<span style=\"font-size:16px;font-family:Lecture\"> cvIqv ˆMj| hw` ‰B ^vGgÆvwgUvGii eidwe±`y ‰es evÓ·we±`y h^vKÌGg </span>3°C<span style=\"font-size:16px;font-family:Lecture\"> ‰es </span>107°C<span style=\"font-size:16px;font-family:Lecture\"> cvIqv hvq, ZvnGj ˆivMxi ˆ`Gn cÉK‡Z Zvcgvòv dvGibnvBU ˆÕ•Gj ˆei Ki|</span></strong></p><p><br></p><div class=\"se-component se-image-container __se__float-none\"><figure><img src=\"https://i.ibb.co/M8jGYCk/Untitled-581.png\" alt=\"\" data-rotate=\"\" data-proportion=\"true\" data-size=\",\" data-align=\"none\" data-percentage=\"auto,auto\" data-file-name=\"Untitled-581.png\" data-file-size=\"0\" origin-size=\"167,100\" data-origin=\",\" style=\"\"></figure></div><p><strong></strong></p><p>​<strong><span style=\"font-size:16px;font-family:Lecture\">‰KwU wbw`ÆÓ¡ MÅvGmi RbÅ </span>P = </strong><strong><span style=\"font-size:16px;font-family: Lecture\"> hw` </span>T<span style=\"font-size:16px;font-family:Lecture\"> wÕ©i ^vGK| ‰LvGb </span>P =<span style=\"font-size:16px;font-family:Lecture\"> Pvc, </span>V =<span style=\"font-size:16px;font-family:Lecture\"> AvqZb, </span>T<span style=\"font-size:16px;font-family:Lecture\"> = Zvcgvòv ‰es </span>K = <span style=\"font-size:16px;font-family:Lecture\">aË‚eK| ‰gZveÕ©vq wbGPi ˆKvbwU mwVK bq?</span></strong>​<br></p> ,<p> EXPLANATION: <strong><span style=\"font-size:16px;font-family:Lecture\">Zvcgvòvq ˆKvb wbw`ÆÓ¡ cwigvY</span></strong></p><p><strong><span style=\"font-size:16px;font-family:Lecture\"><br></span></strong></p><p><strong><span style=\"font-size:16px;font-family:Lecture\"><span class=\"__se__katex katex\" data-exp=\"\\frac{F - 32}{212 - 32} = \\frac{45 - 3}{107 - 3} \\Rightarrow F = 104.69^\\circ\\text{F}\" data-font-size=\"1em\" style=\"font-size: 16px\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\"><semantics><mrow><mfrac><mrow><mi>F</mi><mo>−</mo><mn>32</mn></mrow><mrow><mn>212</mn><mo>−</mo><mn>32</mn></mrow></mfrac><mo>=</mo><mfrac><mrow><mn>45</mn><mo>−</mo><mn>3</mn></mrow><mrow><mn>107</mn><mo>−</mo><mn>3</mn></mrow></mfrac><mo>⇒</mo><mi>F</mi><mo>=</mo><mn>104.6</mn><msup><mn>9</mn><mo>∘</mo></msup><mtext>F</mtext></mrow><annotation encoding=\"application/x-tex\">\\frac{F - 32}{212 - 32} = \\frac{45 - 3}{107 - 3} \\Rightarrow F = 104.69^\\circ\\text{F}</annotation></semantics></math></span><span class=\"katex-html\" aria-hidden=\"true\"><span class=\"base\"><span class=\"strut\" style=\"height:2.1297em;vertical-align:-0.7693em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.3603em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">212</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">32</span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord mathnormal\" style=\"margin-right:0.13889em;\">F</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">32</span></span></span></span><span class=\"vlist-s\">​</span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.7693em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:2.0908em;vertical-align:-0.7693em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.3214em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">107</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">3</span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">45</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">−</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">3</span></span></span></span><span class=\"vlist-s\">​</span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.7693em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">⇒</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.6833em;\"></span><span class=\"mord mathnormal\" style=\"margin-right:0.13889em;\">F</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.7241em;\"></span><span class=\"mord\">104.6</span><span class=\"mord\"><span class=\"mord\">9</span><span class=\"msupsub\"><span class=\"vlist-t\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.7241em;\"><span style=\"top:-3.113em;margin-right:0.05em;\"><span class=\"pstrut\" style=\"height:2.7em;\"></span><span class=\"sizing reset-size6 size3 mtight\"><span class=\"mbin mtight\">∘</span></span></span></span></span></span></span></span><span class=\"mord text\"><span class=\"mord\">F</span></span></span></span></span>&nbsp;<br></span></strong></p><p><strong><span style=\"font-size:16px;font-family:Lecture\"><br></span></strong></p><p><br></p><p><strong><span style=\"font-size: 16px;font-family: Times New Roman\">OR<br></span></strong></p><p>​<span class=\"__se__katex katex\" data-exp=\"\\therefore \\Delta m c^2 = m_s \\Delta \\theta \\Rightarrow \\Delta m = \\frac{m_s \\Delta \\theta}{c^2} = 4.33 \\times 10^{-11} \\, \\text{kg}\" data-font-size=\"1em\" style=\"font-size: 16px\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\"><semantics><mrow><mo>∴</mo><mi mathvariant=\"normal\">Δ</mi><mi>m</mi><msup><mi>c</mi><mn>2</mn></msup><mo>=</mo><msub><mi>m</mi><mi>s</mi></msub><mi mathvariant=\"normal\">Δ</mi><mi>θ</mi><mo>⇒</mo><mi mathvariant=\"normal\">Δ</mi><mi>m</mi><mo>=</mo><mfrac><mrow><msub><mi>m</mi><mi>s</mi></msub><mi mathvariant=\"normal\">Δ</mi><mi>θ</mi></mrow><msup><mi>c</mi><mn>2</mn></msup></mfrac><mo>=</mo><mn>4.33</mn><mo>×</mo><mn>1</mn><msup><mn>0</mn><mrow><mo>−</mo><mn>11</mn></mrow></msup><mtext> </mtext><mtext>kg</mtext></mrow><annotation encoding=\"application/x-tex\">\\therefore \\Delta m c^2 = m_s \\Delta \\theta \\Rightarrow \\Delta m = \\frac{m_s \\Delta \\theta}{c^2} = 4.33 \\times 10^{-11} \\, \\text{kg}</annotation></semantics></math></span><span class=\"katex-html\" aria-hidden=\"true\"><span class=\"base\"><span class=\"strut\" style=\"height:0.6922em;\"></span><span class=\"mrel amsrm\">∴</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.8641em;\"></span><span class=\"mord\">Δ</span><span class=\"mord mathnormal\">m</span><span class=\"mord\"><span class=\"mord mathnormal\">c</span><span class=\"msupsub\"><span class=\"vlist-t\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.8641em;\"><span style=\"top:-3.113em;margin-right:0.05em;\"><span class=\"pstrut\" style=\"height:2.7em;\"></span><span class=\"sizing reset-size6 size3 mtight\"><span class=\"mord mtight\">2</span></span></span></span></span></span></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.8444em;vertical-align:-0.15em;\"></span><span class=\"mord\"><span class=\"mord mathnormal\">m</span><span class=\"msupsub\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.1514em;\"><span style=\"top:-2.55em;margin-left:0em;margin-right:0.05em;\"><span class=\"pstrut\" style=\"height:2.7em;\"></span><span class=\"sizing reset-size6 size3 mtight\"><span class=\"mord mathnormal mtight\">s</span></span></span></span><span class=\"vlist-s\">​</span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.15em;\"><span></span></span></span></span></span></span><span class=\"mord\">Δ</span><span class=\"mord mathnormal\" style=\"margin-right:0.02778em;\">θ</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">⇒</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.6833em;\"></span><span class=\"mord\">Δ</span><span class=\"mord mathnormal\">m</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:2.0574em;vertical-align:-0.686em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.3714em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\"><span class=\"mord mathnormal\">c</span><span class=\"msupsub\"><span class=\"vlist-t\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.7401em;\"><span style=\"top:-2.989em;margin-right:0.05em;\"><span class=\"pstrut\" style=\"height:2.7em;\"></span><span class=\"sizing reset-size6 size3 mtight\"><span class=\"mord mtight\">2</span></span></span></span></span></span></span></span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\"><span class=\"mord mathnormal\">m</span><span class=\"msupsub\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.1514em;\"><span style=\"top:-2.55em;margin-left:0em;margin-right:0.05em;\"><span class=\"pstrut\" style=\"height:2.7em;\"></span><span class=\"sizing reset-size6 size3 mtight\"><span class=\"mord mathnormal mtight\">s</span></span></span></span><span class=\"vlist-s\">​</span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.15em;\"><span></span></span></span></span></span></span><span class=\"mord\">Δ</span><span class=\"mord mathnormal\" style=\"margin-right:0.02778em;\">θ</span></span></span></span><span class=\"vlist-s\">​</span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.686em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.7278em;vertical-align:-0.0833em;\"></span><span class=\"mord\">4.33</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">×</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:1.0585em;vertical-align:-0.1944em;\"></span><span class=\"mord\">1</span><span class=\"mord\"><span class=\"mord\">0</span><span class=\"msupsub\"><span class=\"vlist-t\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.8641em;\"><span style=\"top:-3.113em;margin-right:0.05em;\"><span class=\"pstrut\" style=\"height:2.7em;\"></span><span class=\"sizing reset-size6 size3 mtight\"><span class=\"mord mtight\"><span class=\"mord mtight\">−</span><span class=\"mord mtight\">11</span></span></span></span></span></span></span></span></span><span class=\"mspace\" style=\"margin-right:0.1667em;\"></span><span class=\"mord text\"><span class=\"mord\">kg</span></span></span></span></span></p><p><br></p><p>​​<br></p><div class=\"se-component se-image-container __se__float-center\"><figure style=\"width: 150px;\"><img src=\"https://i.ibb.co/b61QM8j/Untitled5471.png\" alt=\"\" data-rotate=\"0\" data-proportion=\"true\" data-size=\"150px,150px\" data-align=\"center\" data-file-name=\"Untitled5471.png\" data-file-size=\"0\" data-origin=\"150px,150px\" style=\"width: 150px; height: 150px; transform: rotate(0deg);\"></figure></div><p><br></p><p><br></p>",
//       options: [
//         QuizCustomOption(
//           "id_1",
//           "<p> A))) ​<span style=\"font-size:16px;font-family:Lecture\"><u><strong>Zvcgvòvq</strong></u><strong> ˆKvb wbw`ÆÓ¡ </strong><u><strong>cwigvY&nbsp;&nbsp;</strong></u></span></p><div class=\"se-component se-image-container __se__float-none\"><figure style=\"width: 150px;\"><img src=\"https://i.ibb.co/C10gCzN/Untitled894864.png\" alt=\"\" data-rotate=\"0\" data-proportion=\"true\" data-size=\"150px,150px\" data-align=\"none\" data-file-name=\"Untitled894864.png\" data-file-size=\"0\" origin-size=\"163,100\" data-origin=\"150px,150px\" style=\"width: 150px; height: 150px;\"></figure></div><p><br></p>",
//         ),
//         QuizCustomOption(
//           "id_2",
//           "<p> B))) ​<strong>16°C</strong><span style=\"font-size:16px;font-family:Lecture\"><strong> Zvcgvòvi ˆKvb wbw`ÆÓ¡ cwigvY ÷Í• evqy nVvr cÉmvwiZ nGq w«¼àY AvqZb jvf KGi| </strong><del><strong>P„ov¯¦ Zvcgvòv KZ? </strong></del></span></p><hr class=\"__se__dashed\">",
//         ),
//         QuizCustomOption(
//           "id_3",
//           "<p> C))) ​<strong><span style=\"font-size:16px;font-family:Lecture\">i‚«¬Zvcxq cÉwKÌqvq evqyi AvqZb e†w«¬ ˆcGq w«¼àY nGjv| cÉviGÁ¿i Pvc ‰K evqyPvc nGj P„ov¯¦ Pvc KZ?&nbsp;&nbsp;</span></strong></p><p><strong></strong>​<br></p><div class=\"se-component se-image-container __se__float-center\"><figure style=\"width: 120px;\"><img src=\"https://i.ibb.co/C10gCzN/Untitled894864.png\" alt=\"\" data-rotate=\"0\" data-proportion=\"true\" data-align=\"center\" data-size=\"120px,120px\" data-file-name=\"Untitled894864.png\" data-file-size=\"0\" origin-size=\"163,100\" data-origin=\"120px,120px\" style=\"width: 120px; height: 120px; transform: rotate(0deg) rotateX(180deg) rotateY(180deg);\"></figure></div>",
//         ),
//         QuizCustomOption(
//           "id_4",
//           "<p> D)))​<span class=\"__se__katex katex\" data-exp=\"P = \\frac{W}{t} \\Rightarrow P = \\frac{mlv}{p} \\Rightarrow t = \\frac{mlv}{P} = \\frac{2 \\times 2.09 \\times 10^4}{100} = 418 \\, \\text{s} = 6.97 \\, \\text{min}\" data-font-size=\"1em\" style=\"font-size: 16px\"><span class=\"katex-mathml\"><math xmlns=\"http://www.w3.org/1998/Math/MathML\" display=\"block\"><semantics><mrow><mi>P</mi><mo>=</mo><mfrac><mi>W</mi><mi>t</mi></mfrac><mo>⇒</mo><mi>P</mi><mo>=</mo><mfrac><mrow><mi>m</mi><mi>l</mi><mi>v</mi></mrow><mi>p</mi></mfrac><mo>⇒</mo><mi>t</mi><mo>=</mo><mfrac><mrow><mi>m</mi><mi>l</mi><mi>v</mi></mrow><mi>P</mi></mfrac><mo>=</mo><mfrac><mrow><mn>2</mn><mo>×</mo><mn>2.09</mn><mo>×</mo><mn>1</mn><msup><mn>0</mn><mn>4</mn></msup></mrow><mn>100</mn></mfrac><mo>=</mo><mn>418</mn><mtext> </mtext><mtext>s</mtext><mo>=</mo><mn>6.97</mn><mtext> </mtext><mtext>min</mtext></mrow><annotation encoding=\"application/x-tex\">P = \\frac{W}{t} \\Rightarrow P = \\frac{mlv}{p} \\Rightarrow t = \\frac{mlv}{P} = \\frac{2 \\times 2.09 \\times 10^4}{100} = 418 \\, \\text{s} = 6.97 \\, \\text{min}</annotation></semantics></math></span><span class=\"katex-html\" aria-hidden=\"true\"><span class=\"base\"><span class=\"strut\" style=\"height:0.6833em;\"></span><span class=\"mord mathnormal\" style=\"margin-right:0.13889em;\">P</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:2.0463em;vertical-align:-0.686em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.3603em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord mathnormal\">t</span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord mathnormal\" style=\"margin-right:0.13889em;\">W</span></span></span></span><span class=\"vlist-s\">​</span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.686em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">⇒</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.6833em;\"></span><span class=\"mord mathnormal\" style=\"margin-right:0.13889em;\">P</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:2.2519em;vertical-align:-0.8804em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.3714em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord mathnormal\">p</span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord mathnormal\">m</span><span class=\"mord mathnormal\" style=\"margin-right:0.01968em;\">l</span><span class=\"mord mathnormal\" style=\"margin-right:0.03588em;\">v</span></span></span></span><span class=\"vlist-s\">​</span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.8804em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">⇒</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.6151em;\"></span><span class=\"mord mathnormal\">t</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:2.0574em;vertical-align:-0.686em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.3714em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord mathnormal\" style=\"margin-right:0.13889em;\">P</span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord mathnormal\">m</span><span class=\"mord mathnormal\" style=\"margin-right:0.01968em;\">l</span><span class=\"mord mathnormal\" style=\"margin-right:0.03588em;\">v</span></span></span></span><span class=\"vlist-s\">​</span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.686em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:2.1771em;vertical-align:-0.686em;\"></span><span class=\"mord\"><span class=\"mopen nulldelimiter\"></span><span class=\"mfrac\"><span class=\"vlist-t vlist-t2\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:1.4911em;\"><span style=\"top:-2.314em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">100</span></span></span><span style=\"top:-3.23em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"frac-line\" style=\"border-bottom-width:0.04em;\"></span></span><span style=\"top:-3.677em;\"><span class=\"pstrut\" style=\"height:3em;\"></span><span class=\"mord\"><span class=\"mord\">2</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">×</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">2.09</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mbin\">×</span><span class=\"mspace\" style=\"margin-right:0.2222em;\"></span><span class=\"mord\">1</span><span class=\"mord\"><span class=\"mord\">0</span><span class=\"msupsub\"><span class=\"vlist-t\"><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.8141em;\"><span style=\"top:-3.063em;margin-right:0.05em;\"><span class=\"pstrut\" style=\"height:2.7em;\"></span><span class=\"sizing reset-size6 size3 mtight\"><span class=\"mord mtight\">4</span></span></span></span></span></span></span></span></span></span></span><span class=\"vlist-s\">​</span></span><span class=\"vlist-r\"><span class=\"vlist\" style=\"height:0.686em;\"><span></span></span></span></span></span><span class=\"mclose nulldelimiter\"></span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.6444em;\"></span><span class=\"mord\">418</span><span class=\"mspace\" style=\"margin-right:0.1667em;\"></span><span class=\"mord text\"><span class=\"mord\">s</span></span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span><span class=\"mrel\">=</span><span class=\"mspace\" style=\"margin-right:0.2778em;\"></span></span><span class=\"base\"><span class=\"strut\" style=\"height:0.6679em;\"></span><span class=\"mord\">6.97</span><span class=\"mspace\" style=\"margin-right:0.1667em;\"></span><span class=\"mord text\"><span class=\"mord\">min</span></span></span></span></span>​​<br></p>",
//         ),
//         QuizCustomOption(
//           "id_5",
//           "<p> E)))​<span style=\"font-size:16px;font-family:Lecture\">‰KwU Zvc Bwéb cÉwZ PGKÌ </span>500J<span style=\"font-size:16px;font-family:Lecture\"> Zvc ˆkvlY KGi DœP Zvcgvòvi Drm ˆ^GK ‰es wbÁ² <strong>Zvcgvòvi</strong><strong>DrmGZ </strong></span>300J<span style=\"font-size:16px;font-family:Lecture\"> Zvc eRÆb KGi| <u>hw` ‰B Zvc BwéGb `ÞZv ‰KwU</u> KvGbÆv BwéGbi `ÞZvi </span>60%<span style=\"font-size:16px;font-family:Lecture\"> nq| ZvnGj H KvGbÆv BwéGbi wbÁ² Zvcgvòv I DœP Zvcgvòvi AbycvZ KZ?</span></p><ul><li>= 80,000 cal/kg</li><li>= 8,000 ´ 4.2 J/kg</li><li>= 3,36,000 J/K</li></ul><table class=\"se-table-size-auto\"><tbody><tr><td><div>​<span style=\"font-size:16px;font-family:Lecture\"><strong>Zvc</strong>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</span>​<br></div></td><td><div><strong>500K&nbsp; &nbsp; &nbsp;</strong>​<br></div></td></tr><tr><td><div><strong><span style=\"font-size:16px;font-family:Lecture\">Bwéb </span></strong>​</div></td><td><div><strong>5451P</strong></div></td></tr></tbody></table>",
//         )
//       ],
//       correctOptionId: "id_3",
//     ),
//     QuizCustom(
//       statement: r"""
//     <p>
//     When \(a \ne 0 \), there are two solutions to \(ax^2 + bx + c = 0\) and they are
//     <span style="color: blue;">$$x = {-b \pm \sqrt{b^2-4ac} \over 2a}.$$</span><br>
// </p>""",
//       options: [
//         QuizCustomOption(
//           "id_1",
//           " <p><strong><span style=\"font-size:16px;font-family:Lecture\">‰KRb ˆivMxi ˆ`Gni Zvcgvòv ‰KwU ò‚wUcƒYÆ ^vGgÆvwgUvGii mvnvGhÅ ˆgGc </span>45°C<span style=\"font-size:16px;font-family:Lecture\"> cvIqv ˆMj| hw` ‰B ^vGgÆvwgUvGii eidwe±`y ‰es evÓ·we±`y h^vKÌGg </span>3°C<span style=\"font-size:16px;font-family:Lecture\"> ‰es </span>107°C<span style=\"font-size:16px;font-family:Lecture\"> cvIqv hvq, ZvnGj ˆivMxi ˆ`Gn cÉK‡Z Zvcgvòv dvGibnvBU ˆÕ•Gj ˆei Ki|</span></strong><br></p>",
//         ),
//         QuizCustomOption(
//           "id_2",
//           r"""<span style="color: blue;">
//     <p><strong>Mount Everest</strong>, <span style="color: red;">located in the Himalayas,</span> <strong style="color: green;">is the tallest mountain above sea level.</strong></p>
// </span>""",
//         ),
//         QuizCustomOption(
//           "id_3",
//           r"""<p><strong style=\"color: blue;\">Mount Everest</strong>, <span style=\"color: red;\">located in the Himalayas,</span> <strong style=\"color: green; font-weight: bold;\">is the tallest mountain above sea level.</strong></p>""",
//         ),
//         QuizCustomOption(
//           "id_4",
//           r"""<pre>
//   <span style="font-size: 11px;">Suneditor is a</span>
//    <span style="font-size: 18px;">lightweight</span>
// ,   <strong>flexible</strong>
// ,   <u>customizable</u>
//    <em>WYSIWYG</em>
//    <del>text</del>
//    <span style="color: rgb(255, 0, 0);">editor </span>
//   <span style="color: rgb(0, 85, 255);">for</span>
//    <span style="background-color: rgb(241, 95, 95);">your</span>
//    <span style="background-color: rgb(0, 34, 102);">web</span>
//    <span style="opacity: 0.5;" class="__se__t-shadow">applications</span>
// .</pre>""",
//         ),
//       ],
//       correctOptionId: "id_1",
//     ),
//     QuizCustom(
//       statement: r"""<h3>Select the correct Chemical Balanced Equation.</h3>""",
//       options: [
//         QuizCustomOption(
//           "id_1",
//           r""" <h2>(A)   \( \ce{CO + C -> 2 CO} \)</h2>""",
//         ),
//         QuizCustomOption(
//           "id_2",
//           r""" <h2>(B)   \( \ce{CO2 + C ->  CO} \)</h2>""",
//         ),
//         QuizCustomOption(
//           "id_3",
//           r""" <h2>(C)   \( \ce{CO + C ->  CO} \)</h2>""",
//         ),
//         QuizCustomOption(
//           "id_4",
//           r""" <h2>(D)   \( \ce{CO2 + C -> 2 CO} \)</h2>""",
//         ),
//       ],
//       correctOptionId: "id_4",
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("TeXView QuizCustom"),
//       ),
//       body: ListView(
//         physics: const ScrollPhysics(),
//         children: <Widget>[
//           Text(
//             'QuizCustom ${currentQuizIndex + 1}/${quizList.length}',
//             style: const TextStyle(fontSize: 20),
//             textAlign: TextAlign.center,
//           ),
//           TeXView(
//             fonts: const [
//               TeXViewFont(fontFamily: 'army', src: 'fonts/Army.ttf'),
//               TeXViewFont(
//                   fontFamily: 'Lecture',
//                   src: 'assets/fonts/lecture-reguler.ttf'),
//             ],
//             renderingEngine: widget.renderingEngine,
//             child: TeXViewColumn(children: [
//               // Question Title
//               TeXViewDocument(
//                 quizList[currentQuizIndex].statement,
//                 style: TeXViewStyle(
//                     fontStyle: TeXViewFontStyle(
//                       sizeUnit: TeXViewSizeUnit.pt,
//                     ),
//                     padding: const TeXViewPadding.all(10),
//                     borderRadius: const TeXViewBorderRadius.all(10),
//                     //  width: 250,
//                     margin: const TeXViewMargin.zeroAuto()),
//               ),

//               // Group of TeXViewDocument
//               TeXViewGroup(
//                   children: quizList[currentQuizIndex]
//                       .options
//                       .map((QuizCustomOption option) {
//                     return TeXViewGroupItem(
//                       rippleEffect: false,
//                       id: option.id,
//                       child: TeXViewDocument(
//                         option.option,
//                         style: const TeXViewStyle(
//                           padding: TeXViewPadding.all(10),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                   selectedItemStyle: TeXViewStyle(
//                       borderRadius: const TeXViewBorderRadius.all(10),
//                       border: TeXViewBorder.all(TeXViewBorderDecoration(
//                           borderWidth: 3, borderColor: Colors.green[900])),
//                       margin: const TeXViewMargin.all(10)),
//                   normalItemStyle:
//                       const TeXViewStyle(margin: TeXViewMargin.all(10)),
//                   onTap: (id) {
//                     selectedOptionId = id;
//                     setState(() {
//                       isWrong = false;
//                     });
//                   })
//             ]),
//             style: const TeXViewStyle(
//               margin: TeXViewMargin.all(5),
//               padding: TeXViewPadding.all(10),
//               borderRadius: TeXViewBorderRadius.all(10),
//               border: TeXViewBorder.all(
//                 TeXViewBorderDecoration(
//                     borderColor: Colors.blue,
//                     borderStyle: TeXViewBorderStyle.solid,
//                     borderWidth: 5),
//               ),
//               backgroundColor: Colors.white,
//             ),
//           ),
//           if (isWrong)
//             const Padding(
//               padding: EdgeInsets.all(20),
//               child: Text(
//                 "Wrong answer!!! Please choose a correct option.",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 18, color: Colors.red),
//               ),
//             ),
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     if (currentQuizIndex > 0) {
//                       selectedOptionId = "";
//                       currentQuizIndex--;
//                     }
//                   });
//                 },
//                 child: const Text("Previous"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   setState(() {
//                     if (selectedOptionId ==
//                         quizList[currentQuizIndex].correctOptionId) {
//                       selectedOptionId = "";
//                       if (currentQuizIndex != quizList.length - 1) {
//                         currentQuizIndex++;
//                       }
//                     } else {
//                       isWrong = true;
//                     }
//                   });
//                 },
//                 child: const Text("Next"),
//               ),
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
