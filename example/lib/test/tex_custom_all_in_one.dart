// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_tex/flutter_tex.dart';
// import 'package:flutter_tex_impl/test/question_model.dart';

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

//   List<Datum> quizList = [];
//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<TestQuestionModel> loadQuestionAPIData() async {
//     await Future.delayed(Duration(seconds: 0));
//     String jsonData =
//         await rootBundle.loadString('assets/jsons/question_list.json');

//     TestQuestionModel learnQuestionModel = testQuestionModelFromJson(jsonData);
//     quizList = learnQuestionModel.data ?? [];
//     print(learnQuestionModel);
//     print(learnQuestionModel.data?.length);

//     //  List<Question>? questionList = learnQuestionModel.questionList;

//     return learnQuestionModel;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("TeXView QuizCustom"),
//       ),
//       body: FutureBuilder(
//         builder: (ctx, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             // If we got an error
//             if (snapshot.hasError) {
//               return Center(
//                 child: Text(
//                   '${snapshot.error} occurred',
//                   style: TextStyle(fontSize: 18),
//                 ),
//               );

//               // if we got our data
//             } else if (snapshot.hasData) {
//               // Extracting data from snapshot object
//               final data = snapshot.data;

//               return Center(
//                 child: ListView(
//                   physics: const ScrollPhysics(),
//                   children: <Widget>[
//                     Text(
//                       'QuizCustom ${currentQuizIndex + 1}/${quizList.length}',
//                       style: const TextStyle(fontSize: 20),
//                       textAlign: TextAlign.center,
//                     ),
//                     TeXView(
//                       fonts: const [
//                         TeXViewFont(fontFamily: 'army', src: 'fonts/Army.ttf'),
//                         TeXViewFont(
//                             fontFamily: 'Lecture',
//                             src: 'assets/fonts/lecture-reguler.ttf'),
//                       ],
//                       renderingEngine: widget.renderingEngine,
//                       child: TeXViewColumn(children: [
//                         // Question Title
//                         TeXViewDocument(
//                           quizList[currentQuizIndex].questionText as String,
//                           style: TeXViewStyle(
//                               fontStyle: TeXViewFontStyle(
//                                 sizeUnit: TeXViewSizeUnit.pt,
//                               ),
//                               padding: const TeXViewPadding.all(10),
//                               borderRadius: const TeXViewBorderRadius.all(10),
//                               //  width: 250,
//                               margin: const TeXViewMargin.zeroAuto()),
//                         ),

//                         // Group of TeXViewDocument
//                         TeXViewGroup(
//                             children: quizList[currentQuizIndex]
//                                 .options!
//                                 .map((Option option) {
//                               return TeXViewGroupItem(
//                                 rippleEffect: false,
//                                 id: option.id as String,
//                                 child: TeXViewDocument(
//                                   option.text as String,
//                                   style: const TeXViewStyle(
//                                     padding: TeXViewPadding.all(10),
//                                   ),
//                                 ),
//                               );
//                             }).toList(),
//                             selectedItemStyle: TeXViewStyle(
//                                 borderRadius: const TeXViewBorderRadius.all(10),
//                                 border: TeXViewBorder.all(
//                                     TeXViewBorderDecoration(
//                                         borderWidth: 3,
//                                         borderColor: Colors.green[900])),
//                                 margin: const TeXViewMargin.all(10)),
//                             normalItemStyle: const TeXViewStyle(
//                                 margin: TeXViewMargin.all(10)),
//                             onTap: (id) {
//                               selectedOptionId = id;
//                               setState(() {
//                                 isWrong = false;
//                               });
//                             })
//                       ]),
//                       style: const TeXViewStyle(
//                         margin: TeXViewMargin.all(5),
//                         padding: TeXViewPadding.all(10),
//                         borderRadius: TeXViewBorderRadius.all(10),
//                         border: TeXViewBorder.all(
//                           TeXViewBorderDecoration(
//                               borderColor: Colors.blue,
//                               borderStyle: TeXViewBorderStyle.solid,
//                               borderWidth: 5),
//                         ),
//                         backgroundColor: Colors.white,
//                       ),
//                     ),
//                     if (isWrong)
//                       const Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Text(
//                           "Wrong answer!!! Please choose a correct option.",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 18, color: Colors.red),
//                         ),
//                       ),
//                     Row(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisSize: MainAxisSize.max,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               if (currentQuizIndex > 0) {
//                                 selectedOptionId = "";
//                                 currentQuizIndex--;
//                               }
//                             });
//                           },
//                           child: const Text("Previous"),
//                         ),
//                         ElevatedButton(
//                           onPressed: () {
//                             setState(() {
//                               selectedOptionId = "";
//                               if (currentQuizIndex != quizList.length - 1) {
//                                 currentQuizIndex++;
//                               }
//                             });
//                           },
//                           child: const Text("Next"),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               );
//             }
//           }

//           // Displaying LoadingSpinner to indicate waiting state
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         },

//         // Future that needs to be resolved
//         // inorder to display something on the Canvas
//         future: loadQuestionAPIData(),
//       ),
//     );
//   }
// }
