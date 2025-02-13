import 'package:flutter/widgets.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:flutter_tex/src/models/widget_meta.dart';
import 'package:flutter_tex/src/utils/style_utils.dart';

class TeXViewCustomDetails implements TeXViewWidget {
  final String title;
  final int? iconSize;
  final TeXViewWidget body;
  final TeXViewStyle? style;

  const TeXViewCustomDetails({
    this.iconSize = 24, // Default icon size
    required this.title,
    required this.body,
    this.style,
  });

  @override
  TeXViewWidgetMeta meta() {
    return const TeXViewWidgetMeta(
      tag: 'details',
      classList: "svg-arrow-details",
      node: Node.internalChildren,
    );
  }

  @override
  Map toJson() {
    String customDetailsCss = """
      .svg-arrow-details {
        width: 100%;
      }

      .svg-arrow-details summary {
        list-style: none;
        display: flex;
        justify-content: space-between;
        align-items: center; /* Changed from flex-start to center */
        cursor: pointer;
        padding: 10px;
        gap: 12px;
        min-height: ${iconSize}px; /* Ensure minimum height matches icon */
        -webkit-tap-highlight-color: transparent;
      }

      .svg-arrow-details summary::-webkit-details-marker {
        display: none;
      }

      .svg-arrow-details summary span.title-text {
        flex: 1;
        min-width: 0;
        word-wrap: break-word;
        padding-right: 4px;
        display: flex; /* Added to help with vertical alignment */
        align-items: center; /* Added to help with vertical alignment */
      }

      .svg-arrow-details summary::after {
        content: '';
        flex-shrink: 0;
        width: ${iconSize}px;
        height: ${iconSize}px;
        background: url('data:image/svg+xml;utf8,<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M6 9l6 6 6-6\"/></svg>') no-repeat center center;
        transition: transform 0.1s ease;
      }

      .svg-arrow-details[open] summary::after {
        transform: rotate(180deg);
      }
    """;

    return {
      'meta': meta().toJson(),
      'data': [
        {
          'meta': const TeXViewWidgetMeta(
            tag: 'style',
            node: Node.leaf,
          ).toJson(),
          'data': customDetailsCss,
        },
        {
          'meta': const TeXViewWidgetMeta(
            tag: 'summary',
            classList: 'svg-arrow-details-title',
            node: Node.leaf,
          ).toJson(),
          'data': '<span class="title-text">$title</span>',
          'style': style?.initStyle() ?? teXViewDefaultStyle,
        },
        body.toJson(),
      ],
      'style': teXViewDefaultStyle,
    };
  }

  @override
  void onTapCallback(String id) {
    body.onTapCallback(id);
  }
}

// import 'package:flutter/widgets.dart';
// import 'package:flutter_tex/flutter_tex.dart';
// import 'package:flutter_tex/src/models/widget_meta.dart';
// import 'package:flutter_tex/src/utils/style_utils.dart';

// class TeXViewDetails implements TeXViewWidget {
//   final String title;
//   final int? iconSize;
//   final TeXViewWidget body;
//   final TeXViewStyle? style;

//   const TeXViewDetails({
//     this.iconSize = 24, // Default icon size
//     required this.title,
//     required this.body,
//     this.style,
//   });

//   @override
//   TeXViewWidgetMeta meta() {
//     return const TeXViewWidgetMeta(
//       tag: 'details',
//       classList: "svg-arrow-details",
//       node: Node.internalChildren,
//     );
//   }

//   @override
//   Map toJson() {
//     String customDetailsCss = """
//       .svg-arrow-details {
//         width: 100%;
//       }

//       .svg-arrow-details summary {
//         list-style: none;
//         display: flex;
//         justify-content: space-between;
//         align-items: center; /* Changed from flex-start to center */
//         cursor: pointer;
//         padding: 10px;
//         gap: 12px;
//         min-height: ${iconSize}px; /* Ensure minimum height matches icon */
//       }

//       .svg-arrow-details summary::-webkit-details-marker {
//         display: none;
//       }

//       .svg-arrow-details summary span.title-text {
//         flex: 1;
//         min-width: 0;
//         word-wrap: break-word;
//         padding-right: 4px;
//         display: flex; /* Added to help with vertical alignment */
//         align-items: center; /* Added to help with vertical alignment */
//       }

//       .svg-arrow-details summary::after {
//         content: '';
//         flex-shrink: 0;
//         width: ${iconSize}px;
//         height: ${iconSize}px;
//         background: url('data:image/svg+xml;utf8,<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 24 24\" fill=\"none\" stroke=\"currentColor\" stroke-width=\"2\" stroke-linecap=\"round\" stroke-linejoin=\"round\"><path d=\"M6 9l6 6 6-6\"/></svg>') no-repeat center center;
//         transition: transform 0.1s ease;
//       }

//       .svg-arrow-details[open] summary::after {
//         transform: rotate(180deg);
//       }
//     """;

//     return {
//       'meta': meta().toJson(),
//       'data': [
//         {
//           'meta': const TeXViewWidgetMeta(
//             tag: 'style',
//             node: Node.leaf,
//           ).toJson(),
//           'data': customDetailsCss,
//         },
//         {
//           'meta': const TeXViewWidgetMeta(
//             tag: 'summary',
//             classList: 'svg-arrow-details-title',
//             node: Node.leaf,
//           ).toJson(),
//           'data': '<span class="title-text">$title</span>',
//           'style': style?.initStyle() ?? teXViewDefaultStyle,
//         },
//         body.toJson(),
//       ],
//       'style': teXViewDefaultStyle,
//     };
//   }

//   @override
//   void onTapCallback(String id) {
//     body.onTapCallback(id);
//   }
// }
