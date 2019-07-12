import 'package:flutter/material.dart';
import 'dart:io';

import 'package:epub/epub.dart' as equb;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';

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
  bool showMenu = true;
  int background = 0xffFCF7E8;
  int fontColor = 0xff272623;
  double fontSize = 20;
  Timer _timer;
  int menuIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ScrollController();
    _timer = new Timer(const Duration(milliseconds: 300), () {
      _readShared();
    });
  }

  // md5 加密
  String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  _saveShared(background, fontColor, fontSize) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('background', background);
    preferences.setInt('fontColor', fontColor);
    preferences.setDouble('fontSize', fontSize);
  }

  _saveBookIndexShared(bookIndex) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('${generateMd5(widget.info['path'])}', bookIndex);
  }

  _readShared() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      background =
          preferences.get('background') == null ? 0xffffffff : preferences.get('background');
      fontColor = preferences.get('fontColor') == null ? 0xff272623 : preferences.get('fontColor');
      fontSize = preferences.get('fontSize') == null ? 20 : preferences.get('fontSize');
      bookIndex = preferences.get('${generateMd5(widget.info['path'])}') == null
          ? 0
          : preferences.get('${generateMd5(widget.info['path'])}');
      read();
    });
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
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: Container(
          color: Color(background),
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
                      _saveBookIndexShared(chapters.indexOf(item));
                      setState(() {
                        showMenu = true;
                      });
                    },
                    child: Container(
                      width: width,
                      padding: EdgeInsets.only(top: 4, bottom: 4, left: 6, right: 6),
                      child: Text(
                        '${item.Title}',
                        style: TextStyle(
                          fontSize: 20,
                          color:
                              Color(bookIndex == chapters.indexOf(item) ? 0xff4285F4 : 0xff333333),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
      ),
      body: SafeArea(
          child: content != null
              ? Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      color: Color(background),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showMenu = !showMenu;
                          });
                        },
                        child: ListView(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          controller: _controller,
                          children: <Widget>[
                            Html(
                              data: '${content.HtmlContent}',
                              defaultTextStyle:
                                  TextStyle(fontSize: fontSize, color: Color(fontColor)),
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
                                            _saveBookIndexShared(idx - 1);
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
                                            _saveBookIndexShared(idx + 1);
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
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        child: Offstage(
                          offstage: showMenu,
                          child: Container(
                            color: Color(background),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  height: ScreenUtil.getInstance().setHeight(1),
                                  width: width,
                                  color: Color(0xffDDD7C4),
                                ),
                                Offstage(
                                  offstage: !(menuIndex == 1),
                                  child: Container(
                                    width: width,
                                    height: 50,
                                    child: Text('进度条'),
                                  ),
                                ),
                                // 亮度+颜色
                                Offstage(
                                  offstage: !(menuIndex == 2),
                                  child: Container(
                                    width: width,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: ScreenUtil.getInstance().setWidth(44),
                                            right: ScreenUtil.getInstance().setWidth(44),
                                            top: ScreenUtil.getInstance().setHeight(20),
                                            bottom: ScreenUtil.getInstance().setHeight(20),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    background = 0xffffffff;
                                                    fontColor = 0xff272623;
                                                    _saveShared(0xffffffff, 0xff272623, fontSize);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffffffff),
                                                    border: Border.all(
                                                        color: Color(background == 0xffffffff
                                                            ? 0xfff565A5E
                                                            : 0xffffffff),
                                                        width:
                                                            ScreenUtil.getInstance().setWidth(3)),
                                                  ),
                                                  width: (width -
                                                          ScreenUtil.getInstance().setWidth(150)) /
                                                      4,
                                                  height: ScreenUtil.getInstance().setWidth(48),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    background = 0xffFCF7E8;
                                                    fontColor = 0xff272623;
                                                    _saveShared(0xffFCF7E8, 0xff272623, fontSize);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffFCF7E8),
                                                    border: Border.all(
                                                        color: Color(background == 0xffFCF7E8
                                                            ? 0xfff565A5E
                                                            : 0xffFCF7E8),
                                                        width:
                                                            ScreenUtil.getInstance().setWidth(3)),
                                                  ),
                                                  width: (width -
                                                          ScreenUtil.getInstance().setWidth(150)) /
                                                      4,
                                                  height: ScreenUtil.getInstance().setWidth(48),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    background = 0xffCCF0CF;
                                                    fontColor = 0xff272623;
                                                    _saveShared(0xffCCF0CF, 0xff272623, fontSize);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xffCCF0CF),
                                                    border: Border.all(
                                                        color: Color(background == 0xffCCF0CF
                                                            ? 0xfff565A5E
                                                            : 0xffCCF0CF),
                                                        width:
                                                            ScreenUtil.getInstance().setWidth(3)),
                                                  ),
                                                  width: (width -
                                                          ScreenUtil.getInstance().setWidth(150)) /
                                                      4,
                                                  height: ScreenUtil.getInstance().setWidth(48),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    background = 0xfff101418;
                                                    fontColor = 0xff6A6E72;
                                                    _saveShared(0xfff101418, 0xff6A6E72, fontSize);
                                                  });
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Color(0xfff101418),
                                                    border: Border.all(
                                                        color: Color(background == 0xfff101418
                                                            ? 0xfff565A5E
                                                            : 0xfff101418),
                                                        width:
                                                            ScreenUtil.getInstance().setWidth(3)),
                                                  ),
                                                  width: (width -
                                                          ScreenUtil.getInstance().setWidth(150)) /
                                                      4,
                                                  height: ScreenUtil.getInstance().setWidth(48),
                                                  child: Center(
                                                    child: Transform.rotate(
                                                      angle: 45 * 3.14 / 180,
                                                      child: Icon(
                                                        Icons.brightness_3,
                                                        color: Color(0xff3A72A6),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Offstage(
                                  offstage: !(menuIndex == 3),
                                  child: Container(
                                    padding: EdgeInsets.only(top: 10),
                                    width: width,
                                    height: 60,
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(
                                                left: ScreenUtil.getInstance().setWidth(44),
                                              ),
                                              child: Text('A'),
                                            ),
                                            Expanded(
                                                child: Slider(
//                                          label: '$fontSize',
                                                    activeColor: Color(0xffCFCBBB),
                                                    inactiveColor: Color(0xffCFCBBB),
                                                    value: fontSize,
                                                    min: 20,
                                                    max: 30,
                                                    divisions: 10,
                                                    onChanged: (val) {
                                                      setState(() {
                                                        fontSize = val;
                                                        _saveShared(background, fontColor, val);
                                                      });
                                                    })),
                                            Container(
                                              padding: EdgeInsets.only(
                                                right: ScreenUtil.getInstance().setWidth(44),
                                              ),
                                              child: Text(
                                                'A',
                                                style: TextStyle(fontSize: 30),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: width,
                                  child: Row(
                                    children: <Widget>[
                                      InkWell(
                                        onTap: () {
                                          _scaffoldKey.currentState.openDrawer();
                                          setState(() {
                                            menuIndex = 0;
                                          });
                                        },
                                        child: Container(
                                          width: width / 4,
                                          height: ScreenUtil.getInstance().setHeight(112),
                                          child: Icon(
                                            Icons.menu,
                                            color: Color(fontColor),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            menuIndex = 1;
                                          });
                                        },
                                        child: Container(
                                          width: width / 4,
                                          height: ScreenUtil.getInstance().setHeight(112),
                                          child: Icon(
                                            Icons.adjust,
                                            color: Color(fontColor),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            menuIndex = 2;
                                          });
                                        },
                                        child: Container(
                                          width: width / 4,
                                          height: ScreenUtil.getInstance().setHeight(112),
                                          child: Icon(
                                            Icons.wb_sunny,
                                            color: Color(fontColor),
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            menuIndex = 3;
                                          });
                                        },
                                        child: Container(
                                          width: width / 4,
                                          height: ScreenUtil.getInstance().setHeight(112),
                                          child: Icon(
                                            Icons.font_download,
                                            color: Color(fontColor),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ))
                  ],
                )
              : Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )),
    );
  }
}
