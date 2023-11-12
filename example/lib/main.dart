import 'package:flutter/material.dart';
import 'package:pushable_button/pushable_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selection = 'none';

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 24,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      backgroundColor: Colors.white70,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              PushableButton(
                child: Text('PUSH ME 😎', style: textStyle),
                height: 60,
                elevation: 8,
                color: Colors.redAccent,
                onPressed: () => setState(() => _selection = '1'),
              ),
              SizedBox(height: 32),
              PushableButton(
                child: Text(
                  'ENROLL NOW',
                  style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                height: 80,
                elevation: 12,
                color: Colors.white,
                borderRadius: 12,
                onPressed: () => setState(() => _selection = '2'),
              ),
              SizedBox(height: 32),
              PushableButton(
                child: Text('ADD TO BASKET', style: textStyle),
                height: 60,
                elevation: 8,
                color: Colors.blueAccent,
                onPressed: () => setState(() => _selection = '3'),
              ),
              SizedBox(height: 32),
              Text(
                'Pushed: $_selection',
                style: textStyle.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
