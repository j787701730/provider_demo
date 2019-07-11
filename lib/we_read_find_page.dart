import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Color(0xffEDEEF0),
        Color(0xffE3E4E6),
        Color(0xffEBECEE),
      ], begin: FractionalOffset(1, 0), end: FractionalOffset(1, 1))),
      child: Container(
        margin: EdgeInsets.only(
            left: ScreenUtil.getInstance().setWidth(15),
            top: ScreenUtil.getInstance().setWidth(28),
            bottom: ScreenUtil.getInstance().setWidth(28),
            right: ScreenUtil.getInstance().setWidth(15)),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(ScreenUtil.getInstance().setWidth(14)))),
        child: widget.index == 0
            ? Container(
                padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(40)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '为你推荐',
                      style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(32)),
                    ),
                    Container(
                      height: ScreenUtil.getInstance().setWidth(20),
                    ),
                    Text(
                      '基于你的阅读历史计算，每日更新',
                      style: TextStyle(
                          fontSize: ScreenUtil.getInstance().setSp(22), color: Color(0xffAFAFAF)),
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
                      margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(40)),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Image.asset(
                          'images/${list[widget.index]['image']}.png',
                          width: ScreenUtil.getInstance().setWidth(235),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(40)),
                        color: Color(0xffF9F4EA),
                        padding: EdgeInsets.only(
                            top: ScreenUtil.getInstance().setHeight(24),
                            bottom: ScreenUtil.getInstance().setHeight(20),
                            left: ScreenUtil.getInstance().setWidth(36),
                            right: ScreenUtil.getInstance().setWidth(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '西游记',
                                  style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(28)),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
//                                  top: ScreenUtil.getInstance().setHeight(10),
                                      ),
                                  child: Text(
                                    '天津神界漫画',
                                    style: TextStyle(
                                        fontSize: ScreenUtil.getInstance().setSp(20),
                                        color: Color(0xff7D725C)),
                                  ),
                                )
                              ],
                            ),
                            GestureDetector(
                              child: Container(
                                width: ScreenUtil.getInstance().setWidth(150),
                                height: ScreenUtil.getInstance().setHeight(48),
                                decoration: BoxDecoration(
                                    color: Color(0xffE6D0A0),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(ScreenUtil.getInstance().setWidth(48)))),
                                child: Center(
                                  child: Text(
                                    '分享免费领',
                                    style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(24)),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(60)),
                        padding: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(36)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Image.asset(
                              'images/yinhao.png',
                              width: ScreenUtil.getInstance().setWidth(35),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: ScreenUtil.getInstance().setHeight(16),
                              ),
                              child: Text(
                                '国漫新纪元由此开始',
                                style: TextStyle(
                                    fontSize: ScreenUtil.getInstance().setWidth(20),
                                    color: Color(0xff29303A)),
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(70)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              '更多免费好书领不停',
                              style: TextStyle(
                                  color: Color(0xff1B88EE),
                                  fontSize: ScreenUtil.getInstance().setSp(22)),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Color(0xff1B88EE),
                              size: ScreenUtil.getInstance().setWidth(32),
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(
                    padding: EdgeInsets.all(ScreenUtil.getInstance().setWidth(40)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '为你推荐',
                          style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(32)),
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
                          margin: EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(40)),
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
                  ),
      ),
    );
  }
}
