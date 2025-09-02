import 'package:flutter/material.dart';
import 'package:flutter_tex/flutter_tex.dart';

class TeXViewExpandDocumentExamples extends StatelessWidget {
  const TeXViewExpandDocumentExamples({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("TeXViewDocument"),
      ),
      body: TeXView(
        child: TeXViewColumn(
          style: const TeXViewStyle(
            margin: TeXViewMargin.all(18),
            // elevation: 10,
            borderRadius: TeXViewBorderRadius.all(8),
            // border: TeXViewBorder.all(
            //   TeXViewBorderDecoration(
            //       borderColor: Colors.blue,
            //       borderStyle: TeXViewBorderStyle.solid,
            //       borderWidth: 5),
            // ),
            backgroundColor: Colors.white,
          ),
          children: [
            TeXViewCustomDetails(
              title: "Explanation:",
              iconSize: 22,
              style: TeXViewStyle(
                fontStyle: TeXViewFontStyle(
                  fontSize: 14,
                  fontWeight: TeXViewFontWeight.w600,
                ),
                textAlign: TeXViewTextAlign.left,

                backgroundColor: Color(0xFFF3EAFF),
                padding: TeXViewPadding.all(10),
                // margin: TeXViewMargin.all(10),
                // borderRadius: TeXViewBorderRadius.only(topLeft: 8, topRight: 8),
              ),
              body: TeXViewDocument(
                "Bangladesh is home to several major rivers, including the Ganges, Brahmaputra, and Meghna. However, the Surma River, while significant, is not classified among the major rivers. It flows through the northeastern part of the country, contributing to the region's rich biodiversity and agricultural landscape.",
                style: TeXViewStyle(
                  backgroundColor: Color(0xFFF3EAFF),
                  padding: TeXViewPadding.all(10),
                  // margin: TeXViewMargin.all(10),
                  // borderRadius:
                  //     TeXViewBorderRadius.only(bottomLeft: 8, bottomRight: 8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
