import 'package:flutter/material.dart';

import '../../../widgets/drawer/drawer.dart';

class TeamScreen extends StatefulWidget {
  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team'),
      ),
      drawer: DrawerGenerator(),
      body: Container(),
    );
  }
}
