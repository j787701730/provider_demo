import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DriftingBottle extends StatefulWidget {
  @override
  _DriftingBottleState createState() => _DriftingBottleState();
}

class _DriftingBottleState extends State<DriftingBottle> with TickerProviderStateMixin {
  // 瓶子动画
  AnimationController animationBottleController;
  Animation animationBottle;
  Animation animationColor;
  CurvedAnimation curveBottle;

  AnimationController animationController2;
  Animation animation2;
  Animation animationColor2;
  CurvedAnimation curve2;

  // 热气球动画
  AnimationController animationBalloonController;
  Animation balloonAnimation;
  CurvedAnimation balloonCurve;

  // 浪花动画
  AnimationController animationSprayController;
  Animation animationSpray;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationBottleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    curveBottle = CurvedAnimation(parent: animationBottleController, curve: Curves.ease);
    animationBottle = Tween(begin: 0.0, end: 1.0).animate(curveBottle);

    animationSprayController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationSpray = Tween(begin: 0.0, end: 1.0).animate(animationSprayController);

//    animationColor = ColorTween(begin: Colors.red, end: Colors.blue).animate(curve);

    animationBottleController.addListener(() {
//      print(animationController.value);
      setState(() {});
    });

    animationBottleController.addStatusListener((AnimationStatus status) {
//      print(status);
      if (status == AnimationStatus.completed && animationBottleController != null) {
        animationBottleController.reset();
      }
    });

    animationSprayController.addListener(() {
      setState(() {});
    });

    animationSprayController.addStatusListener((AnimationStatus status) {
//      print(status);
      if (status == AnimationStatus.completed && animationSprayController != null) {
        animationSprayController.reset();
      }
    });

//    animationController2 = AnimationController(
//      vsync: this,
//      duration: Duration(milliseconds: 1000),
//    );
//    curve2 = CurvedAnimation(parent: animationController2, curve: Curves.linear);
//    animation2 = Tween(begin: 0.0, end: 1.0).animate(curve2);
//    animationColor2 = ColorTween(begin: Colors.red, end: Colors.blue).animate(curve2);
//
//    animationController2.addListener(() {
////      print(animationController.value);
//      setState(() {});
//    });

//    animationController2.addStatusListener((AnimationStatus status) {
////      print(status);
//    });

//    热气球动画
    animationBalloonController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 30),
    );
    balloonCurve = CurvedAnimation(parent: animationBalloonController, curve: Curves.linear);
    balloonAnimation = Tween(begin: 0.0, end: 1.0).animate(balloonCurve);

    animationBalloonController.addListener(() {
      setState(() {});
    });

    animationBalloonController.addStatusListener((AnimationStatus status) {
//      print('new ${animationBalloonController.status}');
      if (status == AnimationStatus.completed && animationBalloonController != null) {
        animationBalloonController.reverse();
        //当动画在开始处停止再次从头开始执行动画
      } else if (status == AnimationStatus.dismissed && animationBalloonController != null) {
        animationBalloonController.forward();
      }
    });

    animationBalloonController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationBottleController.dispose();
//    animationController2.dispose();
    animationBalloonController.dispose();
    animationSprayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 158 - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width - 100;
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('漂流瓶Flutter'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('images/bg.jpg'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter),
            ),
            child: Center(
              child: RaisedButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  onPressed: () {
                    animationBottleController.forward().then((xx) {
//                          animationController2.reverse();
                      animationSprayController.forward();
                    });
                  },
                  child: Text('start')),
            ),
          ),
          // 热气球
          Positioned(
            top: (100 - balloonAnimation.value * 80),
            right: balloonAnimation.value * width,
            child: Container(
              height: ScreenUtil.getInstance().setHeight(59),
              width: ScreenUtil.getInstance().setWidth(38),
              child: Image.asset('images/balloon.png'),
            ),
          ),
          Positioned(
            top: (120 - balloonAnimation.value * 80),
            left: balloonAnimation.value * width,
            child: Container(
              height: ScreenUtil.getInstance().setHeight(59),
              width: ScreenUtil.getInstance().setWidth(38),
              child: Image.asset('images/balloon.png'),
            ),
          ),
          // 瓶子
          Positioned(
            bottom: animationBottle.value * height / 1.62,
            right: animationBottle.value * width / 1.7,
            child: Transform.rotate(
              child: Container(
                height: animationBottle.value <= 0.5
                    ? 100 + animationBottle.value * 100
                    : animationBottle.value > 0.5 && animationBottle.value < 0.99
                        ? 150 - (animationBottle.value - 0.5) * 150
                        : 0,
                width: animationBottle.value <= 0.5
                    ? 100 + animationBottle.value * 100
                    : animationBottle.value > 0.5 && animationBottle.value < 0.99
                        ? 150 - (animationBottle.value - 0.5) * 150
                        : 0,
//                color: animationColor.value,
                child: Image.asset('images/bottle.png'),
              ),
              angle: (animationBottle.value * 4) * pi,
            ),
          ),
//          浪花两朵
          Positioned(
            bottom: height / 1.5,
            right: width / 1.5 - 20,
            child: Offstage(
              offstage: animationSprayController.value > 0 && animationSprayController.value < 0.33
                  ? false
                  : true,
              child: Container(
                height: ScreenUtil.getInstance().setWidth(70),
                width: ScreenUtil.getInstance().setWidth(126),
//                color: animationColor.value,
                child: Image.asset('images/big_spray.png'),
              ),
            ),
          ),
          Positioned(
            bottom: height / 1.43,
            right: width / 1.5 - 20,
            child: Offstage(
              offstage:
                  animationSprayController.value > 0.33 && animationSprayController.value < 0.66
                      ? false
                      : true,
              child: Container(
                height: ScreenUtil.getInstance().setWidth(42),
                width: ScreenUtil.getInstance().setWidth(126),
//                color: animationColor.value,
                child: Image.asset('images/small_spray.png'),
              ),
            ),
          ),
          Positioned(
            bottom: height / 1.51,
            right: width / 1.5 - 20,
            child: Offstage(
              offstage:
                  animationSprayController.value > 0.66 && animationSprayController.value < 0.99
                      ? false
                      : true,
              child: Container(
                height: ScreenUtil.getInstance().setHeight(42),
                width: ScreenUtil.getInstance().setWidth(126),
//                color: animationColor.value,
                child: Image.asset('images/small_spray_02.png'),
              ),
            ),
          ),
//          Positioned(
//            top: animation2.value * height/2,
//            right: animation2.value * width/2,
//            child: Transform.rotate(
//              child: Container(
//                height: 100,
//                width: 100,
//                color: animationColor2.value,
//                child: Image.asset('images/nav_1.png'),
//              ),
//              angle: (animation2.value * 6) * pi,
//            ),
//          ),
//          Positioned(
//            top: animation.value * height,
//            left: animation.value * width,
//            child: Transform.rotate(
//              child: Container(
//                height: 100,
//                width: 100,
//                color: animationColor.value,
//                child: Image.asset('images/nav_1.png'),
//              ),
//              angle: (animation.value * 6) * pi,
//            ),
//          ),
//          Positioned(
//            bottom: animation.value * height,
//            left: animation.value * width,
//            child: Transform.rotate(
//              child: Container(
//                height: 100,
//                width: 100,
//                color: animationColor.value,
//                child: Image.asset('images/nav_1.png'),
//              ),
//              angle: (animation.value * 6) * pi,
//            ),
//          )
        ],
      ),
    );
  }
}
