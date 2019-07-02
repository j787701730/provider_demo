import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class DriftingBottle extends StatefulWidget {
  @override
  _DriftingBottleState createState() => _DriftingBottleState();
}

class _DriftingBottleState extends State<DriftingBottle> with TickerProviderStateMixin {
  AnimationController animationController;
  Animation animation;
  Animation animationColor;
  CurvedAnimation curve;

  AnimationController animationController2;
  Animation animation2;
  Animation animationColor2;
  CurvedAnimation curve2;

  AnimationController animationBalloonController;
  Animation balloonAnimation;
  CurvedAnimation balloonCurve;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    curve = CurvedAnimation(parent: animationController, curve: Curves.ease);
    animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    animationColor = ColorTween(begin: Colors.red, end: Colors.blue).animate(curve);

    animationController.addListener(() {
//      print(animationController.value);
      setState(() {});
    });

    animationController.addStatusListener((AnimationStatus status) {
//      print(status);
    });

    animationController2 = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    curve2 = CurvedAnimation(parent: animationController2, curve: Curves.ease);
    animation2 = Tween(begin: 0.0, end: 1.0).animate(curve2);
    animationColor2 = ColorTween(begin: Colors.red, end: Colors.blue).animate(curve2);

    animationController2.addListener(() {
//      print(animationController.value);
      setState(() {});
    });

    animationController2.addStatusListener((AnimationStatus status) {
//      print(status);
    });

//    热气球动画
    animationBalloonController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
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
//    time();
    animationBalloonController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationController.dispose();
    animationController2.dispose();
    animationBalloonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 158 - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width - 100;
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
                    switch (animationController.status) {
                      case AnimationStatus.completed:
                        animationController.reverse().then((xxx) {
                          animationController2.forward();
                        });

                        break;
                      default:
                        animationController.forward().then((xx) {
                          animationController2.reverse();
                        });
                    }
                  },
                  child: Text('start')),
            ),
          ),
          Positioned(
            top: (100 - balloonAnimation.value * 100),
            right: balloonAnimation.value * width,
            child: Container(
              height: 100,
              width: 100,
              child: Image.asset('images/balloon.png'),
            ),
          ),
          Positioned(
            bottom: animation.value * height/1.5,
            right: animation.value * width/1.5,
            child: Transform.rotate(
              child: Container(
                height: 100,
                width: 100,
//                color: animationColor.value,
                child: Image.asset('images/bottle.png'),
              ),
              angle: (animation.value * 4) * pi,
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
