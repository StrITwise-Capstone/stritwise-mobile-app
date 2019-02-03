import 'package:firebase_auth/firebase_auth.dart';

import 'user_type.dart';

/// {@category BLOC}
/// State that contains auth BLOC.
class AuthState {
  /// Firebase user currently logged in.
  FirebaseUser firebaseUser;

  /// UserType from [user_type.dart].
  UserType userType;

  /// Current event selected.
  String eventId;

  /// Additional user data stored in events/students or events/volunteers
  Map<String, dynamic> data;

  AuthState._();

  /// Initial state factory.
  ///
  /// While factory constructor is not necessary, it is used for future
  /// expandability. It creates a new [AuthState], set [userType] to
  /// [UserType.Unknown]
  factory AuthState.initial() {
    AuthState authState = AuthState._();
    authState.userType = UserType.Unknown;
    return authState;
  }
}
