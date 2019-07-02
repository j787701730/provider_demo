import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:reorderables/reorderables.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'dart:math';

class MyAppEditor extends StatefulWidget {
  final nav;

  MyAppEditor(this.nav);

  @override
  _MyAppEditorState createState() => _MyAppEditorState();
}

class _MyAppEditorState extends State<MyAppEditor> with TickerProviderStateMixin {
  bool isEditor = false;
  List nav = [
    {'image': 'nav_1', 'name': '运动'},
    {'image': 'nav_2', 'name': '余额宝'},
    {'image': 'nav_3', 'name': '奖励金'},
    {'image': 'nav_4', 'name': '体育服务'},
    {'image': 'nav_5', 'name': '蚂蚁森林'},
    {'image': 'nav_6', 'name': '蚂蚁庄园'},
    {'image': 'nav_7', 'name': '花呗'},
  ];
  List tempNav = [
    {'image': 'nav_1', 'name': '运动'},
    {'image': 'nav_2', 'name': '余额宝'},
    {'image': 'nav_3', 'name': '奖励金'},
    {'image': 'nav_4', 'name': '体育服务'},
    {'image': 'nav_5', 'name': '蚂蚁森林'},
    {'image': 'nav_6', 'name': '蚂蚁庄园'},
    {'image': 'nav_7', 'name': '花呗'},
  ];

  List allNav = [
    {'image': 'nav_1', 'name': '运动'},
    {'image': 'nav_2', 'name': '余额宝'},
    {'image': 'nav_3', 'name': '奖励金'},
    {'image': 'nav_4', 'name': '体育服务'},
    {'image': 'nav_5', 'name': '蚂蚁森林'},
    {'image': 'nav_6', 'name': '蚂蚁庄园'},
    {'image': 'nav_7', 'name': '花呗'},
    {'image': 'nav_8', 'name': '充值中心'},
    {'image': 'nav_9', 'name': '小程序收藏'},
    {'image': 'nav_10', 'name': '城市服务'},
    {'image': 'nav_11', 'name': '交通出行'},
    {'image': 'nav_12', 'name': '我的快递'},
    {'image': 'nav_13', 'name': '红包'},
    {'image': 'nav_14', 'name': '蚂蚁保险'},
    {'image': 'nav_15', 'name': '信用卡还款'},
    {'image': 'nav_16', 'name': '生活缴费'},
    {'image': 'nav_17', 'name': '医疗保险'},
    {'image': 'nav_18', 'name': '记账本'},
    {'image': 'nav_19', 'name': '发票管家'},
  ];

  AnimationController animationController;
  Animation animation;
  Animation animationColor;
  CurvedAnimation curve;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nav = widget.nav;
    tempNav = widget.nav;
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    curve = CurvedAnimation(parent: animationController, curve: Curves.ease);
    animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    animationColor = ColorTween(begin: Colors.white, end: Color(0xffF7F7F7)).animate(curve);

