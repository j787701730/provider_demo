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
    );
  }
}
