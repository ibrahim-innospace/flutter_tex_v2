import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class GroupQuiz {
  final String statement;
  final List<GroupQuizOption> options;
  final String correctOptionId;

  GroupQuiz(
      {required this.statement,
      required this.options,
      required this.correctOptionId});
}

class GroupQuizOption {
  final String id;
  final String option;

  GroupQuizOption(this.id, this.option);
}

class TeXViewGroupQuizExample extends StatefulWidget {

  const TeXViewGroupQuizExample(
      {super.key});

  @override
  State<TeXViewGroupQuizExample> createState() => _TeXViewGroupQuizExampleState();
}

class _TeXViewGroupQuizExampleState extends State<TeXViewGroupQuizExample> {
  int currentGroupQuizIndex = 0;
  String selectedOptionId = "";
  bool isWrong = false;

  List<GroupQuiz> groupQuizList = [
    GroupQuiz(
      statement: r"""<h3>What is the correct form of quadratic formula?</h3>""",
      options: [
        GroupQuizOption(
          "id_1",
          r""" <h2>(A)   \(x = {-b \pm \sqrt{b^2+4ac} \over 2a}\)</h2>""",
        ),
        GroupQuizOption(
          "id_2",
          r""" <h2>(B)   \(x = {b \pm \sqrt{b^2-4ac} \over 2a}\)</h2>""",
        ),
        GroupQuizOption(
          "id_3",
          r""" <h2>(C)   \(x = {-b \pm \sqrt{b^2-4ac} \over 2a}\)</h2>""",
        ),
        GroupQuizOption(
          "id_4",
          r""" <h2>(D)   \(x = {-b + \sqrt{b^2+4ac} \over 2a}\)</h2>""",
        ),
      ],
      correctOptionId: "id_3",
    ),
    GroupQuiz(
      statement:
          r"""<h3>Choose the correct mathematical form of Bohr's Radius.</h3>""",
      options: [
        GroupQuizOption(
          "id_1",
          r""" <h2>(A)   \( a_0 = \frac{{\hbar ^2 }}{{m_e ke^2 }} \)</h2>""",
        ),
        GroupQuizOption(
          "id_2",
          r""" <h2>(B)   \( a_0 = \frac{{\hbar ^2 }}{{m_e ke^3 }} \)</h2>""",
        ),
        GroupQuizOption(
          "id_3",
          r""" <h2>(C)   \( a_0 = \frac{{\hbar ^3 }}{{m_e ke^2 }} \)</h2>""",
        ),
        GroupQuizOption(
          "id_4",
          r""" <h2>(D)   \( a_0 = \frac{{\hbar }}{{m_e ke^2 }} \)</h2>""",
        ),
      ],
      correctOptionId: "id_1",
    ),
    GroupQuiz(
      statement: r"""<h3>Select the correct Chemical Balanced Equation.</h3>""",
      options: [
        GroupQuizOption(
          "id_1",
          r""" <h2>(A)   \( \ce{CO + C -> 2 CO} \)</h2>""",
        ),
        GroupQuizOption(
          "id_2",
          r""" <h2>(B)   \( \ce{CO2 + C ->  CO} \)</h2>""",
        ),
        GroupQuizOption(
          "id_3",
          r""" <h2>(C)   \( \ce{CO + C ->  CO} \)</h2>""",
        ),
        GroupQuizOption(
          "id_4",
          r""" <h2>(D)   \( \ce{CO2 + C -> 2 CO} \)</h2>""",
        ),
      ],
      correctOptionId: "id_4",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("TeXView GroupQuiz"),
      ),
      body: ListView(
        physics: const ScrollPhysics(),
        children: <Widget>[
          Text(
            'GroupQuiz ${currentGroupQuizIndex + 1}/${groupQuizList.length}',
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          TeXView(
            child: TeXViewColumn(children: [
              TeXViewDocument(groupQuizList[currentGroupQuizIndex].statement,
                  style:
                      const TeXViewStyle(textAlign: TeXViewTextAlign.center)),
              TeXViewGroup(
                  children: groupQuizList[currentGroupQuizIndex]
                      .options
                      .map((GroupQuizOption option) {
                    return TeXViewGroupItem(
                        rippleEffect: false,
                        id: option.id,
                        child: TeXViewDocument(option.option,
                            style: const TeXViewStyle(
                                padding: TeXViewPadding.all(10))));
                  }).toList(),
                  selectedItemStyle: TeXViewStyle(
                      borderRadius: const TeXViewBorderRadius.all(10),
                      border: TeXViewBorder.all(TeXViewBorderDecoration(
                          borderWidth: 3, borderColor: Colors.green[900])),
                      margin: const TeXViewMargin.all(10)),
                  normalItemStyle:
                      const TeXViewStyle(margin: TeXViewMargin.all(10)),
                  onTap: (id) {
                    selectedOptionId = id;
                    setState(() {
                      isWrong = false;
                    });
                  })
            ]),
            style: const TeXViewStyle(
              margin: TeXViewMargin.all(5),
              padding: TeXViewPadding.all(10),
              borderRadius: TeXViewBorderRadius.all(10),
              border: TeXViewBorder.all(
                TeXViewBorderDecoration(
                    borderColor: Colors.blue,
                    borderStyle: TeXViewBorderStyle.solid,
                    borderWidth: 5),
              ),
              backgroundColor: Colors.white,
            ),
          ),
          if (isWrong)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Wrong answer!!! Please choose a correct option.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.red),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (currentGroupQuizIndex > 0) {
                      selectedOptionId = "";
                      currentGroupQuizIndex--;
                    }
                  });
                },
                child: const Text("Previous"),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    if (selectedOptionId ==
                        groupQuizList[currentGroupQuizIndex].correctOptionId) {
                      selectedOptionId = "";
                      if (currentGroupQuizIndex != groupQuizList.length - 1) {
                        currentGroupQuizIndex++;
                      }
                    } else {
                      isWrong = true;
                    }
                  });
                },
                child: const Text("Next"),
              ),
            ],
          )
        ],
      ),
    );
  }
}