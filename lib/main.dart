import 'package:flutter/material.dart';
import 'Screen/home_screen.dart';
import 'Screen/introduction.dart';
import 'Screen/games_by_subject.dart';
import 'Screen/settings.dart';
import 'Screen/profile/profile_screen.dart';
import 'victorina.dart';
import 'package:provider/provider.dart';
import 'app_settings.dart';
import 'theme/neurocosmos_theme.dart';


import 'providers/user_provider.dart';
import 'providers/game_provider.dart';
import 'providers/duel_provider.dart';
import 'Screen/create_game_screen.dart';
import 'Screen/my_games_screen.dart';
import 'Screen/duel_lobby_screen.dart';
import 'Screen/duel_game_screen.dart';
import 'Screen/login_screen.dart';
import 'Screen/register_screen.dart';
import 'connect.dart';
import 'Game/movement.dart';
import 'Screen/neurocosmos_demo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();



  final userProvider = UserProvider();
  await userProvider.init();

  final appSettings = AppSettings();
  await appSettings.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appSettings),
        ChangeNotifierProvider.value(value: userProvider),
        ChangeNotifierProvider(create: (_) => GameProvider()),
        ChangeNotifierProvider(create: (_) => DuelProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<AppSettings>(context);
    return MaterialApp(
      title: "Gameteach",
      debugShowCheckedModeBanner: false,
      theme: NeuroCosmosTheme.lightTheme,
      darkTheme: NeuroCosmosTheme.darkTheme,
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
        '/my-games': (context) => const MyGamesScreen(),
        '/duel-lobby': (context) => const DuelLobbyScreen(),
        '/duel-game': (context) => const DuelGameScreen(),
        '/neurocosmos-demo': (context) => const NeuroCosmosDemoScreen(),
      },
    );
  }
}
