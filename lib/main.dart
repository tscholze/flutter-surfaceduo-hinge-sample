import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Getting access to the platform-specific methods we
// implemented earlier in the Kotlin file.
const platform = const MethodChannel('duosdk.microsoft.dev');

// Boilerplate Flutter to run / start the app.
void main() => runApp(MyApp());

// App container.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Surface Duo Hinge Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

// Widget that contains the actual ui.
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Private hinge angle property.
  // Used to store the platform-specific information.
  double _hingeAngle = 0;

  // Private timer to pull the hinge angle value.
  // This is not production code. Just use it for demo.
  Timer _timer;

  // On init, start the timer which calls a method to update
  // the hinge angle text.
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateHingeAngle();
    });
  }

  // On dispose (destroy) cancel the timer.
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Private helper method to read the hinge value
  // and trigger a ui redraw.
  Future<void> _updateHingeAngle() async {
    // Read the value.
    final angle = await platform.invokeMethod('getHingeAngle');

    // Only update ui if required.
    if (angle == _hingeAngle) return;

    // Update ui.
    setState(() {
      _hingeAngle = angle;
    });
  }

  // Builds the actual ui.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter <3 Surface Duo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('The current hinge angle is:'),
            Text(
              '${_hingeAngle.toStringAsFixed(0)} °',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
    );
  }
}
