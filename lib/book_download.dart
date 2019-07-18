import 'package:flutter/material.dart';
import 'dart:io';

import 'package:epub/epub.dart' as equb;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import 'dart:async';
import 'package:toast/toast.dart';

class BookDownload extends StatefulWidget {
  @override
  _BookDownloadState createState() => _BookDownloadState();
}

class _BookDownloadState extends State<BookDownload> {
  String title;
  List chapters = [];
  equb.EpubChapter content;
  var coverImage;
  List books;
  String url;
  String bookName;
  String progress;
  FocusNode _focusNode = FocusNode();
  FocusNode _focusNode2 = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusNode.dispose();
    _focusNode2.dispose();
  }

  Future download2() async {
    _focusNode.unfocus();
    _focusNode2.unfocus();
    if (url == null && bookName == null) {
      Toast.show('下载链接和图书名字不能为空', context, gravity: Toast.CENTER);
      return;
    }
    try {
      Response response = await Dio().get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
//      print(response.headers);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File(dir + '/$bookName.epub');
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      setState(() {
        progress = '下载完成';
      });
    } catch (e) {
      print(e);
    }
  }

  Future<int> read2() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
//      list
      String dir = directory.path;
//      print(directory.listSync().length);
      File file = new File(dir + '/三国演义.epub');
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

  void showDownloadProgress(received, total) {
    if (total != -1) {
//      print((received / total * 100).toStringAsFixed(0) + "%");
      setState(() {
        progress = (received / total * 100).toStringAsFixed(0) + "%";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('图书下载'),
      ),
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
          _focusNode2.unfocus();
        },
        child: Container(
          child: ListView(
            padding: EdgeInsets.only(left: 20, right: 20),
            children: <Widget>[
              Text(
                '图书只支持epub格式',
                style: TextStyle(height: 1.5, color: Colors.red),
              ),
              TextField(
                focusNode: _focusNode,
                decoration: InputDecoration(labelText: '下载链接'),
                onChanged: (text) {
                  setState(() {
                    url = text;
                  });
                },
              ),
              TextField(
                focusNode: _focusNode2,
                decoration: InputDecoration(labelText: '图书名字'),
                onChanged: (text) {
                  setState(() {
                    bookName = text;
                  });
                },
              ),
              Text(
                '下载链接和图书名字都要填',
                style: TextStyle(height: 1.5, color: Colors.orange),
              ),
              RaisedButton(
                color: Colors.green,
                textColor: Colors.white,
                onPressed: download2,
                child: Text('开始下载'),
              ),
              Container(
                child: Center(
                  child: Text(progress == null ? '' : '下载进度: $progress'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
