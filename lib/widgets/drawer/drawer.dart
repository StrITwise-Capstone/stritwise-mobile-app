import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'gamemaster.dart';
import 'groupleader.dart';
import 'student.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_state.dart';
import 'package:stritwise_mobile_app/blocs/auth/user_type.dart';

class DrawerGenerator extends StatelessWidget {
  Widget _generateDrawer(UserType userType, String name) {
    switch (userType) {
      case UserType.Student:
        return StudentDrawer(name: name);
      case UserType.GameMaster:
        return GameMasterDrawer(name: name);
      case UserType.GroupLeader:
        return GroupLeaderDrawer(name: name);
      default:
        return GroupLeaderDrawer(
          name: 'An error has occured.',
          role: 'ERROR',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (BuildContext context, AuthState state) {
        return _generateDrawer(state.userType,
            state.data['first_name'] + ' ' + state.data['last_name']);
      },
    );
  }
}
