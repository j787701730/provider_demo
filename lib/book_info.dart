import 'package:flutter/material.dart';
import 'dart:io';

import 'package:epub/epub.dart' as epub;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:html/dom.dart' as dom;
import 'package:image/image.dart' as image;

class BookInfo extends StatefulWidget {
  final info;

  BookInfo(this.info);

  @override
  _BookInfoState createState() => _BookInfoState();
}

class _BookInfoState extends State<BookInfo> {
  String title;
  List chapters = [];
  epub.EpubChapter content;
  var coverImage;
  List books;
  String author = '';
  ScrollController _controller;
  ScrollController _catalogController;
  int bookIndex = 0;
  bool showMenu = true;
  int background = 0xffFCF7E8;
  int fontColor = 0xff272623;
  double fontSize = 20;
  Timer _timer;
  Timer _catalogTimer;
  int menuIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _catalogKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ScrollController();
    _catalogController = ScrollController();
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
      epub.EpubBook epubBook = await epub.EpubReader.readBook(bytes);
      setState(() {
        title = epubBook.Title;
        chapters = epubBook.Chapters;
        coverImage = epubBook.CoverImage;
        content = epubBook.Chapters[bookIndex];
        author = epubBook.Author;
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _catalogController.dispose();
    _timer.cancel();
    if (_catalogTimer != null) {
      _catalogTimer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: width * 0.8, minWidth: width * 0.8),
        child: Container(
          color: Color(background),
          child: Column(
            children: <Widget>[
              DrawerHeader(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(right: ScreenUtil.getInstance().setWidth(10)),
                    child: coverImage != null
                        ? Container(
                            width: ScreenUtil.getInstance().setWidth(90),
                            child: Image.memory(
                              image.encodePng(coverImage),
                              fit: BoxFit.fitWidth,
                            ),
                          )
                        : Container(
                            width: ScreenUtil.getInstance().setWidth(90),
                          ),
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '$title',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '$author',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ))
                ],
              )),
              Expanded(
                  key: _catalogKey,
                  flex: 1,
                  child: ListView(
                    controller: _catalogController,
                    padding: EdgeInsets.only(top: 0, left: 6, right: 6, bottom: 0),
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
                          height: 40,
                          child: Text(
                            '${item.Title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(
                                  bookIndex == chapters.indexOf(item) ? 0xff4285F4 : 0xff333333),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ))
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
//                            Text('${content.HtmlContent}'),
                            Html(
                              data: '${content.HtmlContent}'.replaceAll('%', ''),
                              defaultTextStyle: TextStyle(
                                  fontSize: fontSize,
                                  color: Color(fontColor),
                                  locale: Locale('en', 'US'),
                                  fontFamily: 'SourceHanSerifCN',
                                  height: 1.2),
                              customTextAlign: (dom.Node node) {
                                if (node is dom.Element) {
                                  switch (node.localName) {
                                    case "p":
                                      return TextAlign.justify;
                                  }
                                }
                                return null;
                              },
//                              customRender: (node, children) {
//                                print('xxx');
//                                if (node is dom.Element) {
//                                  switch (node.localName) {
//                                    case "p":
//                                      return Column(children: children);
//                                  }
//                                }
//                                return null;
//                              },
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
                        top: 0,
                        left: 0,
                        height: height,
                        width: width,
                        child: Offstage(
                          offstage: showMenu,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                showMenu = !showMenu;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(color: Color(0x33000000)),
                            ),
                          ),
                        )),
                    Positioned(
                        left: 0,
                        top: 0,
                        height: ScreenUtil.getInstance().setHeight(90),
                        width: width,
                        child: Offstage(
                          offstage: showMenu,
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(background),
                                border: Border(
                                    bottom: BorderSide(
                                        color: Color(0xffDDD7C4),
                                        width: ScreenUtil.getInstance().setWidth(1)))),
                            child: Row(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    height: ScreenUtil.getInstance().setWidth(89),
                                    width: ScreenUtil.getInstance().setWidth(89),
                                    child: Icon(Icons.arrow_back_ios),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )),
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
//                                    height: 50,
                                    padding:
                                        EdgeInsets.only(top: ScreenUtil.getInstance().setWidth(10)),
                                    child: Column(
                                      children: <Widget>[
                                        Text('$bookIndex'),
                                        Row(
                                          children: <Widget>[
                                            Container(
                                              padding: EdgeInsets.only(
                                                left: ScreenUtil.getInstance().setWidth(44),
                                              ),
                                              child: Icon(
                                                Icons.chevron_left,
                                              ),
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Slider(
                                                  activeColor: Color(0xfff565A5E),
                                                  inactiveColor: Color(0xffCFCBBB),
                                                  value: bookIndex.toDouble(),
                                                  min: 0,
                                                  label: bookIndex.toString(),
                                                  max: chapters.length.toDouble(),
                                                  divisions: chapters.length,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      bookIndex = val.toInt();
                                                    });
                                                  },
                                                  onChangeEnd: (val) {
                                                    setState(() {
                                                      bookIndex = val.toInt();
                                                      _readIndex(val.toInt());
                                                      _saveBookIndexShared(val.toInt());
                                                      showMenu = !showMenu;
                                                    });
                                                  },
                                                )),
                                            Container(
                                              padding: EdgeInsets.only(
                                                right: ScreenUtil.getInstance().setWidth(44),
                                              ),
                                              child: Icon(
                                                Icons.chevron_right,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
                                          _catalogTimer =
                                              Timer(const Duration(milliseconds: 300), () {
                                            double conHeight =
                                                _catalogKey.currentContext.size.height;
                                            if ((chapters.length - bookIndex) <
                                                conHeight ~/ 40 / 2) {
                                              if (bookIndex > chapters.length - conHeight ~/ 40) {
                                                _catalogController.jumpTo((bookIndex -
                                                        conHeight ~/ 40 +
                                                        conHeight ~/ 40 ~/ 3) *
                                                    40.0);
                                              } else {
                                                _catalogController
                                                    .jumpTo((bookIndex - conHeight ~/ 40) * 40.0);
                                              }
                                            } else if (conHeight ~/ 40 / 2 < bookIndex) {
                                              if (bookIndex > conHeight ~/ 40 / 2) {
                                                _catalogController.jumpTo(
                                                    (bookIndex - conHeight ~/ 40 ~/ 2) * 40.0);
                                              }
                                            }
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
