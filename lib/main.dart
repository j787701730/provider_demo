import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'page.dart';
import 'CounterModel.dart';
import 'dart:async';
import 'home.dart';

void main() {
  final counter = CounterModel();
  final textSize = 48;
  runApp(
    Provider<int>.value(
      value: textSize,
      child: ChangeNotifierProvider.value(
        value: counter,
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
//          primarySwatch: Provider.of<CounterModel>(context).color,
          primaryColor: Color(0xff1E82D2),
          platform: TargetPlatform.iOS),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _tabIndex = 0;
  int count = 0;
  bool _flag = false;

  time2() {
    const timeout = const Duration(seconds: 3);
    print('currentTime=' + DateTime.now().toString());
    setState(() {
      _flag = false;
    });
    Timer(timeout, () {
      //到时回调
//      print('afterTimer=' + DateTime.now().toString());
      setState(() {
        _flag = true;
      });
    });
  }

//  time() {
//    const period = const Duration(seconds: 1);
////    print('currentTime=' + DateTime.now().toString());
//    Timer.periodic(period, (timer) {
//      //到时回调
//      print('afterTimer=' + DateTime.now().toString());
//      count++;
//      if (count >= 5) {
//        //取消定时器，避免无限回调
//        timer.cancel();
//        timer = null;
//      }
//    });
//  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  List pages = [Home(), Page(), Page(), Page()];

  @override
  Widget build(BuildContext context) {
    final _counter = Provider.of<CounterModel>(context);
    final textSize = Provider.of<int>(context).toDouble();
    final width = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    return Scaffold(
//      appBar: AppBar(
//        titleSpacing: 0,
//        elevation: 0,
//        title: Text('home'),
//      ),
      body: PageView(
        children: <Widget>[pages[_tabIndex]],
      ),
//      Stack(
//        children: <Widget>[
//          Container(
//            child: Center(
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Text(
//                    'You have pushed the button this many times:',
//                  ),
//                  Text(
//                    '${_counter.value}',
//                    style: TextStyle(fontSize: textSize),
//                  ),
//                  RaisedButton(
//                    onPressed: time2,
//                    child: Text('定时器'),
//                  ),
//                  Consumer<CounterModel>(
//                    builder: (context, CounterModel counter, child) =>
//                        RaisedButton(
//                          onPressed: () {
//                            counter.changeColor(Colors.red);
//                          },
//                          child: Text('红色主题'),
//                        ),
//                    child: Icon(Icons.add),
//                  )
//                ],
//              ),
//            ),
//          ),
//          Positioned(
//              left: 30,
//              top: 30,
//              child: Offstage(
//                child: Container(
//                  color: Color(0x99000000),
//                  padding:
//                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
//                  child: Text(
//                    '小姐姐',
//                    style: TextStyle(color: Color(0xffffffff)),
//                  ),
//                ),
//                offstage: _flag,
//              ))
//        ],
//      ),
      floatingActionButton: FloatingActionButton(
        onPressed: Provider.of<CounterModel>(context).increment,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
//      BottomNavigationBar(
//        backgroundColor: Colors.red,
//        selectedFontSize: 14,
//        unselectedFontSize: 14,
//        items: <BottomNavigationBarItem>[
//          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('精选')),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.store_mall_directory), title: Text('会员店')),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.shopping_cart), title: Text('购物车')),
//          BottomNavigationBarItem(
//              icon: Icon(Icons.perm_identity), title: Text('我')),
//        ],
//        type: BottomNavigationBarType.fixed,
//        currentIndex: _tabIndex,
//        onTap: (index) {
//          setState(() {
//            _tabIndex = index;
//          });
//        },
//      )

          BottomAppBar(
//        color: Provider.of<CounterModel>(context).color,
        color: Colors.white,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width / 5,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    FlatButton(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.home,
                              color: _tabIndex == 0 ? Color(0xff29A1F7) : Color(0xffdddddd),
                            ),
                            Text(
                              '精选',
                              style: TextStyle(
                                  color: _tabIndex == 0 ? Color(0xff29A1F7) : Color(0xffdddddd)),
                            )
                          ],
                        ),
                        onPressed: () {
                          setState(() {
                            _tabIndex = 0;
                          });
                        }),
                    Positioned(
                        right: width / 10 - 30,
                        top: 0,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                              color: Color(0xffFF0000),
                              borderRadius: BorderRadius.all(Radius.circular(20))),
                          child: Center(
                              child: Consumer<CounterModel>(
                            builder: (context, CounterModel counter, _) => Center(
                                  child: Text(
                                    '${counter.value}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                          )),
                        ))
                  ],
                ),
              ),
              Container(
                width: width / 5,
                child: FlatButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.store_mall_directory,
                          color: _tabIndex == 1 ? Color(0xff29A1F7) : Color(0xffdddddd),
                        ),
                        Text(
                          '会员店',
                          style: TextStyle(
                              color: _tabIndex == 1 ? Color(0xff29A1F7) : Color(0xffdddddd)),
                        )
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        _tabIndex = 1;
                      });
//                      Navigator.push(
//                        context,
//                        new MaterialPageRoute(builder: (context) => new Page()),
//                      );
                    }),
              ),
              Container(
                width: width / 5,
              ),
              Container(
                width: width / 5,
                child: FlatButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add_shopping_cart,
                          color: _tabIndex == 2 ? Color(0xff29A1F7) : Color(0xffdddddd),
                        ),
                        Text(
                          '购物车',
                          style: TextStyle(
                              color: _tabIndex == 2 ? Color(0xff29A1F7) : Color(0xffdddddd)),
                        )
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        _tabIndex = 2;
                      });
                    }),
              ),
              Container(
                width: width / 5,
                child: FlatButton(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.person_outline,
                          color: _tabIndex == 3 ? Color(0xff29A1F7) : Color(0xffdddddd),
                        ),
                        Text(
                          '我',
                          style: TextStyle(
                              color: _tabIndex == 3 ? Color(0xff29A1F7) : Color(0xffdddddd)),
                        )
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        _tabIndex = 3;
                      });
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
