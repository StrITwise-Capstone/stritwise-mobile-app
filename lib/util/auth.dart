import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/general/splash/splash.dart';
import '../screens/general/login/login.dart';
import '../screens/general/overview/overview.dart';
import '../blocs/auth/auth_bloc.dart';

/// {@category Util}
/// Helper methods for authentication.
class Auth {
  static bool _isLoaded = false;

  /// Returns appropriate screen on application start up
  ///
  /// Either returns a [SplashScreen], [OverviewScreen], or [LoginScreen] on
  /// application startup based on firebase authentication state.
  static Widget handleCurrentScreen() {
    return new StreamBuilder<FirebaseUser>(
        stream: FirebaseAuth.instance.onAuthStateChanged,
        builder: (BuildContext context, snapshot) {
          if (!_isLoaded &&
              snapshot.connectionState == ConnectionState.waiting) {
            return SplashScreen();
          } else {
            _isLoaded = true;
            if (snapshot.hasData) {
              BlocProvider.of<AuthBloc>(context).setUser(snapshot.data);
              return OverviewScreen();
            } else {
              return LoginScreen();
            }
          }
        });
  }
}
