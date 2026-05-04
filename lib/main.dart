import 'package:diploma_gameteach/Game/movement.dart';
import 'package:flutter/material.dart';
import 'Screen/home_screen.dart';
import 'Screen/login_screen.dart';
import 'Screen/register_screen.dart';
import 'connect.dart';
import 'Game/movement.dart';
import 'Screen/introduction.dart';
import 'Screen/games.dart';
import 'Screen/games_by_subject.dart';
import 'Screen/settings.dart';
import 'Screen/profile/profile_screen.dart';
import 'victorina.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';
import 'theme/app_theme.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/user_provider.dart';
import 'providers/game_provider.dart';
import 'Screen/create_game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  final userProvider = UserProvider();
  await userProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MyApp(),
    ),
  );
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
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/connect': (context) => ConnectScreen(),
        '/movement': (context) => QuestionGame(),
        '/introduction': (context) => Introduction(),
        '/games': (context) => const GamesBySubjectScreen(),
        '/profile': (context) => ProfileScreen(),
        '/settings': (context) => Settings(),
        '/quiz': (context) => VictorinaScreen(),
        '/create-game': (context) => const CreateGameScreen(),
      },
    );
  }
}
