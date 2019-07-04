import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AntManor extends StatefulWidget {
  @override
  _AntManorState createState() => _AntManorState();
}

class _AntManorState extends State<AntManor> with TickerProviderStateMixin {
  Timer _timer;
  Timer _timer2;
  int _countdownTime = 5 * 60 * 60 - 1;

  @override
  void initState() {
    super.initState();
    startCountdownTimer2();
  }

  void startCountdownTimer() {
    if (_timer2 != null) {
      _timer2.cancel();
    }
    const oneSec = const Duration(milliseconds: 16);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_countdownTime < 4 * 60 * 60) {
        setState(() {
          _timer.cancel();
          startCountdownTimer2();
        });
      } else {
        setState(() {
          _countdownTime = _countdownTime - 60;
        });
      }
    });
  }

  void startCountdownTimer2() {
    const oneSec = const Duration(seconds: 1);
    _timer2 = Timer.periodic(oneSec, (timer) {
      if (_countdownTime < 1) {
        setState(() {
          _timer2.cancel();
          _countdownTime = 0;
        });
      } else {
        setState(() {
          _countdownTime = _countdownTime - 1;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
    if (_timer2 != null) {
      _timer2.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 158 - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    return Scaffold(
      backgroundColor: Color(0xffB7EAFF),
      appBar: AppBar(
        title: Text('蚂蚁庄园Flutter'),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 60,
            child: RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: startCountdownTimer,
              child: Text('start'),
            ),
          ),
          Container(
            child: Text('$_countdownTime'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: ScreenUtil.getInstance().setHeight(40),
                width: ScreenUtil.getInstance().setWidth(134),
                decoration:
                    BoxDecoration(image: DecorationImage(image: AssetImage('images/time.png'))),
                child: Row(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(
                            bottom: ScreenUtil.getInstance().setHeight(6),
                            left: ScreenUtil.getInstance().setWidth(3),
                          ),
                          width: ScreenUtil.getInstance().setWidth(30),
                          height: ScreenUtil.getInstance().setWidth(30),
                          child: Center(
                            child: Transform.rotate(
//                              alignment: Alignment.bottomCenter,
                              origin: Offset(
                                ScreenUtil.getInstance().setWidth(0),
                                ScreenUtil.getInstance().setWidth(5),
                              ),
                              angle: ((60 -
                                      _countdownTime -
                                      (_countdownTime ~/ 3600) * 3600 -
                                      ((_countdownTime - (_countdownTime ~/ 3600) * 3600) ~/ 60) *
                                          60) *
                                  6 *
                                  pi /
                                  180),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(2.0)),
                                  color: Colors.white,
                                ),
                                width: ScreenUtil.getInstance().setWidth(2),
                                height: ScreenUtil.getInstance().setHeight(10),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                            left: ScreenUtil.getInstance().setWidth(15),
                            top: ScreenUtil.getInstance().setWidth(17),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(
                                  ScreenUtil.getInstance().setWidth(6),
                                )),
                                color: Colors.white,
                              ),
                              width: ScreenUtil.getInstance().setWidth(6),
                              height: ScreenUtil.getInstance().setHeight(6),
                            ))
                      ],
                    ),
                    Container(
                        margin: EdgeInsets.only(
                          left: ScreenUtil.getInstance().setWidth(10),
                          top: ScreenUtil.getInstance().setHeight(4),
                        ),
                        alignment: Alignment.centerLeft,
                        child: _countdownTime ~/ 3600 == 0
                            ? Text(
                                '${((_countdownTime - (_countdownTime ~/ 3600) * 3600) ~/ 60)}分'
                                '${_countdownTime - (_countdownTime ~/ 3600) * 3600 - ((_countdownTime - (_countdownTime ~/ 3600) * 3600) ~/ 60) * 60}秒',
                                style: TextStyle(color: Colors.white),
                              )
                            : Text(
                                '${_countdownTime ~/ 3600}小时${((_countdownTime - (_countdownTime ~/ 3600) * 3600) ~/ 60)}分',
                                style: TextStyle(color: Colors.white),
                              )),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
