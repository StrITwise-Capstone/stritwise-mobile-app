import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stritwise_mobile_app/blocs/auth/auth_bloc.dart';

class BlocsManager extends StatefulWidget {

  final Widget child;

  BlocsManager({Key key, @required this.child}) : super(key: key);

  @override
  _BlocsManagerState createState() => _BlocsManagerState();
}

class _BlocsManagerState extends State<BlocsManager> {
  final _authBloc = AuthBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _authBloc,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _authBloc.dispose();
    super.dispose();
  }
}
