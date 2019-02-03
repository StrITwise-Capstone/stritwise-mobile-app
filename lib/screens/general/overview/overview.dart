import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/drawer/drawer.dart';
import 'widgets/my_point.dart';
import 'widgets/top_team.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_state.dart';
import 'package:stritwise_mobile_app/blocs/auth/user_type.dart';

/// {@category Screen}
/// Screen where overview is shown.
class OverviewScreen extends StatefulWidget {
  @override
  _OverviewScreenState createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  List<Widget> _generateWidgetList(AuthState state) {
    List<Widget> wigetList = [];
    if (state.userType == UserType.Student ||
        state.userType == UserType.GroupLeader) {
      wigetList.add(MyPoint());
    }
    wigetList.add(TopTeam());
    return wigetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Overview'),
      ),
      drawer: DrawerGenerator(),
      body: BlocBuilder(
        bloc: BlocProvider.of<AuthBloc>(context),
        builder: (BuildContext context, AuthState state) {
          return ListView(
            children: _generateWidgetList(state),
          );
        },
      ),
    );
  }
}
