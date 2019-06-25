import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'page.dart';
import 'CounterModel.dart';

void main() {
  final counter = CounterModel();
  final textSize = 48;
  runApp(Provider<int>.value(
    value: textSize,
    child: ChangeNotifierProvider.value(
      value: counter,
      child: MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Provider.of<CounterModel>(context).color,
          platform: TargetPlatform.iOS),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final _counter = Provider.of<CounterModel>(context);
    final textSize = Provider.of<int>(context).toDouble();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '${_counter.value}',
              style: TextStyle(fontSize: textSize),
            ),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new Page()),
                );
              },
              child: Text('go to page'),
            ),
            Consumer<CounterModel>(
              builder: (context, CounterModel counter, child) => RaisedButton(
                    onPressed: () {
                      counter.changeColor(Colors.red);
                    },
                    child: Text('红色主题'),
                  ),
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
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
        color: Provider.of<CounterModel>(context).color,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                  padding: EdgeInsets.only(top: 6),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.home,
                        color: _tabIndex == 0 ? Colors.red : Color(0xffdddddd),
                      ),
                      Text(
                        '精选',
                        style: TextStyle(
                            color: _tabIndex == 0
                                ? Colors.red
                                : Color(0xffdddddd)),
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      _tabIndex = 0;
                    });
                  }),
              FlatButton(
                  padding: EdgeInsets.only(top: 6),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.store_mall_directory,
                        color: _tabIndex == 1 ? Colors.red : Color(0xffdddddd),
                      ),
                      Text(
                        '会员店',
                        style: TextStyle(
                            color: _tabIndex == 1
                                ? Colors.red
                                : Color(0xffdddddd)),
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      _tabIndex = 1;
                    });
                  }),
              Container(
                width: 100,
              ),
              FlatButton(
                  padding: EdgeInsets.only(top: 6),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.add_shopping_cart,
                        color: _tabIndex == 2 ? Colors.red : Color(0xffdddddd),
                      ),
                      Text(
                        '购物车',
                        style: TextStyle(
                            color: _tabIndex == 2
                                ? Colors.red
                                : Color(0xffdddddd)),
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      _tabIndex = 2;
                    });
                  }),
              FlatButton(
                  padding: EdgeInsets.only(top: 6),
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.person_outline,
                        color: _tabIndex == 3 ? Colors.red : Color(0xffdddddd),
                      ),
                      Text(
                        '我',
                        style: TextStyle(
                            color: _tabIndex == 3
                                ? Colors.red
                                : Color(0xffdddddd)),
                      )
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      _tabIndex = 3;
                    });
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
