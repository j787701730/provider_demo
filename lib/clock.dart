import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Clock extends StatefulWidget {
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  Timer _timer;
  DateTime now = DateTime.now();
  int h;
  int m;
  int s;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (timer) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  List clockNum = List<int>.generate(60, (int index) {
    return index + 1;
  });

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 158 - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('时钟'),
        actions: <Widget>[IconButton(icon: Icon(Icons.access_time), onPressed: startTimer)],
      ),
      body: Container(
        color: Colors.grey,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Container(
              child: Text('${now.hour}:${now.minute}:${now.second}'),
            ),
            Positioned(
              left: (100),
              top: (200),
              child: Container(
                width: (200),
                height: (200),
                decoration: BoxDecoration(
                    color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(200))),
                child: Stack(
                  children: clockNum.map<Widget>((item) {
                    switch (item) {
                      case 15:
                        return Positioned(
                          right: 0,
                          top: ((100 - 7).toDouble()),
                          child: Container(
                            width: 14,
                            height: 14,
                            child: Center(
                              child: Text(
                                '3',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        );
                        break;
                      case 30:
                        return Positioned(
                          left: ((100 - 7).toDouble()),
                          bottom: 0,
                          child: Container(
                            width: 14,
                            height: 20,
                            child: Center(
                              child: Text(
                                '6',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        );
                        break;
                      case 45:
                        return Positioned(
                          left: 0,
                          top: ((100 - 7).toDouble()),
                          child: Container(
                            width: 14,
                            height: 14,
                            child: Center(
                              child: Text(
                                '9',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        );
                        break;
                      case 60:
                        return Positioned(
                          left: ((100 - 14).toDouble()),
                          top: 0,
                          child: Container(
                            width: 28,
                            height: 14,
                            child: Center(
                              child: Text(
                                '12',
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),
                        );
                        break;
                      default:
                        return Positioned(
                          left: ((100 + sin(item * 6 * pi / 180) * 100).toDouble()),
                          top: item > 15 && item < 45
                              ? (100 - cos(item * 6 * pi / 180) * 100) - (item % 5 == 0 ? (8) : (4))
                              : (100 - cos(item * 6 * pi / 180) * 100),
                          child: Transform.rotate(
//                            origin: Offset(
//                              item > 15 && item < 45
//                                  ? -(0.5)
//                                  : (0.5),
//                              (0),
//                            ),
                            angle: item * 6 * pi / 180,
                            child: Container(
                              width: (1),
                              height: item % 5 == 0 ? (8) : (4),
                              color: Colors.white,
                            ),
                          ),
                        );
                    }
                  }).toList(),
                ),
              ),
            ),
//            Positioned(
//              left: (178),
//              top: (224),
//              child: Container(
//                child: Text(
//                  'Rolex',
//                  style: TextStyle(color: Colors.white),
//                ),
//              ),
//            ),
//            // 时针
            Positioned(
              top: (240),
              left: (200),
              child: Transform.rotate(
//                              alignment: Alignment.bottomCenter,
                alignment: Alignment.bottomCenter,
                angle: (now.hour * 30 * pi / 180 + now.minute / 60 * 30 * pi / 180),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    color: Colors.orange,
                  ),
                  width: (2),
                  height: (60),
                ),
              ),
            ),
            // 分针
            Positioned(
              top: (220),
              left: (200),
              child: Transform.rotate(
                alignment: Alignment.bottomCenter,
                angle: (now.minute * 6 * pi / 180 + now.second / 60 * 6 * pi / 180),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    color: Colors.green,
                  ),
                  width: (2),
                  height: (80),
                ),
              ),
            ),
            // 秒针
            Positioned(
              top: (200),
              left: (200),
              child: Transform.rotate(
                alignment: Alignment.bottomCenter,
                angle: (now.second * 6 * pi / 180),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    color: Colors.blue,
                  ),
                  width: (2),
                  height: (100),
                ),
              ),
            ),
            Positioned(
                left: 199,
                top: 299,
                child: Container(
                  width: 2,
                  height: 2,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
