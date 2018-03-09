import 'package:flutter/material.dart';

class SolutionPage extends StatefulWidget {

  Map<String, dynamic> solutionMap;

  SolutionPage(this.solutionMap);

  @override
  createState() => new SolutionPageState(solutionMap);
}

class SolutionPageState extends State<SolutionPage> {

  Map<String, dynamic> solutionMap;

  SolutionPageState(this.solutionMap);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(solutionMap['name']),
      ),
    );
  }
}