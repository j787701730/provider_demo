import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'CounterModel.dart';

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page2'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer2<CounterModel, int>(
              builder: (context, CounterModel counter, int textSize, _) =>
                  Center(
                    child: Text(
                      'Value: ${counter.value}',
                      style: TextStyle(
                        fontSize: textSize.toDouble(),
                      ),
                    ),
                  ),
            ),
            Consumer<CounterModel>(
              builder: (context, CounterModel counter, child) => RaisedButton(
                onPressed: () {
                  counter.changeColor(Colors.blue);
                },
                child: Text('蓝色'),
              ),
              child: Icon(Icons.add),
            )
          ],
        ),
      ),
      floatingActionButton: Consumer<CounterModel>(
        builder: (context, CounterModel counter, child) => FloatingActionButton(
          onPressed: counter.increment,
          child: child,
        ),
        child: Icon(Icons.add),
      ),
    );
  }
}
