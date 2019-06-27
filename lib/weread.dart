import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WeRead extends StatefulWidget {
  @override
  _WeReadState createState() => _WeReadState();
}

class _WeReadState extends State<WeRead> {
  var width;
  var top;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    width = MediaQuery.of(context).size.width;
    top = MediaQuery.of(context).padding.top +
        ScreenUtil.getInstance().setHeight(48.0);
    return Scaffold(
      backgroundColor: Color(0xffE3E4E6),
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          child: Text('微信读书'),
        ),
      ),
      body: PageView(
        controller: PageController(viewportFraction: 0.7875),
        children: <Widget>[
          WeReadFindPage(0),
          WeReadFindPage(1),
          WeReadFindPage(2)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: ScreenUtil.getInstance().setSp(18),
        unselectedFontSize: ScreenUtil.getInstance().setSp(18),
        selectedItemColor: Color(0xff1B88EE),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Image.asset('images/weread1.png'), title: Text('发现')),
          BottomNavigationBarItem(
              icon: Image.asset('images/weread2.png'), title: Text('书架')),
          BottomNavigationBarItem(
              icon: Image.asset('images/weread3.png'), title: Text('想法')),
          BottomNavigationBarItem(
              icon: Image.asset('images/weread4.png'), title: Text('我')),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class WeReadFindPage extends StatefulWidget {
  final index;

  WeReadFindPage(this.index);

  @override
  _WeReadFindPageState createState() => _WeReadFindPageState();
}

class _WeReadFindPageState extends State<WeReadFindPage> {
  List list = [
    {
      'images': [
        'book1',
        'book2',
        'book3',
        'book4',
      ]
    },
    {'image': 'xyj'},
    {'image': 'xz'}
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    return Container(
      margin: EdgeInsets.only(
          left: ScreenUtil.getInstance().setWidth(15),
          top: ScreenUtil.getInstance().setWidth(28),
          bottom: ScreenUtil.getInstance().setWidth(28),
          right: ScreenUtil.getInstance().setWidth(15)),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
              Radius.circular(ScreenUtil.getInstance().setWidth(14)))),
      child: widget.index == 0
          ? Container(
              padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(40)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    '为你推荐',
                    style:
                        TextStyle(fontSize: ScreenUtil.getInstance().setSp(32)),
                  ),
                  Container(
                    height: ScreenUtil.getInstance().setWidth(20),
                  ),
                  Text(
                    '基于你的阅读历史计算，每日更新',
                    style: TextStyle(
                        fontSize: ScreenUtil.getInstance().setSp(22),
                        color: Color(0xffAFAFAF)),
                  ),
                  Container(
                    height: ScreenUtil.getInstance().setWidth(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil.getInstance().setWidth(182),
                        child: Image.asset(
                          'images/book1.png',
                        ),
                      ),
                      Container(
                        width: ScreenUtil.getInstance().setWidth(182),
                        child: Image.asset(
                          'images/book2.png',
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: ScreenUtil.getInstance().setWidth(30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: ScreenUtil.getInstance().setWidth(182),
                        child: Image.asset(
                          'images/book3.png',
                        ),
                      ),
                      Container(
                        width: ScreenUtil.getInstance().setWidth(182),
                        child: Image.asset(
                          'images/book4.png',
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: ScreenUtil.getInstance().setHeight(40)),
                    child: Center(
                      child: Text(
                        '换一批',
                        style: TextStyle(
                            color: Color(0xff1B88EE),
                            fontSize: ScreenUtil.getInstance().setSp(22)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : widget.index == 1
              ? Column(
                  children: <Widget>[],
                )
              : Column(
                  children: <Widget>[],
                ),
    );
  }
}