    animationController.addListener(() {
//      print(animationController.value);
      setState(() {});
    });

//    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
//    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown]);
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarIconBrightness: Brightness.dark));
//    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.red));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    animationController.dispose();
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      var row = nav.removeAt(oldIndex);
      nav.insert(newIndex, row);
    });
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0,
        titleSpacing: 0,
        title: Container(
          child: isEditor
              ? Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        List temp = jsonDecode(jsonEncode(tempNav));
                        animationController.reverse();
                        setState(() {
                          nav = temp;
                          isEditor = !isEditor;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil.getInstance().setWidth(24),
                          right: ScreenUtil.getInstance().setWidth(24),
                        ),
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: Color(0xff108EE9),
                            fontSize: ScreenUtil.getInstance().setSp(30),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Center(
                      child: Text(
                        '我的应用编辑',
                        style: TextStyle(
                          color: Color(0xff333333),
                          fontSize: ScreenUtil.getInstance().setSp(30),
                        ),
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        List temp = jsonDecode(jsonEncode(nav));
                        animationController.reverse();
                        setState(() {
                          isEditor = !isEditor;
                          tempNav = temp;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil.getInstance().setWidth(24),
                          right: ScreenUtil.getInstance().setWidth(24),
                        ),
                        child: Text(
                          '完成',
                          style: TextStyle(
                            color: Color(0xff108EE9),
                            fontSize: ScreenUtil.getInstance().setSp(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          List temp = jsonDecode(jsonEncode(nav));
                          temp.add({'image': 'more', 'name': '更多'});
                          Navigator.of(context).pop(temp);
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: ScreenUtil.getInstance().setWidth(26),
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.arrow_back_ios,
                                size: ScreenUtil.getInstance().setSp(40),
                                color: Color(0xff108EE9),
                              ),
                              Text(
                                '首页',
                                style: TextStyle(
                                    fontSize: ScreenUtil.getInstance().setSp(30),
                                    color: Color(0xff108EE9)),
                              )
                            ],
                          ),
                        )),
                    Expanded(
                        child: Container(
                      height: ScreenUtil.getInstance().setHeight(50),
                      padding: EdgeInsets.only(
                        left: ScreenUtil.getInstance().setWidth(24),
                      ),
                      margin: EdgeInsets.only(
                        right: ScreenUtil.getInstance().setWidth(24),
                        left: ScreenUtil.getInstance().setWidth(24),
                      ),
                      color: Color(0xffF3F3F3),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.search,
                            color: Color(0xff999999),
                            size: ScreenUtil.getInstance().setSp(40),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Text(
                              '全部应用',
                              style: TextStyle(
                                color: Color(0xff999999),
                                fontSize: ScreenUtil.getInstance().setSp(26),
                              ),
                            ),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
        ),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            isEditor
                ? Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                      top: ScreenUtil.getInstance().setHeight(15),
                      bottom: ScreenUtil.getInstance().setHeight(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                            left: ScreenUtil.getInstance().setWidth(24),
                            right: ScreenUtil.getInstance().setWidth(24),
                          ),
                          margin: EdgeInsets.only(
                            right: ScreenUtil.getInstance().setWidth(10),
                          ),
                          child: Row(
                            children: <Widget>[
                              Text(
                                '我的应用',
                                style: TextStyle(
                                  fontSize: ScreenUtil.getInstance().setSp(26),
                                ),
                              ),
                              Text(
                                '(按住拖动调整排序)',
                                style: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: ScreenUtil.getInstance().setSp(26),
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          child: ReorderableWrap(
                            onReorder: _onReorder,
                            onNoReorder: (int index) {
                              //this callback is optional
                              debugPrint(
                                  '${DateTime.now().toString().substring(5, 22)} reorder cancelled. index:$index');
                            },
                            onReorderStarted: (int index) {
                              //this callback is optional
                              debugPrint(
                                  '${DateTime.now().toString().substring(5, 22)} reorder started: index:$index');
                            },
                            children: nav.map<Widget>((item) {
                              if (item.isEmpty) {
                                return Container(
                                  margin: EdgeInsets.all(
                                    ScreenUtil.getInstance().setWidth(8),
                                  ),
                                  height: ScreenUtil.getInstance().setHeight(100),
                                  width: (width - ScreenUtil.getInstance().setWidth(64)) / 4,
                                  child: Image.asset(
                                    'images/border.png',
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return Container(
                                  color: Color(0xffF7F7F7),
                                  height: ScreenUtil.getInstance().setHeight(100),
                                  width: (width - ScreenUtil.getInstance().setWidth(64)) / 4,
                                  margin: EdgeInsets.all(
                                    ScreenUtil.getInstance().setWidth(8),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width: (width - ScreenUtil.getInstance().setWidth(64)) / 4 -
                                            ScreenUtil.getInstance().setWidth(16),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'images/${item['image']}.png',
                                              width: ScreenUtil.getInstance().setWidth(50),
                                            ),
                                            Text(
                                              item['name'],
                                              style: TextStyle(
                                                fontSize: ScreenUtil.getInstance().setSp(20),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          right: ScreenUtil.getInstance()
                                              .setWidth(20 - animation.value * 10),
                                          top: ScreenUtil.getInstance()
                                              .setWidth(20 - animation.value * 10),
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                nav.remove(item);
                                              });
                                            },
                                            child: Icon(
                                              Icons.remove_circle,
                                              color: Color(0xffF15A4A),
                                              size: animation.value * 24,
                                            ),
                                          ))
                                    ],
                                  ),
                                );
                              }
                            }).toList(),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                      left: ScreenUtil.getInstance().setWidth(24),
                      right: ScreenUtil.getInstance().setWidth(24),
                      top: ScreenUtil.getInstance().setHeight(15),
                      bottom: ScreenUtil.getInstance().setHeight(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            right: ScreenUtil.getInstance().setWidth(10),
                          ),
                          child: Text(
                            '我的应用',
                            style: TextStyle(
                              fontSize: ScreenUtil.getInstance().setSp(26),
                            ),
                          ),
                        ),
                        Expanded(
                            child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: double.infinity,
                                  //宽度尽可能大
                                  minHeight: ScreenUtil.getInstance().setHeight(50),
                                  //最小高度为50像素
                                  maxHeight: ScreenUtil.getInstance().setHeight(50),
                                ),
                                child: Wrap(
                                  children: nav.map<Widget>((item) {
                                    return item.isEmpty
                                        ? Placeholder(
                                            fallbackWidth: 0,
                                            fallbackHeight: 0,
                                            color: Colors.transparent,
                                          )
                                        : Container(
                                            margin: EdgeInsets.only(
                                              left: ScreenUtil.getInstance().setWidth(8),
                                              right: ScreenUtil.getInstance().setWidth(8),
                                            ),
                                            padding: EdgeInsets.only(
                                              top: ScreenUtil.getInstance().setHeight(5),
                                              bottom: ScreenUtil.getInstance().setHeight(5),
                                            ),
                                            child: Image.asset(
                                              'images/${item['image']}.png',
                                              width: ScreenUtil.getInstance().setHeight(40),
                                            ),
                                          );
                                  }).toList(),
                                ))),
                        Container(
                          child: GestureDetector(
                            onTap: () {
                              animationController.forward();
                              setState(() {
                                isEditor = !isEditor;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                left: ScreenUtil.getInstance().setWidth(15),
                                right: ScreenUtil.getInstance().setWidth(15),
                                top: ScreenUtil.getInstance().setHeight(5),
                                bottom: ScreenUtil.getInstance().setHeight(5),
                              ),
                              decoration:
                                  BoxDecoration(border: Border.all(color: Color(0xff108EE9))),
                              child: Text(
                                '编辑',
                                style: TextStyle(
                                    fontSize: ScreenUtil.getInstance().setSp(22),
                                    color: Color(0xff108EE9)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
            Container(
              height: ScreenUtil.getInstance().setHeight(13),
              color: Color(0xffF6F6FA),
            ),
            Container(
              padding: EdgeInsets.only(
                top: ScreenUtil.getInstance().setHeight(10),
                bottom: ScreenUtil.getInstance().setHeight(10),
              ),
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Wrap(
                    children: allNav.map<Widget>((item) {
                      bool flag = true;
                      if (isEditor) {
                        for (var o in nav) {
                          if (o['name'] == item['name']) {
                            flag = false;
                            break;
                          }
                        }
                      }
                      return flag
                          ? Container(
//                              color: isEditor ? Color(0xffF7F7F7) : Colors.white,
                              color: animationColor.value,
                              height: ScreenUtil.getInstance().setHeight(100),
                              width: (width - ScreenUtil.getInstance().setWidth(64)) / 4,
                              margin: EdgeInsets.all(
                                ScreenUtil.getInstance().setWidth(8),
                              ),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    width: (width - ScreenUtil.getInstance().setWidth(64)) / 4 -
                                        ScreenUtil.getInstance().setWidth(16),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'images/${item['image']}.png',
                                          width: ScreenUtil.getInstance().setWidth(50),
                                        ),
                                        Text(
                                          item['name'],
                                          style: TextStyle(
                                            fontSize: ScreenUtil.getInstance().setSp(20),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      right: ScreenUtil.getInstance()
                                          .setWidth(20 - animation.value * 10),
                                      top: ScreenUtil.getInstance()
                                          .setWidth(20 - animation.value * 10),
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            nav.add(item);
                                          });
                                        },
                                        child: Icon(
                                          Icons.add_circle,
                                          color: Color(0xff1D8FE1),
                                          size: animation.value * 24,
                                        ),
                                      ))
                                ],
                              ),
                            )
                          : Placeholder(
                              fallbackWidth: 0,
                              fallbackHeight: 0,
                              color: Colors.transparent,
                            );
                    }).toList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
