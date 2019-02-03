import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:stritwise_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_state.dart';

/// {@category Screen}
/// Widget that shows team's current point.
class MyPoint extends StatefulWidget {
  @override
  _MyPointState createState() => _MyPointState();
}

class _MyPointState extends State<MyPoint> {
  /// Initially content is loading.
  Widget _pointsText = CircularProgressIndicator();

  void _loadPoints(AuthState state) async {
    DocumentSnapshot doc = await Firestore.instance
        .document('/events/${state.eventId}/teams/${state.data['team_id']}')
        .get();
    if (this.mounted) {
      setState(() {
        _pointsText = Text(
          doc.data['credit'].toString(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 50.0,
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                'My Points',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BlocBuilder(
                  bloc: BlocProvider.of<AuthBloc>(context),
                  builder: (BuildContext context, AuthState state) {
                    _loadPoints(state);
                    return _pointsText;
                  },
                ),
                SizedBox(width: 10.0),
                Text(
                  'Pts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
