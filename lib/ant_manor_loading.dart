import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

class AntManorLoading extends StatefulWidget {
  @override
  _AntManorLoadingState createState() => _AntManorLoadingState();
}

class _AntManorLoadingState extends State<AntManorLoading> with TickerProviderStateMixin {
  // 瓶子动画
  AnimationController animationChickController;
  Animation animationChick;
  CurvedAnimation curveChick;

  AnimationController animationEggController;
  Animation animationEgg;
  CurvedAnimation curveEgg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationChickController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    curveChick = CurvedAnimation(parent: animationChickController, curve: Curves.linear);
    animationChick = Tween(begin: 0.0, end: 1.0).animate(curveChick);

    animationChickController.addListener(() {
      setState(() {});
    });

    animationChickController.addStatusListener((AnimationStatus status) {
//      print('new ${animationChickController.status}');
      if (status == AnimationStatus.completed && animationChickController != null) {
        animationChickController.reverse();
        //当动画在开始处停止再次从头开始执行动画
      } else if (status == AnimationStatus.dismissed && animationChickController != null) {
        animationChickController.forward();
      }
    });
    animationChickController.forward();

    // 蛋动画
    animationEggController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );
    curveEgg = CurvedAnimation(parent: animationEggController, curve: Curves.linear);
    animationEgg = Tween(begin: 0.0, end: 1.0).animate(curveEgg);

    animationEggController.addListener(() {
      setState(() {});
    });

    animationEggController.addStatusListener((AnimationStatus status) {
//      print('new ${animationChickController.status}');
      if (status == AnimationStatus.completed && animationEggController != null) {
        animationEggController.reset();
        //当动画在开始处停止再次从头开始执行动画
      } else if (status == AnimationStatus.dismissed && animationEggController != null) {}
      animationEggController.forward();
    });
    animationEggController.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    animationChickController.dispose();
    animationEggController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height - 158 - MediaQuery.of(context).padding.top;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffB7EAFF),
      appBar: AppBar(
        backgroundColor: Color(0xffB7EAFF),
        title: Text('蚂蚁庄园Flutter'),
        elevation: 0,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
              // 鸡加载动画
              top: height * 0.4,
              right: width / 2 - 50,
              child: Transform.rotate(
                angle: pi / animationChick.value == 0 ? -0.12 : animationChick.value * 0.15,
                child: Image.asset('images/chick_loading.png'),
              )),
          Positioned(
              // 蛋1加载动画
              top: height * 0.4 + 86,
              right: width / 2 + 40 + 40 * animationEgg.value,
              child: Offstage(
                offstage: false,
                child: Transform.rotate(
                  angle: pi / 360,
                  child: Image.asset('images/egg_loading.png'),
                ),
              )),
        ],
      ),
    );
  }
}
