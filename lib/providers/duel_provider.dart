import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;


class DuelProvider extends ChangeNotifier {
  socket_io.Socket? socket;
  bool isSearching = false;
  Map<String, dynamic>? duelData;
  int myScore = 0;
  int opponentScore = 0;
  int currentQuestionIndex = 0;
  bool isGameOver = false;

  void connect(String userName, String userId) {
    final baseUrl = 'https://gameteach-32zy.onrender.com';
    
    socket = socket_io.io(baseUrl, socket_io.OptionBuilder()
      .setTransports(['websocket'])
      .disableAutoConnect()
      .build());

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint('Connected to Socket.io');
    });

    socket!.on('match_found', (data) {
      debugPrint('Match found: $data');
      duelData = data;
      isSearching = false;
      myScore = 0;
      opponentScore = 0;
      currentQuestionIndex = 0;
      isGameOver = false;
      notifyListeners();
    });

    socket!.on('opponent_update', (data) {
      opponentScore = data['score'];
      notifyListeners();
    });

    socket!.on('duel_finished', (data) {
      isGameOver = true;
      notifyListeners();
    });

    socket!.onDisconnect((_) {
      debugPrint('Disconnected from Socket.io');
    });
  }

  void startSearch(String userName, String userId) {
    if (socket == null || !socket!.connected) {
      connect(userName, userId);
    }
    isSearching = true;
    socket!.emit('join_duel', {'name': userName, 'id': userId});
    notifyListeners();
  }

  void stopSearch() {
    isSearching = false;
    // Optional: emit 'leave_search' if implemented on backend
    notifyListeners();
  }

  void submitAnswer(bool isCorrect) {
    if (isCorrect) {
      myScore += 10;
    }
    currentQuestionIndex++;
    
    final questions = duelData?['questions'] as List;
    if (currentQuestionIndex >= questions.length) {
      isGameOver = true;
      socket!.emit('game_over', {
        'roomId': duelData?['roomId'],
        'score': myScore
      });
    } else {
      socket!.emit('answer_question', {
        'roomId': duelData?['roomId'],
        'score': myScore,
        'questionIndex': currentQuestionIndex
      });
    }
    notifyListeners();
  }

  @override
  void dispose() {
    socket?.disconnect();
    super.dispose();
  }
}
