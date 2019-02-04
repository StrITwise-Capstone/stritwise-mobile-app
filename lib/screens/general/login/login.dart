import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/auth/auth_bloc.dart';

/// {@category Screen}
/// Login screen.
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /// Data of form is stored and initialised in this variable.
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
      ),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty || value.length < 8) {
          return 'Password invalid';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
        print(value);
      },
    );
  }

  /// Handles onClick.
  ///
  /// Parameters are the [BuildContext], and [AuthState] from BLOC.
  void _handleLogin(BuildContext context, AuthState state) {
    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {
      BlocProvider.of<AuthBloc>(context)
          .handleSignInEmail(
        _formData['email'],
        _formData['password'],
      )
          .then((value) {
        Navigator.pushReplacementNamed(context, '/general/overview');
      }).catchError((e) {
        BlocProvider.of<AuthBloc>(context).handleSignOut();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Wrong Credentials! Please try again.'),
        ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('StrITwise® Capstone Project'),
        ),
        body: Builder(
          builder: (context) => Form(
                key: _formKey,
                child: Container(
                  margin: EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          'assets/logo.gif',
                          width: MediaQuery.of(context).size.width * 0.8,
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Expanded(
                        flex: 3,
                        child: ListView(
                          children: <Widget>[
                            _buildEmailTextField(),
                            SizedBox(height: 20.0),
                            _buildPasswordTextField(),
                            SizedBox(height: 50.0),
                            ButtonTheme(
                              minWidth: MediaQuery.of(context).size.width * 0.8,
                              height: 50.0,
                              child: BlocBuilder(
                                bloc: BlocProvider.of<AuthBloc>(context),
                                builder:
                                    (BuildContext context, AuthState state) {
                                  return RaisedButton(
                                    child: Text(
                                      'Login',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () =>
                                        _handleLogin(context, state),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ));
  }
}
