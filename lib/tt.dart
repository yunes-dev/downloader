import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TestDown extends StatefulWidget {
  const TestDown({super.key});

  @override
  State<TestDown> createState() => _TestDownState();
}

class _TestDownState extends State<TestDown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test Download"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(onPressed: () {}, child: Text("link1")),
          ElevatedButton(onPressed: () {}, child: Text("link2"))
        ],
      ),
    );
  }
}
