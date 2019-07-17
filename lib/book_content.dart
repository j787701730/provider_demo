import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class BookContent extends StatefulWidget {
  final content;
  final fontSize;
  final fontColor;

  BookContent(this.content, this.fontSize, this.fontColor);

  @override
  _BookContentState createState() => _BookContentState();
}

class _BookContentState extends State<BookContent> {
  String content;

  int fontColor;
  double fontSize;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    content = widget.content;
    fontColor = widget.fontColor;
    fontSize = widget.fontSize;
  }

  @override
  void didUpdateWidget(BookContent oldWidget) {
    // TODO: implement didUpdateWidget
//    super.didUpdateWidget(oldWidget);
    if (content != oldWidget.content) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    print('xxx');
    return Container(
      child: Text('0x${fontColor.toRadixString(16).toUpperCase()}'),
    );
//    return Html(
//      data: '$content'.replaceAll('%', ''),
//      defaultTextStyle: TextStyle(
////          fontSize: fontSize,
////          color: fontColor,
//          locale: Locale('en', 'US'),
//          fontFamily: 'SourceHanSerifCN',
//          height: 1.2),
//      customTextAlign: (dom.Node node) {
//        if (node is dom.Element) {
//          switch (node.localName) {
//            case "p":
//              return TextAlign.justify;
//          }
//        }
//        return null;
//      },
////                              customRender: (node, children) {
////                                print('xxx');
////                                if (node is dom.Element) {
////                                  switch (node.localName) {
////                                    case "p":
////                                      return Column(children: children);
////                                  }
////                                }
////                                return null;
////                              },
//    );
  }
}
