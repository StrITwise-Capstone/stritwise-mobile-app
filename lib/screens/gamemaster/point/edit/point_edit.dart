import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:stritwise_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_state.dart';
import 'package:stritwise_mobile_app/models/credit_transaction.dart';
import 'package:stritwise_mobile_app/util/helper.dart';

/// {@category Screen}
/// Screen where points are edited.
class PointEditScreen extends StatefulWidget {
  /// Team ID of the team points to edit.
  final String teamId;

  PointEditScreen(this.teamId);

  @override
  _PointEditScreenState createState() => _PointEditScreenState();
}

class _PointEditScreenState extends State<PointEditScreen> {
  /// Data of form is stored and initialised in this variable.
  final Map<String, dynamic> _formData = {
    'points': 0,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Initially content is loading.
  Widget _content = Center(
    child: CircularProgressIndicator(),
  );

  Widget _buildPointsTextField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextFormField(
        decoration: InputDecoration(
          labelText: 'Points Modified',
        ),
        style: TextStyle(
          fontSize: 36.0,
          color: Colors.black,
        ),
        autofocus: true,
        keyboardType: TextInputType.number,
        validator: (String value) {
          if (value.isEmpty && !Helper.isInteger(value)) {
            return 'Please enter a valid integer';
          }
        },
        onSaved: (String value) {
          _formData['points'] = int.parse(value);
        },
      ),
    );
  }

  /// Handles onClick.
  ///
  /// Parameters are the [BuildContext], [AuthState] from BLOC, and
  /// [creditModifier] which may be -1 or 1.
  void _handlePointModified(
      BuildContext context, AuthState state, int creditModifier) {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      CollectionReference creditCollection = Firestore.instance.collection(
          'events/${state.eventId}/teams/${widget.teamId}/credit_transactions');

      CreditTransactionModel transactionModel = CreditTransactionModel(
          creditModified: _formData['points'] * creditModifier,
          userId: state.firebaseUser.uid,
          createdAt: DateTime.now());

      Firestore.instance.runTransaction((Transaction tx) async {
        await creditCollection.add(transactionModel.toJson());
        Navigator.pop(context);
      });
    }
  }

  /// Loads information of team and points.
  Future<Widget> _informationBar(DocumentSnapshot doc) async {
    String schoolName = await _fetchSchoolName(doc.data['school_id']);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              doc.data['team_name'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
              ),
            ),
            Text(
              schoolName,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ],
        ),
        Text(
          doc.data['credit'].toString() + ' Pts',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 28.0,
          ),
        )
      ],
    );
  }

  Future<String> _fetchSchoolName(String school_id) async {
    DocumentSnapshot documentSnapshot =
        await Firestore.instance.document('/schools/${school_id}').get();
    return documentSnapshot.data['name'];
  }

  Future<void> _loadData(AuthState state) async {
    DocumentSnapshot doc = await Firestore.instance
        .document('/events/${state.eventId}/teams/${widget.teamId}')
        .get();
    if (this.mounted) {
      setState(() {
        _content = Column(
          children: <Widget>[
            FutureBuilder(
              future: _informationBar(doc),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.active:
                  case ConnectionState.waiting:
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      return snapshot.data;
                    }
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Points'),
      ),
      body: BlocBuilder(
        bloc: BlocProvider.of<AuthBloc>(context),
        builder: (BuildContext context, AuthState state) {
          _loadData(state);
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _content,
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        SizedBox(height: 50.0),
                        _buildPointsTextField(),
                        SizedBox(height: 50.0),
                        BlocBuilder(
                          bloc: BlocProvider.of<AuthBloc>(context),
                          builder: (BuildContext context, AuthState state) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                ButtonTheme(
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 50.0,
                                  child: RaisedButton(
                                      color: Colors.green[900],
                                      child: Text(
                                        'Add',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () => _handlePointModified(
                                          context, state, 1)),
                                ),
                                ButtonTheme(
                                  minWidth:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 50.0,
                                  child: RaisedButton(
                                      color: Colors.red[900],
                                      child: Text(
                                        'Subtract',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () => _handlePointModified(
                                          context, state, -1)),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
