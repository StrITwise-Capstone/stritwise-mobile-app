import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../widgets/drawer/drawer.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_state.dart';

class PointScreen extends StatefulWidget {
  @override
  _PointScreenState createState() => _PointScreenState();
}

class _PointScreenState extends State<PointScreen> {

  Widget _content = Center(
    child: CircularProgressIndicator(),
  );

  Future<void> _loadData(AuthState state) async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('/events/${state.eventId}/teams')
        .orderBy('team_name')
        .getDocuments();
    List<DocumentSnapshot> documents = snapshot.documents;
    if (this.mounted) {
      setState(() {
        _content = ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: _fetchSchoolName(documents[index]['school_id']),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                  case ConnectionState.done:
                    String subtitle = '';
                    if (snapshot.hasData) {
                      subtitle = snapshot.data;
                    } else if (snapshot.hasError) {
                      subtitle = 'Error: ${snapshot.error}';
                    }
                    return Column(
                      children: <Widget>[
                        ListTile(
                          title: Text(documents[index].data['team_name']),
                          subtitle: Text(subtitle),
                          trailing: Text(
                              documents[index].data['credit'].toString() +
                                  ' Pts'),
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                'gamemaster/point/edit/' +
                                    documents[index].documentID.toString());
                          },
                        ),
                        Divider(),
                      ],
                    );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            );
          },
        );
      });
    }
  }

  Future<String> _fetchSchoolName(String school_id) async {
    DocumentSnapshot documentSnapshot =
        await Firestore.instance.document('/schools/${school_id}').get();
    return documentSnapshot.data['name'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Points'),
      ),
      drawer: DrawerGenerator(),
      body: BlocBuilder(
        bloc: BlocProvider.of<AuthBloc>(context),
        builder: (BuildContext context, AuthState state) {
          _loadData(state);
          return _content;
        },
      ),
    );
  }
}
