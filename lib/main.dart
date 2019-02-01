import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/general/login/login.dart';
import 'screens/general/overview/overview.dart';
import 'screens/gamemaster/point/point.dart';
import 'screens/gamemaster/point/edit/point_edit.dart';
import 'screens/groupleader/team/team.dart';
import 'blocs/manager.dart';
import 'util/auth.dart';

void main() async {
  // Force Orientation to Portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  Map<String, WidgetBuilder> _getRoutes(BuildContext context) {
    return <String, WidgetBuilder> {
      '/': (context) => Auth.handleCurrentScreen(),
      '/general/login': (context) => LoginScreen(),
      '/general/overview': (context) => OverviewScreen(),
      '/gamemaster/point': (context) => PointScreen(),
      '/gamemaster/point/edit': (context) => PointEditScreen(''),
      '/groupleader/team': (context) => TeamScreen(),
    };
  }

  MaterialPageRoute<bool> _onGenerateRoute(RouteSettings settings) {
    final List<String> pathElements = settings.name.split('/');
    // Game Master Pages
    if (pathElements[0] == 'gamemaster') {
      if (pathElements[1] == 'point') {
        if (pathElements[2] == 'edit') {
          return MaterialPageRoute<bool>(
            builder: (BuildContext context) =>
                PointEditScreen(pathElements[3]),
            settings: settings,
          );
        }
      }
    }
    return null;
  }

  MaterialPageRoute<bool> _onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute<bool>(
      builder: (BuildContext context) => LoginScreen(),
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocsManager(
      child: MaterialApp(
        title: 'StrITwise',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
        ),
        initialRoute: '/',
        routes: _getRoutes(context),
        onGenerateRoute: _onGenerateRoute,
        onUnknownRoute: _onUnknownRoute,
      ),
    );
  }

}
