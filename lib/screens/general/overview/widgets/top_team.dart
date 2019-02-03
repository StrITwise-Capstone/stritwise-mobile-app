import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:stritwise_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_state.dart';

/// {@category Screen}
/// Widget that shows team's current point.
class TopTeam extends StatefulWidget {
  @override
  _TopTeamState createState() => _TopTeamState();
}

class _TopTeamState extends State<TopTeam> {
  /// Initially content is loading.
  List<Widget> _data = []..add(CircularProgressIndicator());

  void _loadData(AuthState state) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('/events/${state.eventId}/teams')
        .orderBy(
          'credit',
          descending: true,
        )
        .getDocuments();
    int maxRange =
        snapshot.documents.length < 3 ? snapshot.documents.length : 3;
    List<Widget> newData = [];
    for (int i = 0; i < maxRange; i++) {
      DocumentSnapshot school = await Firestore.instance
          .document('/schools/${snapshot.documents[i]['school_id']}')
          .get();
      newData.add(_teamScore(i + 1, snapshot.documents[i]['team_name'],
          school.data['name'], snapshot.documents[i]['credit']));
    }
    if (this.mounted) {
      setState(() {
        _data = newData;
      });
    }
  }

  Widget _teamScore(int rank, String teamName, String school, int points) {
    return Column(
      children: <Widget>[
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 5.0,
                    top: 5.0,
                    right: 10.0,
                    bottom: 5.0,
                  ),
                  child: Text(
                    rank.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(teamName),
                    Text(school),
                  ],
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Text(
                  points.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(width: 5.0),
                Text(
                  'Pts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                child: Text(
                  'Top Teams',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28.0,
                  ),
                ),
              ),
            ),
            BlocBuilder(
              bloc: BlocProvider.of<AuthBloc>(context),
              builder: (BuildContext context, AuthState state) {
                _loadData(state);
                return Column(
                  children: _data,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
