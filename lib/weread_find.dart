import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'we_read_find_page.dart';


class WeReadFind extends StatefulWidget {
  @override
  _WeReadFindState createState() => _WeReadFindState();
}

class _WeReadFindState extends State<WeReadFind> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xffEDEEF0),
        automaticallyImplyLeading: false,
//        leading: null,
        titleSpacing: 0,
        title: Container(
          height: 58,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  colors: [Color(0xffEDEEF1), Color(0xffEDEEF0)],
                  begin: FractionalOffset(1, 0),
                  end: FractionalOffset(1, 1))),
          child: Container(
            margin: EdgeInsets.only(
              left: ScreenUtil.getInstance().setWidth(50),
              right: ScreenUtil.getInstance().setWidth(50),
              top: ScreenUtil.getInstance().setHeight(10),
            ),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(56))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      child: Icon(
                        Icons.search,
                        color: Color(0xff858C96),
                      ),
                      padding: EdgeInsets.only(
                        left: ScreenUtil.getInstance().setWidth(30),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: ScreenUtil.getInstance().setWidth(10),
                      ),
                      child: Text(
                        '暗恋橘生淮南',
                        style: TextStyle(
                          color: Color(0xffADB4BE),
                          fontSize: ScreenUtil.getInstance().setSp(26),
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: <Widget>[
                    Container(
                      width: ScreenUtil.getInstance().setWidth(1),
                      color: Color(0xffB8B8B9),
                      height: ScreenUtil.getInstance().setHeight(32),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: ScreenUtil.getInstance().setWidth(30),
                        right: ScreenUtil.getInstance().setWidth(40),
                      ),
                      child: Text(
                        '书城',
                        style: TextStyle(
                            fontSize: ScreenUtil.getInstance().setSp(26), color: Color(0xff5D646E)),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xffEDEEF0),
                Color(0xffE3E4E6),
                Color(0xffEBECEE),
              ], begin: FractionalOffset(1, 0), end: FractionalOffset(1, 1))),
          child: PageView(
            physics: ScrollPhysics(),
            controller: PageController(viewportFraction: 0.85),
            children: <Widget>[WeReadFindPage(0), WeReadFindPage(1), WeReadFindPage(2)],
          )),
    );
  }
}
