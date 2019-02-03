import 'package:firebase_auth/firebase_auth.dart';

import 'user_type.dart';

/// {@category BLOC}
/// {@subCategory BLOCAuth}
/// Abstract class to hold all auth BLOC events.
abstract class AuthEvent {}

/// Save firebase user event.
class SaveFirebaseUserEvent extends AuthEvent {
  final FirebaseUser firebaseUser;

  SaveFirebaseUserEvent(this.firebaseUser);
}

/// Save user type event.
class SaveUserTypeEvent extends AuthEvent {
  final UserType userType;

  SaveUserTypeEvent(this.userType);
}

/// Save event id event.
class SaveEventIdEvent extends AuthEvent {
  final String eventId;

  SaveEventIdEvent(this.eventId);
}

/// Save user data event.
///
/// Save user data event retrieved from /events/students.
class SaveDataEvent extends AuthEvent {
  final Map<String, dynamic> data;

  SaveDataEvent(this.data);
}

