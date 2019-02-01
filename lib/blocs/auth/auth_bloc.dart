import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'auth_event.dart';
import 'auth_state.dart';
import 'user_type.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  Future<void> handleSignInEmail(String email, String password) async {
    try {
      FirebaseUser firebaseUser =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await setUser(firebaseUser);
    } catch (e) {
      throw 'Something went wrong.';
    }
  }

  Future<void> setUser(FirebaseUser firebaseUser) async {
    String eventId = await _getEventId();
    Map<String, dynamic> result = await _getUserDetail(eventId, firebaseUser.uid);
    dispatch(SaveFirebaseUserEvent(firebaseUser));
    dispatch(SaveUserTypeEvent(result['userType']));
    dispatch(SaveEventIdEvent(eventId));
    dispatch(SaveDataEvent(result['data']));
  }

  Future<String> _getEventId() async {
    QuerySnapshot snapshot = await Firestore.instance
        .collection('/events')
        .orderBy(
          'start_date',
          descending: true,
        )
        .getDocuments();
    if (snapshot.documents.length == 0) {
      throw 'No events exist.';
    }
    return snapshot.documents[0].documentID;
  }

  Future<Map<String, dynamic>> _getUserDetail(String eventId, String userUid) async {
    Map<String, dynamic> result = {};

    // Check Students
    DocumentSnapshot snapshot = await Firestore.instance
        .document('/events/${eventId}/students/${userUid}')
        .get();
    result['userType'] = UserType.Student;

    // Check Volunteers
    if (!snapshot.exists) {
      snapshot = await Firestore.instance
          .document('/events/${eventId}/volunteers/${userUid}')
          .get();
      if (!snapshot.exists) throw 'No user found.';
      if (snapshot.data['type'] == 'GM') {
        result['userType'] = UserType.GameMaster;
      } else {
        result['userType'] = UserType.GroupLeader;
      }
    }
    result['data'] = snapshot.data;
    return result;
  }

  void handleSignOut() async {
    await FirebaseAuth.instance.signOut();
    dispatch(SaveFirebaseUserEvent(null));
  }

  @override
  AuthState get initialState => AuthState.initial();

  @override
  Stream<AuthState> mapEventToState(
    AuthState currentState,
    AuthEvent event,
  ) async* {
    if (event is SaveFirebaseUserEvent) {
      yield currentState..firebaseUser = event.firebaseUser;
    } else if (event is SaveUserTypeEvent) {
      yield currentState..userType = event.userType;
    } else if (event is SaveEventIdEvent) {
      yield currentState..eventId = event.eventId;
    } else if (event is SaveDataEvent) {
      yield currentState..data = event.data;
    }
  }
}
