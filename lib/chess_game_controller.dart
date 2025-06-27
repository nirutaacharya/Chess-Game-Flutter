import 'dart:async';

import 'package:chess_game/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';

class ChessGameController extends ChangeNotifier {
  final ChessBoardController boardController = ChessBoardController();

  List<String> moveHistory = [];
  Duration whiteTimeLeft = const Duration(minutes: 5);
  Duration blackTimeLeft = const Duration(minutes: 5);
  Timer? _timer;
  bool isWhiteTurn = true;
  bool gameOver = false;

  String get status {
    if (boardController.isCheckMate()) {
      return "Checkmate! ${isWhiteTurn ? 'Black' : 'White'} wins!";
    } else if (boardController.isDraw()) {
      return "Game Draw!";
    }
    return "Turn: ${isWhiteTurn ? 'White' : 'Black'}";
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (gameOver) {
        _timer?.cancel();
        return;
      }
      if (isWhiteTurn) {
        if (whiteTimeLeft.inSeconds > 0) {
          whiteTimeLeft -= const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          _showTimeoutDialog("White");
        }
      } else {
        if (blackTimeLeft.inSeconds > 0) {
          blackTimeLeft -= const Duration(seconds: 1);
        } else {
          _timer?.cancel();
          _showTimeoutDialog("Black");
        }
      }
      notifyListeners();
    });
  }

  void _showTimeoutDialog(String player) {
    gameOver = true;
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Time's Up!"),
          content: Text(
            "$player ran out of time!"
            "${player == 'White' ? 'Black' : 'White'} wins!",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  void onMoveCallback() {
    String? latestMove = boardController.getSan().isNotEmpty
        ? boardController.getSan().last
        : null;
    if (latestMove != null) {
      makeMove(latestMove);
    }
  }

  void makeMove(String move) async {
    if (gameOver) return;
    moveHistory.add(move);
    isWhiteTurn = !isWhiteTurn;
    _startTimer();

    notifyListeners();
    _checkGameOver();
  }

  void _checkGameOver() {
    if (boardController.isCheckMate()) {
      gameOver = true;
      _timer?.cancel();
      Future.delayed(Duration.zero, _showCheckmateDialog);
    } else if (boardController.isDraw()) {
      gameOver = true;
      _timer?.cancel();
      Future.delayed(Duration.zero, _showDrawDialog);
    }
  }

  void _showCheckmateDialog() async {
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const SizedBox(width: 10),
              Center(
                child: const Text(
                  "Checkmate!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${isWhiteTurn ? 'Black' : 'White'} wins!",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Image.asset("assets/Trophy.png", height: 80),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text(
                "Play Again",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDrawDialog() {
    showDialog(
      context: NavigationService.navigatorKey.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: const Text("Draw!"),
          content: const Text("The game ended in a draw."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                resetGame();
              },
              child: const Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  void resetGame() {
    boardController.resetBoard();
    moveHistory.clear();
    whiteTimeLeft = const Duration(minutes: 5);
    blackTimeLeft = const Duration(minutes: 5);
    isWhiteTurn = true;
    gameOver = false;
    _timer?.cancel();
    _startTimer();
    notifyListeners();
  }
}
