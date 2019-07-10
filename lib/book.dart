import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:epub/epub.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import 'dart:convert';
import 'dart:async';

class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/counter.txt');
  }

  Future<int> _readCounter() async {
    try {
      File file = await _getLocalFile();
      // read the variable as a string from the file.
      String contents = await file.readAsString();
      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }

  int _counter;
  String title;
  List chapters = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
  }

  Future<Null> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    // write the variable as a string to the file
    await (await _getLocalFile()).writeAsString('$_counter');
  }

  Future download2() async {
    try {
      Response response = await Dio().get(
        'http://d18.aixdzs.com/184/184207/184207.epub',
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      print(response.headers);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File(dir + '/sanguoyanyi.epub');
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  Future<int> read2() async {
    try {
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File(dir + '/sanguoyanyi.epub');
      // read the variable as a string from the file.
//      String contents = await file.readAsString();
      List<int> bytes = await file.readAsBytes();

// Opens a book and reads all of its content into memory
      EpubBook epubBook = await EpubReader.readBook(bytes);
      print(epubBook.Title);

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
      });
//      return int.parse(contents);
    } on FileSystemException {
      return 0;
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('文件读写'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                RaisedButton(
                  onPressed: download2,
                  child: Text('download File'),
                ),
                RaisedButton(
                  onPressed: read2,
                  child: Text('read2 File'),
                ),
                RaisedButton(
                  onPressed: _getLocalFile,
                  child: Text('new File'),
                ),
                RaisedButton(
                  onPressed: _readCounter,
                  child: Text('read File'),
                ),
                RaisedButton(
                  onPressed: _incrementCounter,
                  child: Text('increment Counter'),
                ),
                Text('Button tapped $_counter time${_counter == 1 ? '' : 's'}.'),
                chapters.isNotEmpty
                    ? Column(
                        children: chapters.map<Widget>((item) {
                        return Column(
                          children: <Widget>[
                            Container(
                              child: Text('${item.Title}'),
                            ),
                            Container(
                              child: Text('${item.HtmlContent}'),
                            )
                          ],
                        );
                      }).toList())
                    : Placeholder(
                        fallbackWidth: 1,
                        fallbackHeight: 1,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
