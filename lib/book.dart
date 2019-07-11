import 'package:flutter/material.dart';
import 'dart:io';

import 'package:epub/epub.dart' as equb;
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import 'dart:async';
import 'package:flutter_html/flutter_html.dart';

class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
  Future<File> _getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/counter1.txt');
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
  equb.EpubChapter content;
  var coverImage;
  List books;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _readCounter().then((int value) {
      setState(() {
        _counter = value;
      });
    });
    _getBooks();
  }

  _getBooks() async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      List booksArr = [];
      directory.listSync().forEach((list) {
        String name = list.path.substring(list.path.lastIndexOf('/') + 1);
        if (name.indexOf('.') > -1) {
          booksArr.add({'name': name.substring(0, name.indexOf('.')), 'path': list.path});
        }
      });
      setState(() {
        books = booksArr;
      });
    } on FileSystemException {
      return 0;
    }
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
        'http://2732256.174.ctc.data.tv002.com/down/19a5cc972c7a19ee03c918e270b3912c/San%20Guo%20Yan%20Yi%20_Xiao%20Zhu%20Ben%20%28S%20-%20%28Ming%20%29Luo%20Guan%20Zhong.epub?cts=dx-f-D27A151A97A54Fe5fcd&ctp=27A151A97A54&ctt=1562803450&limit=1&spd=30000&ctk=19a5cc972c7a19ee03c918e270b3912c&chk=4dc5c27d098bb794d2927cde0a6f5db8-1598714',
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      print(response.headers);
      String dir = (await getApplicationDocumentsDirectory()).path;
      File file = new File(dir + '/三国演义.epub');
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

  _delBook(path) async {
    try {
      Directory directory = await getApplicationDocumentsDirectory();
      directory.listSync().forEach((list) {
//        print(list.path.substring(list.path.lastIndexOf('/') + 1));
        if (path == list.path) {
          list.delete();
        }
      });
      _getBooks();
    } on FileSystemException {
      return 0;
    }
  }

  _deleteBook(context, path, name) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('删除提示'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('确认删除 $name'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                Navigator.of(context).pop();
                _delBook(path);
              },
            ),
          ],
        );
      },
    );
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
        title: Text('文件读写'),
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
//                          Container(
//                            child: Text('${item.Title}'),
//                          ),
//                            Container(
//                            child: Text('${item.HtmlContent}'),
//                          ),
//                            Container(
//                              child: Html(
//                                  data: '${item.HtmlContent}',
////                                padding: EdgeInsets.all(2.0),
//                                  linkStyle: const TextStyle(
//                                    color: Colors.redAccent,
//                                  )),
//                            )
                          ],
                        );
                      }).toList())
                    : Placeholder(
                        fallbackWidth: 1,
                        fallbackHeight: 1,
                      ),
                content != null
                    ? Container(
                        child: Html(
                          data: '${content.HtmlContent}',
                          onLinkTap: (url) {
                            print("Opening $url...");
                          },
//                    customTextAlign: (dom.Node node) {
//                      if (node is dom.Element) {
//                        switch (node.localName) {
//                          case "p":
//                            return TextAlign.justify;
//                        }
//                      }
//                    },
                        ),
                      )
                    : Placeholder(
                        fallbackWidth: 1,
                        fallbackHeight: 1,
                      )
              ],
            ),
            books != null
                ? Container(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                    child: Wrap(
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: books.map<Widget>((item) {
                        return Container(
                          width: (width - 10) / 4,
                          height: (width - 10) / 4 * 3 / 2,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                Center(
                                  child: Text(item['name']),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: IconButton(
                                        color: Colors.red,
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          _deleteBook(context, item['path'], item['name']);
                                        }))
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
