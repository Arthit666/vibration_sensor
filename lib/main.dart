import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:sensors/sensors.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:test_sensor/screen/second_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Accelerometer'),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.

        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => SecondPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<double>? _userAccelerometerValues;
  List<String>? userAccelerometer;
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];

  List<_AceX> data = [];

  int _i = 0;
  bool _isRunning = true;

  // @override
  // void dispose() {
  //   super.dispose();
  //   for (final subscription in _streamSubscriptions) {
  //     subscription.cancel();
  //   }
  // }

  @override
  void initState() {
    // Timer.periodic(const Duration(seconds: 1), (Timer timer) {
    //   if (!_isRunning) {
    //     timer.cancel();
    //   }
    // _getAcceValues();
    // });

    _streamSubscriptions.add(userAccelerometerEvents.listen(
      (UserAccelerometerEvent event) {
        _i++;
        setState(() {
          _userAccelerometerValues = <double>[event.x, event.y, event.z];
          userAccelerometer = _userAccelerometerValues
              ?.map((double v) => v.toStringAsFixed(5))
              .toList();

          ///
          data.add(_AceX(_i.toString(), event.x));
        });
      },
    ));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('UserAccelerometer:x \n $userAccelerometer'),
            SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                title: ChartTitle(text: 'UserAcceletion value'),
                series: <ChartSeries<_AceX, String>>[
                  LineSeries<_AceX, String>(
                    dataSource: data,
                    xValueMapper: (_AceX sales, _) => sales.time,
                    yValueMapper: (_AceX sales, _) => sales.value,
                  )
                ]),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: (() {
                ////
                setState(() {
                  data.clear();
                  _i = 0;
                });
              }),
              child: const Text('Reset'),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: (() {
                for (final subscription in _streamSubscriptions) {
                  subscription.cancel();
                }
                Navigator.pushReplacementNamed(context, '/second');
              }),
              child: const Text('Second'),
            ),
          ],
        ),
      ),
    );
  }

  void _getAcceValues() {
    userAccelerometerEvents.listen(
      (UserAccelerometerEvent event) {
        _i++;
        setState(() {
          _userAccelerometerValues = <double>[event.x, event.y, event.z];
          userAccelerometer = _userAccelerometerValues
              ?.map((double v) => v.toStringAsFixed(5))
              .toList();

          ///
          data.add(_AceX(_i.toString(), event.x));
        });
      },
    );
  }
}

class _AceX {
  _AceX(this.time, this.value);

  final String time;
  final double value;
}
