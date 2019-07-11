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
  int _counter;
  String title;
  List chapters = [];
  equb.EpubChapter content;
  var coverImage;
  List books;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    read();
  }

  Future<int> read() async {
    try {
//      Directory directory = await getApplicationDocumentsDirectory();
////      list
//      String dir = directory.path;
//      print(directory.listSync().length);
      File file = new File(widget.info['path']);
      // read the variable as a string from the file.
//      String contents = await file.readAsString();
      List<int> bytes = await file.readAsBytes();

// Opens a book and reads all of its content into memory
      equb.EpubBook epubBook = await equb.EpubReader.readBook(bytes);

//      epubBook.Chapters.forEach((EpubChapter chapter) {
//        // Title of chapter
//        String chapterTitle = chapter.Title;
//
//        // HTML content of current chapter
//        String chapterHtmlContent = chapter.HtmlContent;
//
//        // Nested chapters
//        List<EpubChapter> subChapters = chapter.SubChapters;
//
//        print(subChapters);
//      });
      setState(() {
        title = epubBook.Title;
        chapters = epubBook.Chapters;
        coverImage = epubBook.CoverImage;
      });
//      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }

  _readIndex(index) {
    Navigator.of(context).pop();
    setState(() {
      content = chapters[index];
    });
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('${widget.info['name']}'),
      ),
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Container(
              child: coverImage != null
                  ? Container(
                      width: 100,
                      height: 100,
                    )
                  : Placeholder(
                      fallbackWidth: 1,
                      fallbackHeight: 1,
                    ),
            )),
            Column(
              children: chapters.map<Widget>((item) {
                return InkWell(
                  onTap: () {
                    _readIndex(chapters.indexOf(item));
                  },
                  child: Container(
                    child: Text('${item.Title}'),
                  ),
                );
              }).toList(),
            )
          ],
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Html(
              data: content != null ? '${content.HtmlContent}' : '',
              defaultTextStyle: TextStyle(fontSize: 24),
            )
          ],
        ),
      ),
    );
  }
}
