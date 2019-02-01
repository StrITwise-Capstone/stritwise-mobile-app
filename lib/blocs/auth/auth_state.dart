import 'package:firebase_auth/firebase_auth.dart';

import 'user_type.dart';

class AuthState {
  FirebaseUser firebaseUser;
  UserType userType;
  String eventId;
  Map<String, dynamic> data;

  AuthState._();

  factory AuthState.initial() {
    AuthState authState = AuthState._();
    authState.userType = UserType.Unknown;
    return authState;
  }
}
