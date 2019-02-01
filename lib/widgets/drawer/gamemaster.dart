import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stritwise_mobile_app/blocs/auth/auth_bloc.dart';

class GameMasterDrawer extends StatelessWidget {
  final String name;
  final String role;

  GameMasterDrawer({
    this.name = '',
    this.role = 'Game Master',
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Column(
              children: <Widget>[
                Text(
                  this.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  this.role,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
          ),
          ListTile(
            title: Text('Overview'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/general/overview');
            },
          ),
          ListTile(
            title: Text('All Points'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/gamemaster/point');
            },
          ),
          ListTile(
            title: Text('Logout'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/general/login');
              BlocProvider.of<AuthBloc>(context).handleSignOut();
            },
          ),
        ],
      ),
    );
  }
}
