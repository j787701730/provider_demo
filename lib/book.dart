import 'package:flutter/material.dart';
import 'dart:io';

import 'package:epub/epub.dart' as equb;
import 'package:path_provider/path_provider.dart';
import 'book_info.dart';

import 'dart:async';
import 'package:flutter_html/flutter_html.dart';

class Book extends StatefulWidget {
  @override
  _BookState createState() => _BookState();
}

class _BookState extends State<Book> {
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('书架'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            books != null
                ? Container(
                    padding: EdgeInsets.only(left: 5, right: 5, top: 10),
                    child: Wrap(
                      runSpacing: 10,
                      alignment: WrapAlignment.start,
                      children: books.map<Widget>((item) {
                        return Container(
                          width: (width - 10) / 3,
                          height: (width - 10) / 3 + 30,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Container(
                            decoration: BoxDecoration(border: Border.all(color: Colors.blue)),
                            child: Stack(
                              fit: StackFit.expand,
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => new BookInfo(item)),
                                    );
                                  },
                                  child: Center(
                                    child: Text(item['name']),
                                  ),
                                ),
                                Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: () {
                                        _deleteBook(context, item['path'], item['name']);
                                      },
                                      child: Container(
                                        width: 30,
                                        height: 30,
                                        child: Icon(
                                          Icons.delete,
                                          size: 20,
                                          color: Colors.red,
                                        ),
                                      ),
                                    ))
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
