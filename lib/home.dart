import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'weread.dart';
import 'my_app_editor.dart';
import 'dart:convert';
import 'drifting_bottle.dart';
import 'ant_manor.dart';
import 'ant_manor_loading.dart';
import 'clock.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var width;
  var top;
  bool show = false;
  var colorBg = Colors.white;
  ScrollController _controller = new ScrollController();

  List<Widget> _sliverBuilder(BuildContext context, bool innerBoxIsScrolled) {
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    width = MediaQuery.of(context).size.width;
    return <Widget>[
      SliverAppBar(
        forceElevated: false,
        titleSpacing: 0,
        title: show
            ? Container(
                color: Color(0xff1E82D2),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset(
                            'images/tnav1.png',
                            width: ScreenUtil.getInstance().setWidth(40),
                          ),
                          Image.asset(
                            'images/tnav2.png',
                            width: ScreenUtil.getInstance().setWidth(40),
                          ),
                          Image.asset(
                            'images/tnav3.png',
                            width: ScreenUtil.getInstance().setWidth(40),
                          ),
                          Image.asset(
                            'images/tnav4.png',
                            width: ScreenUtil.getInstance().setWidth(40),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 80, right: 20),
                      child: Image.asset(
                        'images/tnav5.png',
                        width: ScreenUtil.getInstance().setWidth(46),
                      ),
                    )
                  ],
                ))
            : Container(
                margin: EdgeInsets.only(top: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      height: ScreenUtil.getInstance().setHeight(57),
                      margin: EdgeInsets.only(
                          left: ScreenUtil.getInstance().setWidth(20),
                          right: ScreenUtil.getInstance().setHeight(20)),
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(4))),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 30,
                            ),
                            suffixIcon: Icon(
                              Icons.keyboard_voice,
                              size: 30,
                            )),
                      ),
                    )),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(left: ScreenUtil.getInstance().setWidth(20)),
                        child: Center(
                          child: Image.asset(
                            'images/home1.png',
                            width: ScreenUtil.getInstance().setWidth(40),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(
                            left: ScreenUtil.getInstance().setWidth(30),
                            right: ScreenUtil.getInstance().setWidth(20)),
                        child: Center(
                          child: Image.asset(
                            'images/home2.png',
                            width: ScreenUtil.getInstance().setWidth(40),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
        elevation: 0,
        //标题居中
        // centerTitle: true,
        //展开高度200
        expandedHeight:
            MediaQuery.of(context).padding.top + 56 + ScreenUtil.getInstance().setHeight(150.0),
        //不随着滑动隐藏标题
        floating: true,
        //固定在顶部
        pinned: true,
//        backgroundColor: show ? null : Colors.white,
        flexibleSpace: FlexibleSpaceBar(
//          centerTitle: true,
//          title: Text('我是一个FlexibleSpaceBar'),
          collapseMode: CollapseMode.parallax,
          background: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 86),
            color: Color(0xff1E82D2),
            height:
                MediaQuery.of(context).padding.top + 56 + ScreenUtil.getInstance().setHeight(150.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: width / 4,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'images/nav1.png',
                        width: ScreenUtil.getInstance().setWidth(75),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: ScreenUtil.getInstance().setHeight(20),
                        ),
                        child: Text(
                          '扫一扫',
                          style: TextStyle(
                              color: Colors.white, fontSize: ScreenUtil.getInstance().setSp(26)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width / 4,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'images/nav2.png',
                        width: ScreenUtil.getInstance().setWidth(75),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: ScreenUtil.getInstance().setHeight(20),
                        ),
                        child: Text(
                          '付钱',
                          style: TextStyle(
                              color: Colors.white, fontSize: ScreenUtil.getInstance().setSp(26)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width / 4,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'images/nav3.png',
                        width: ScreenUtil.getInstance().setWidth(75),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: ScreenUtil.getInstance().setHeight(20),
                        ),
                        child: Text(
                          '收钱',
                          style: TextStyle(
                              color: Colors.white, fontSize: ScreenUtil.getInstance().setSp(26)),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: width / 4,
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'images/nav4.png',
                        width: ScreenUtil.getInstance().setWidth(75),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          top: ScreenUtil.getInstance().setHeight(20),
                        ),
                        child: Text(
                          '卡包',
                          style: TextStyle(
                              color: Colors.white, fontSize: ScreenUtil.getInstance().setSp(26)),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      )
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      if (top < _controller.offset) {
        setState(() {
          show = true;
        });
      } else {
        setState(() {
          show = false;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback(_position);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback(_position);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  _position(Duration timeStamp) {
    RenderObject renderObject = context.findRenderObject();
    //获取元素大小
    Size size = renderObject.paintBounds.size;
    var vector3 = renderObject.getTransformTo(null)?.getTranslation();
    //获取元素位置
//      var vector3 = renderObject.getTransformTo(null)?.getTranslation();
//      CommonUtils.showChooseDialog(context, size, vector3);
  }

  List nav = [
    {'image': 'nav_1', 'name': '运动'},
    {'image': 'nav_2', 'name': '余额宝'},
    {'image': 'nav_3', 'name': '奖励金'},
    {'image': 'nav_4', 'name': '体育服务'},
    {'image': 'nav_5', 'name': '蚂蚁森林'},
    {'image': 'nav_6', 'name': '蚂蚁庄园'},
    {'image': 'nav_7', 'name': '花呗'},
    {'image': 'more', 'name': '更多'},
  ];

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    width = MediaQuery.of(context).size.width;
    top = MediaQuery.of(context).padding.top + ScreenUtil.getInstance().setHeight(48.0);
    return Scaffold(
      body: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: _sliverBuilder,
          body: Container(
            color: Colors.white,
            child: ListView(
              // shrinkWrap + NeverScrollableScrollPhysics() 阻止ios滑动效果
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.only(top: 0),
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: ScreenUtil.getInstance().setHeight(5),
                      bottom: ScreenUtil.getInstance().setHeight(5)),
                  child: Wrap(
                    children: nav.map<Widget>((item) {
                      return GestureDetector(
                        onTap: () {
                          switch (item['name']) {
                            case '更多':
                              List temp = jsonDecode(jsonEncode(nav));
                              temp.removeLast();
                              Navigator.push(
                                context,
                                new MaterialPageRoute(builder: (context) => new MyAppEditor(temp)),
                              ).then((val) {
                                if (val != null) {
                                  setState(() {
                                    nav = val;
                                  });
                                }
                              });
                              break;
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                              top: ScreenUtil.getInstance().setHeight(15),
                              bottom: ScreenUtil.getInstance().setHeight(15)),
                          width: width / 4,
                          child: Column(
                            children: <Widget>[
                              Image.asset(
                                'images/${item['image']}.png',
                                width: ScreenUtil.getInstance().setWidth(50),
                              ),
                              Container(
                                padding:
                                    EdgeInsets.only(top: ScreenUtil.getInstance().setHeight(10)),
                                child: Text(
                                  '${item['name']}',
                                  style: TextStyle(fontSize: ScreenUtil.getInstance().setSp(20)),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  height: ScreenUtil.getInstance().setHeight(16),
                  color: Color(0xffF6F6F6),
                ),
                Container(
                  height: 60,
                  child: Center(
                    child: FlatButton(
                        color: Colors.green,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (context) => new WeRead()),
                          );
                        },
                        child: Text('微信读书')),
                  ),
                ),
                Container(
                  height: 60,
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new DriftingBottle()),
                        );
                      },
                      child: Text('漂流瓶'),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new AntManorLoading()),
                        );
                      },
                      child: Text('蚂蚁庄园Loading'),
                    ),
                  ),
                ),
                Container(
                  height: 60,
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new AntManor()),
                        );
                      },
                      child: Text('蚂蚁庄园'),
                    ),
                  ),
                ),Container(
                  height: 60,
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          new MaterialPageRoute(builder: (context) => new Clock()),
                        );
                      },
                      child: Text('时钟'),
                    ),
                  ),
                ),
                Container(
                  height: 1000,
                  child: Center(
                    child: Text('1'),
                  ),
                ),
                Container(
                  height: 100,
                  child: Center(
                    child: Text('2'),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
