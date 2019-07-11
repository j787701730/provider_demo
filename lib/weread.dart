import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'weread_find.dart';
import 'book.dart';
import 'book_download.dart';

class WeRead extends StatefulWidget {
  @override
  _WeReadState createState() => _WeReadState();
}

class _WeReadState extends State<WeRead> {
  var width;
  var top;
  List pages = [WeReadFind(), Book(), BookDownload(), WeReadFind()];
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 640, height: 1136)..init(context);
    width = MediaQuery.of(context).size.width;
    top = MediaQuery.of(context).padding.top + ScreenUtil.getInstance().setHeight(48.0);
    return Scaffold(
      body: PageView(
        children: <Widget>[pages[_tabIndex]],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: ScreenUtil.getInstance().setSp(18),
        unselectedFontSize: ScreenUtil.getInstance().setSp(18),
        selectedItemColor: Color(0xff1B88EE),
        unselectedIconTheme: IconThemeData(color: Color(0xff797F88)),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.explore, size: ScreenUtil.getInstance().setWidth(46)),
              title: Text('发现')),
          BottomNavigationBarItem(
              icon: Icon(Icons.book, size: ScreenUtil.getInstance().setWidth(46)),
              title: Text('书架')),
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud_download, size: ScreenUtil.getInstance().setWidth(46)),
              title: Text('下载')),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: ScreenUtil.getInstance().setWidth(46)),
              title: Text('我')),
        ],
        type: BottomNavigationBarType.fixed,
        currentIndex: _tabIndex,
        onTap: (index) {
          print(index);
          setState(() {
            _tabIndex = index;
          });
        },
      ),
    );
  }
}
