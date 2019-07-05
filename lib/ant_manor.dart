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
  int _countdownTime = 5 * 60 * 60;

  AnimationController animationChickRightHandController;
  Animation animationChickRightHand;
  CurvedAnimation curveChickRightHand;

  @override
  void initState() {
    super.initState();
    startCountdownTimer2();
    chickRightHand();
  }

  void chickRightHand() {
    animationChickRightHandController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    curveChickRightHand =
        CurvedAnimation(parent: animationChickRightHandController, curve: Curves.easeInOutSine);
    animationChickRightHand = Tween(begin: 0.0, end: 1.0).animate(curveChickRightHand);

    animationChickRightHandController.addListener(() {
      setState(() {});
    });

    animationChickRightHandController.addStatusListener((AnimationStatus status) {
//      print('new ${animationChickController.status}');
      if (status == AnimationStatus.completed &&
          animationChickRightHandController != null &&
          _countdownTime != 0) {
        animationChickRightHandController.reverse();
        //当动画在开始处停止再次从头开始执行动画
      } else if (status == AnimationStatus.dismissed &&
          animationChickRightHandController != null &&
          _countdownTime != 0) {
        animationChickRightHandController.forward();
      }
    });
    animationChickRightHandController.forward();
  }

  void startCountdownTimer(limitTime) {
    if (_timer2 != null) {
      _timer2.cancel();
    }
    const oneSec = const Duration(milliseconds: 16);
    _timer = Timer.periodic(oneSec, (timer) {
      if (_countdownTime <= limitTime) {
        setState(() {
          _timer.cancel();
          startCountdownTimer2();
        });
      } else {
        setState(() {
          _countdownTime = _countdownTime > 60 ? _countdownTime - 60 : 0;
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
    if (_timer != null) {
      _timer.cancel();
    }
    if (_timer2 != null) {
      _timer2.cancel();
    }
    animationChickRightHandController.dispose();
    super.dispose();
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
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
                right: 10,
                child: Container(
                  height: 60,
                  width: 200,
                  child: RaisedButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      int limitTime = _countdownTime ~/ 3600;
                      startCountdownTimer(limitTime * 60 * 60);
                    },
                    child: Text('start'),
                  ),
                )),
//            Container(
//              child: Text('$_countdownTime'),
//            ),
            Positioned(
              bottom: ScreenUtil.getInstance().setWidth(323),
              right: ScreenUtil.getInstance().setWidth(60),
              child: Row(
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
                                          ((_countdownTime - (_countdownTime ~/ 3600) * 3600) ~/
                                                  60) *
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
            ),
            Positioned(
                bottom: ScreenUtil.getInstance().setHeight(233),
                right: ScreenUtil.getInstance().setWidth(186),
                child: Container(
                  width: ScreenUtil.getInstance().setWidth(270),
                  height: ScreenUtil.getInstance().setHeight(325),
                  child: Image.asset(
                    'images/chick.png',
                  ),
                )),
            Positioned(
                bottom: ScreenUtil.getInstance().setHeight(311),
                right: ScreenUtil.getInstance().setWidth(196),
                child: Transform.rotate(
                  angle: animationChickRightHand.value * 3 * pi / 180,
                  origin: Offset(ScreenUtil.getInstance().setWidth(64),
                      ScreenUtil.getInstance().setHeight(-49.5)),
                  child: Container(
                    width: ScreenUtil.getInstance().setWidth(128),
                    height: ScreenUtil.getInstance().setHeight(99),
                    child: Image.asset(
                      'images/right_hand.png',
                    ),
                  ),
                )),
            Positioned(
                right: ScreenUtil.getInstance().setWidth(75),
                bottom: ScreenUtil.getInstance()
                    .setHeight((212 + (47 * _countdownTime / (5 * 60 * 60))).toDouble()),
                child: Container(
                  width: ScreenUtil.getInstance().setWidth(108),
                  height: ScreenUtil.getInstance().setHeight(51),
                  child: Image.asset('images/food.png'),
                )),
            Positioned(
                right: ScreenUtil.getInstance().setWidth(60),
                bottom: ScreenUtil.getInstance().setHeight(212),
                child: Container(
                  width: ScreenUtil.getInstance().setWidth(137),
                  height: ScreenUtil.getInstance().setHeight(50),
                  child: Image.asset('images/groove.png'),
                )),
            Positioned(
                right: ScreenUtil.getInstance().setWidth(280),
                bottom:
                    ScreenUtil.getInstance().setHeight(458 - animationChickRightHand.value * 28),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(26))),
                  width: ScreenUtil.getInstance().setWidth(17),
                  height: ScreenUtil.getInstance().setHeight(
                      _countdownTime == 0 || _countdownTime == 5 * 60 * 60
                          ? 0
                          : 0 + animationChickRightHand.value * 28),
                )),
            Positioned(
                right: ScreenUtil.getInstance().setWidth(348),
                bottom:
                    ScreenUtil.getInstance().setHeight(458 - animationChickRightHand.value * 28),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(26))),
                  width: ScreenUtil.getInstance().setWidth(17),
                  height: ScreenUtil.getInstance().setHeight(
                      _countdownTime == 0 || _countdownTime == 5 * 60 * 60
                          ? 0
                          : 0 + animationChickRightHand.value * 28),
                )),
            Positioned(
                right: ScreenUtil.getInstance().setWidth(304),
                bottom: ScreenUtil.getInstance().setHeight(404 - animationChickRightHand.value * 6),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffFFD000), borderRadius: BorderRadius.all(Radius.circular(6))),
                  width: ScreenUtil.getInstance().setWidth(6),
                  height: ScreenUtil.getInstance().setHeight(6),
                )),
            Positioned(
                right: ScreenUtil.getInstance().setWidth(300),
                bottom: ScreenUtil.getInstance().setHeight(416 - animationChickRightHand.value * 4),
                child: Container(
                  decoration: BoxDecoration(
                      color: Color(0xffFFD000), borderRadius: BorderRadius.all(Radius.circular(6))),
                  width: ScreenUtil.getInstance().setWidth(6),
                  height: ScreenUtil.getInstance().setHeight(6),
                )),
          ],
        ),
      ),
    );
  }
}
