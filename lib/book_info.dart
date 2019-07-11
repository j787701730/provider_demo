import 'package:flutter/material.dart';
import 'dart:io';

import 'package:epub/epub.dart' as equb;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import 'dart:async';
import 'package:flutter_html/flutter_html.dart';

class BookInfo extends StatefulWidget {
  final info;

  BookInfo(this.info);

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  String title;
  List chapters = [];
  equb.EpubChapter content;
  var coverImage;
  List books;
  ScrollController _controller;
  int bookIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ScrollController();
    read();
  }

  read() async {
    try {
      File file = new File(widget.info['path']);
      List<int> bytes = await file.readAsBytes();
      equb.EpubBook epubBook = await equb.EpubReader.readBook(bytes);
      setState(() {
//        title = epubBook.Title;
        chapters = epubBook.Chapters;
//        coverImage = epubBook.CoverImage;
        content = epubBook.Chapters[bookIndex];
      });
    } on FileSystemException {
      return 0;
    }
  }

  _readIndex(index, {flag = false}) {
    if (flag) {
      Navigator.of(context).pop();
    }
    _controller.jumpTo(0);
    setState(() {
      content = chapters[index];
      bookIndex = index;
    });
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.info['name']}'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
//            DrawerHeader(
//                child: Container(
//              child: coverImage != null
//                  ? Container(
//                      width: 100,
//                      height: 100,
//                    )
//                  : Placeholder(
//                      fallbackWidth: 1,
//                      fallbackHeight: 1,
//                    ),
//            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: chapters.map<Widget>((item) {
                return InkWell(
                  onTap: () {
                    _readIndex(chapters.indexOf(item), flag: true);
                  },
                  child: Container(
                    width: width,
                    padding: EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6),
                    child: Text(
                      '${item.Title}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(bookIndex == chapters.indexOf(item) ? 0xff4285F4 : 0xff333333),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
      body: Container(
        child: ListView(
          padding: EdgeInsets.only(left: 10, right: 10),
          controller: _controller,
          children: <Widget>[
            Html(
              data: content != null ? '${content.HtmlContent}' : '',
              defaultTextStyle: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                bookIndex == 0
                    ? Container(
                        width: width / 2 - 10,
                      )
                    : Container(
                        width: width / 2 - 10,
                        child: FlatButton(
                          onPressed: () {
                            var idx = bookIndex;
                            _readIndex(idx - 1);
                          },
                          child: Text('上一章'),
                          color: Colors.green,
                          textColor: Colors.white,
                        ),
                      ),
                bookIndex == chapters.length
                    ? Container(
                        width: width / 2 - 10,
                      )
                    : Container(
                        width: width / 2 - 10,
                        child: FlatButton(
                          onPressed: () {
                            var idx = bookIndex;
                            _readIndex(idx + 1);
                          },
                          child: Text('下一章'),
                          color: Colors.blue,
                          textColor: Colors.white,
                        ),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
