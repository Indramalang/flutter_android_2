import 'package:flutter/material.dart';

class MySecondPage extends StatefulWidget {
  const MySecondPage({super.key, required this.title});
  final String title;

  @override
  State<MySecondPage> createState() => _MySecondPageState();
}

class _MySecondPageState extends State<MySecondPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Stack(
          children: <Widget>[
            const Positioned(
              top: 250.0,
              left: 30.0,
              child: Text(
                'You have pushed the button this many times:',
              ),
            ),
            Positioned(
              top: 270.0,
              left: 160.0,
              child: Text(
                '$_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            Positioned(
              top: 120.0,
              left: 120.0,
              child: ClipRRect(
                borderRadius:
                    BorderRadius.circular(5.0), // Radius untuk pojok membulat
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(50), // Image radius
                  child: Image.asset(
                    'images/number_number.jpg',
                    // width: 150,
                    // height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    _counter = 0; // Reset counter ke 0
                  });
                },
                tooltip: 'Reset',
                child: const Icon(Icons.refresh),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
