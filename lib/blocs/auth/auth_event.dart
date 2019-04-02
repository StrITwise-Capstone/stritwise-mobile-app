import 'package:firebase_auth/firebase_auth.dart';

import 'user_type.dart';

abstract class AuthEvent {}

class SaveFirebaseUserEvent extends AuthEvent {
  final FirebaseUser firebaseUser;

  SaveFirebaseUserEvent(this.firebaseUser);
}

class SaveUserTypeEvent extends AuthEvent {
  final UserType userType;

  SaveUserTypeEvent(this.userType);
}

class SaveEventIdEvent extends AuthEvent {
  final String eventId;

  SaveEventIdEvent(this.eventId);
}

class SaveDataEvent extends AuthEvent {
  final Map<String, dynamic> data;

  SaveDataEvent(this.data);
}

