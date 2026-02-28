import 'package:diploma_gameteach/Game/movement.dart';
import 'package:flutter/material.dart';
import 'Screen/home_screeen.dart';
import 'Screen/login_screeen.dart';
import 'Screen/register_screeen.dart';
import 'connect.dart';
import 'Game/movement.dart';
import 'Screen/introduction.dart';
import 'Screen/games.dart';
import 'Screen/settings.dart';
import 'Screen/profile/profile_screen.dart';
import 'victorina.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (_) => AppSettings(), child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);
    return MaterialApp(
      title: "Gameteach",
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: settings.themeMode,

      locale: settings.locale,

      initialRoute: "/login",
      routes: {
        '/login': (context) => LoginScreeen(),
        '/register': (context) => RegisterScreeen(),
        '/home': (context) => HomeScreeen(),
        '/connect': (context) => ConnectScreen(),
        '/movement': (context) => QuestionGame(),
        '/introduction': (context) => Introduction(),
        '/games': (context) => Games(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => Settings(),
        '/quiz': (context) => VictorinaScreen(),
      },
    );
  }
}
