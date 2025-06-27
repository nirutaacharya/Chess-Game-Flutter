import 'package:chess_game/chess_game_controller.dart';
import 'package:chess_game/chess_screen.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChessGameController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chess Game',
        theme: ThemeData.dark(),
        navigatorKey: NavigationService.navigatorKey,
        home: const ChessScreen(),
      ),
    );
  }
}
