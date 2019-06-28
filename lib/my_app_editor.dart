import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppEditor extends StatefulWidget {
  @override
  _MyAppEditorState createState() => _MyAppEditorState();
}

class _MyAppEditorState extends State<MyAppEditor> {
  bool isEditor = false;
  List nav = [
    {'image': 'nav_1', 'name': '运动'},
    {'image': 'nav_2', 'name': '余额宝'},
    {'image': 'nav_3', 'name': '奖励金'},
    {'image': 'nav_4', 'name': '体育服务'},
    {'image': 'nav_5', 'name': '蚂蚁森林'},
    {'image': 'nav_6', 'name': '蚂蚁庄园'},
    {'image': 'nav_7', 'name': '花呗'},
    {}
  ];

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
                        setState(() {
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
                        setState(() {
                          isEditor = !isEditor;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: ScreenUtil.getInstance().setWidth(24),
                          right: ScreenUtil.getInstance().setWidth(24),
                        ),
                        child: Text(
                          '完成',
                          style: TextStyle(color: Color(0xff108EE9)),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: <Widget>[
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
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
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(30),
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
                          child: Wrap(
                            children: nav.map<Widget>((item) {
                              if (item.isEmpty) {
                                return Container(
                                  margin: EdgeInsets.all(
                                    ScreenUtil.getInstance().setWidth(8),
                                  ),
                                  height:
                                      ScreenUtil.getInstance().setHeight(100),
                                  width: (width -
                                          ScreenUtil.getInstance()
                                              .setWidth(64)) /
                                      4,
                                  child: Image.asset(
                                    'images/border.png',
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                return Container(
                                  color: Color(0xffF7F7F7),
                                  height:
                                      ScreenUtil.getInstance().setHeight(100),
                                  width: (width -
                                          ScreenUtil.getInstance()
                                              .setWidth(64)) /
                                      4,
                                  margin: EdgeInsets.all(
                                    ScreenUtil.getInstance().setWidth(8),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        width: (width -
                                                    ScreenUtil.getInstance()
                                                        .setWidth(64)) /
                                                4 -
                                            ScreenUtil.getInstance()
                                                .setWidth(16),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Image.asset(
                                              'images/${item['image']}.png',
                                              width: ScreenUtil.getInstance()
                                                  .setWidth(50),
                                            ),
                                            Text(
                                              item['name'],
                                              style: TextStyle(
                                                fontSize:
                                                    ScreenUtil.getInstance()
                                                        .setSp(20),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                          right: ScreenUtil.getInstance()
                                              .setWidth(10),
                                          top: ScreenUtil.getInstance()
                                              .setWidth(10),
                                          child: GestureDetector(
                                            child: Icon(
                                              Icons.remove_circle,
                                              color: Color(0xffF15A4A),
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
                    height: 80,
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
                                      left:
                                          ScreenUtil.getInstance().setWidth(8),
                                      right:
                                          ScreenUtil.getInstance().setWidth(8),
                                    ),
                                    padding: EdgeInsets.only(
                                      top:
                                          ScreenUtil.getInstance().setHeight(5),
                                      bottom:
                                          ScreenUtil.getInstance().setHeight(5),
                                    ),
                                    child: Image.asset(
                                      'images/${item['image']}.png',
                                      width: ScreenUtil.getInstance()
                                          .setHeight(40),
                                    ),
                                  );
                          }).toList(),
                        )),
                        Container(
                          child: GestureDetector(
                            onTap: () {
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
                              decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xff108EE9))),
                              child: Text(
                                '编辑',
                                style: TextStyle(
                                    fontSize:
                                        ScreenUtil.getInstance().setSp(22),
                                    color: Color(0xff108EE9)),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
