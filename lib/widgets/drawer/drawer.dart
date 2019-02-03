import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'gamemaster.dart';
import 'groupleader.dart';
import 'student.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_bloc.dart';
import 'package:stritwise_mobile_app/blocs/auth/auth_state.dart';
import 'package:stritwise_mobile_app/blocs/auth/user_type.dart';

/// {@category Widget}
/// Returns application drawer.
class DrawerGenerator extends StatelessWidget {
  /// Generates drawer
  ///
  /// Requires [UserType] and [name]. Returns a [Drawer] widget.
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
          name: 'Error.',
          role: 'Application requires active internet connection.',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<AuthBloc>(context),
      builder: (BuildContext context, AuthState state) {
        String name = '';

        if (state.data != null) {
          name = state.data['first_name'] + ' ' + state.data['last_name'];
        }

        return _generateDrawer(state.userType, name);
      },
    );
  }
}
