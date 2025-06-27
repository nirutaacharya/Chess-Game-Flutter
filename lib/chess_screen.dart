import 'package:chess_game/chess_game_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:provider/provider.dart';

class ChessScreen extends StatelessWidget {
  const ChessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Chess"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: Provider.of<ChessGameController>(
              context,
              listen: false,
            ).resetGame,
          ),
        ],
      ),

      body: Consumer<ChessGameController>(
        builder: (context, gameController, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                gameController.status,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("White: ${gameController.whiteTimeLeft.inSeconds}s"),
                  const SizedBox(width: 20),
                  Text("Black: ${gameController.blackTimeLeft.inSeconds}s"),
                ],
              ),

              const SizedBox(height: 10),
              ChessBoard(
                controller: gameController.boardController,
                boardColor: BoardColor.brown,
                boardOrientation: PlayerColor.white,
                onMove: gameController.onMoveCallback,
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(10),
                  children: gameController.moveHistory
                      .map((move) => Text(move))
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
