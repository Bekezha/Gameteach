import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'dart:async';
import 'dart:math';
import 'games_data.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../Game/AnimatedGames/space_lab_game.dart';
import '../Game/AnimatedGames/firefly_math_game.dart';
import '../Game/AnimatedGames/word_catcher_game.dart';
import '../Game/AnimatedGames/time_machine_game.dart';

class Games extends StatefulWidget {
  final String? subjectTitle;
  final List<String>? allowedGames;

  const Games({super.key, this.subjectTitle, this.allowedGames});

  @override
  State<Games> createState() => _GamesState();
}

class _GamesState extends State<Games> {
  late List<Map<String, dynamic>> gamesList;

  @override
  void initState() {
    super.initState();
    final allGames = [
      {"title": "Цифры", "image": "assets/images/play1.jpg"},
      {"title": "Выбери правильный ответ", "image": "assets/images/play2.jpg"},
      {"title": "Быстрый ответ", "image": "assets/images/play3.jpg"},
      {"title": "Связывание", "image": "assets/images/play4.jpg"},
      {"title": "Логический ответ", "image": "assets/images/play5.jpg"},
      {"title": "Правда или ложь", "image": "assets/images/play6.jpg"},
      {"title": "Реши загадку", "image": "assets/images/play7.jpg"},
      {"title": "Найди ошибку", "image": "assets/images/play8.jpg"},
      {"title": "Составь пазл", "image": "assets/images/play9.jpg"},
      {"title": "Сравнение", "image": "assets/images/play1.jpg"},
      {"title": "Сортировка", "image": "assets/images/play2.jpg"},
      {"title": "Что лишнее", "image": "assets/images/play3.jpg"},
      {"title": "Собери слово", "image": "assets/images/play4.jpg"},
      {"title": "Космическая лаб.", "image": "assets/images/play1.jpg", "route": "SpaceLab"},
      {"title": "Магический лес", "image": "assets/images/play2.jpg", "route": "FireflyMath"},
      {"title": "Ловец слов", "image": "assets/images/play3.jpg", "route": "WordCatcher"},
      {"title": "Машина времени", "image": "assets/images/play4.jpg", "route": "TimeMachine"},
    ];

    if (widget.allowedGames != null) {
      gamesList = allGames.where((game) => widget.allowedGames!.contains(game['title'])).toList();
    } else {
      gamesList = allGames;
    }
  }

  String? activeGame;
  int currentQuestionIndex = 0;
  int correctAnswers = 0;
  bool isGameOver = false;
  String feedback = "";

  Timer? _timer;
  int _timeLeft = 10;

  final TextEditingController _textController = TextEditingController();

  // State for advanced games
  String? selectedLeftMatching;
  Map<String, String> matchedPairs = {};
  List<String> shuffledRightMatching = [];

  List<String> availablePuzzleWords = [];
  List<String> selectedPuzzleWords = [];

  // NEW GAMES STATE
  int currentSortingItemIndex = 0;
  List<MapEntry<String, String>> sortingItems = [];

  List<String> availableWordLetters = [];
  List<String> selectedWordLetters = [];

  @override
  void dispose() {
    _timer?.cancel();
    _textController.dispose();
    super.dispose();
  }

  void startGame(String title) {
    setState(() {
      activeGame = title;
      currentQuestionIndex = 0;
      correctAnswers = 0;
      isGameOver = false;
      feedback = "";
      _textController.clear();
    });
    _initQuestionState(title);
    _startTimerIfNeeded(title);
  }

  void _initQuestionState(String title) {
    List<GameQuestion> questions = GamesData.gameData[title] ?? [];
    if (questions.isEmpty || currentQuestionIndex >= questions.length) return;
    
    GameQuestion q = questions[currentQuestionIndex];
    if (title == "Связывание" && q.matchingPairs != null) {
      selectedLeftMatching = null;
      matchedPairs.clear();
      shuffledRightMatching = q.matchingPairs!.values.toList()..shuffle(Random());
    } else if (title == "Составь пазл") {
      availablePuzzleWords = List.from(q.options)..shuffle(Random());
      selectedPuzzleWords.clear();
    } else if (title == "Сортировка") {
      sortingItems.clear();
      currentSortingItemIndex = 0;
      q.sortingCategories?.forEach((category, items) {
        for (var item in items) {
          sortingItems.add(MapEntry(item, category));
        }
      });
      sortingItems.shuffle(Random());
    } else if (title == "Собери слово") {
      availableWordLetters = List.from(q.options)..shuffle(Random());
      selectedWordLetters.clear();
    }
  }

  void _startTimerIfNeeded(String title) {
    _timer?.cancel();
    if (title == "Быстрый ответ" && !isGameOver) {
      setState(() {
        _timeLeft = 8;
      });
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_timeLeft > 0) {
          setState(() {
            _timeLeft--;
          });
        } else {
          checkAnswer(false, timeUp: true);
        }
      });
    }
  }

  void closeGame() {
    _timer?.cancel();
    setState(() {
      activeGame = null;
    });
  }

  void checkAnswer(bool isCorrect, {bool timeUp = false}) {
    if (isGameOver || feedback.isNotEmpty) return;

    _timer?.cancel();

    setState(() {
      if (isCorrect) {
        correctAnswers++;
        feedback = "Правильно! Молодец! 🎉";
      } else {
        feedback = timeUp ? "Время вышло! ⏰" : "Неправильно. Попробуй еще раз! 🤔";
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted || activeGame == null) return;
      setState(() {
        feedback = "";
        _textController.clear();

        List<GameQuestion> questions = GamesData.gameData[activeGame] ?? [];
        if (currentQuestionIndex < questions.length - 1) {
          currentQuestionIndex++;
          _initQuestionState(activeGame!);
          _startTimerIfNeeded(activeGame!);
        } else {
          isGameOver = true;
          context.read<UserProvider>().updateStats(answeredQuestions: correctAnswers, gamesPlayed: 1);
        }
      });
    });
  }

  Widget _buildOptionsButtons(List<String> options, String correctAnswer, {int crossAxisCount = 1, double childAspectRatio = 3.0}) {
    if (crossAxisCount == 1) {
      return Column(
        children: options.map((option) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                foregroundColor: Theme.of(context).primaryColor,
                elevation: 0,
              ),
              onPressed: feedback.isNotEmpty ? null : () => checkAnswer(option == correctAnswer),
              child: Text(option, style: const TextStyle(fontSize: 18)),
            ),
          ),
        )).toList(),
      );
    } else {
      return GridView.count(
        crossAxisCount: crossAxisCount,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        children: options.map((option) => ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            foregroundColor: Theme.of(context).primaryColor,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8)
          ),
          onPressed: feedback.isNotEmpty ? null : () => checkAnswer(option == correctAnswer),
          child: Text(option, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
        )).toList(),
      );
    }
  }

  Widget _buildTextInput(String correctAnswer, {bool isNumber = false}) {
    return Column(
      children: [
        TextField(
          controller: _textController,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: "Введите ответ",
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            onPressed: feedback.isNotEmpty ? null : () {
              String answer = _textController.text.trim();
              if (answer.isEmpty) return;
              checkAnswer(answer.toLowerCase() == correctAnswer.toLowerCase());
            },
            child: const Text("Ответить", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        )
      ],
    );
  }

  Widget _buildMatchingGame(GameQuestion q) {
    if (q.matchingPairs == null) return const SizedBox();
    
    List<String> leftKeys = q.matchingPairs!.keys.toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Левая колонка
        Expanded(
          child: Column(
            children: leftKeys.map((leftWord) {
              bool isMatched = matchedPairs.containsKey(leftWord);
              bool isSelected = selectedLeftMatching == leftWord;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    if (isMatched || feedback.isNotEmpty) return;
                    setState(() {
                      selectedLeftMatching = leftWord;
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isMatched 
                          ? Colors.green.withOpacity(0.3) 
                          : isSelected ? Theme.of(context).colorScheme.secondary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: isSelected ? Colors.amber : Colors.grey.shade300, width: 2),
                    ),
                    child: Text(
                      leftWord, 
                      textAlign: TextAlign.center, 
                      style: TextStyle(
                        fontSize: 16, 
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.black87
                      )
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(width: 20),
        // Правая колонка
        Expanded(
          child: Column(
            children: shuffledRightMatching.map((rightWord) {
              bool isMatched = matchedPairs.containsValue(rightWord);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                  onTap: () {
                    if (isMatched || feedback.isNotEmpty || selectedLeftMatching == null) return;
                    
                    setState(() {
                      if (q.matchingPairs![selectedLeftMatching] == rightWord) {
                        matchedPairs[selectedLeftMatching!] = rightWord;
                        selectedLeftMatching = null;
                        
                        if (matchedPairs.length == q.matchingPairs!.length) {
                          checkAnswer(true);
                        }
                      } else {
                        // Ошибка при связывании
                        selectedLeftMatching = null;
                        checkAnswer(false); 
                      }
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isMatched ? Colors.green.withOpacity(0.3) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300, width: 2),
                    ),
                    child: Text(rightWord, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFindMistakeGame(GameQuestion q) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      alignment: WrapAlignment.center,
      children: q.options.map((word) {
        return GestureDetector(
          onTap: () {
            if (feedback.isNotEmpty) return;
            checkAnswer(word == q.correctAnswer);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Text(
              word,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSentencePuzzleGame(GameQuestion q) {
    return Column(
      children: [
        // Собранное предложение
        Container(
          constraints: const BoxConstraints(minHeight: 100),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          ),
          child: selectedPuzzleWords.isEmpty 
              ? const Center(child: Text("Собери предложение здесь...", style: TextStyle(color: Colors.grey, fontSize: 16)))
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: selectedPuzzleWords.map((word) {
                    return GestureDetector(
                      onTap: () {
                        if (feedback.isNotEmpty) return;
                        setState(() {
                          selectedPuzzleWords.remove(word);
                          availablePuzzleWords.add(word);
                        });
                      },
                      child: Chip(
                        label: Text(word, style: const TextStyle(fontSize: 18, color: Colors.white)),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 30),
        // Разбросанные слова
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: availablePuzzleWords.map((word) {
            return GestureDetector(
              onTap: () {
                if (feedback.isNotEmpty) return;
                setState(() {
                  availablePuzzleWords.remove(word);
                  selectedPuzzleWords.add(word);
                  
                  if (availablePuzzleWords.isEmpty) {
                    String formedSentence = selectedPuzzleWords.join(" ");
                    checkAnswer(formedSentence == q.correctAnswer);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  word,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSortingGame(GameQuestion q) {
    if (sortingItems.isEmpty || currentSortingItemIndex >= sortingItems.length) return const SizedBox();
    
    var currentItem = sortingItems[currentSortingItemIndex];
    List<String> categories = q.sortingCategories!.keys.toList();
    
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.amber, width: 3),
          ),
          child: Text(
            currentItem.key,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: categories.map((category) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: feedback.isNotEmpty ? null : () {
                    if (category == currentItem.value) {
                      setState(() {
                         feedback = "Правильно!";
                      });
                      Future.delayed(const Duration(milliseconds: 1000), () {
                        if (!mounted) return;
                        setState(() {
                          feedback = "";
                          currentSortingItemIndex++;
                          if (currentSortingItemIndex >= sortingItems.length) {
                             checkAnswer(true);
                          }
                        });
                      });
                    } else {
                       setState(() {
                         feedback = "Неправильно!";
                       });
                       Future.delayed(const Duration(milliseconds: 1500), () {
                         if (!mounted) return;
                         setState(() {
                           feedback = "";
                         });
                       });
                    }
                  },
                  child: Text(category, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),
                ),
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildWordBuilderGame(GameQuestion q) {
    return Column(
      children: [
        Container(
          constraints: const BoxConstraints(minHeight: 80),
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
          ),
          child: selectedWordLetters.isEmpty 
              ? const Center(child: Text("Собери слово...", style: TextStyle(color: Colors.grey, fontSize: 16)))
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: selectedWordLetters.map((letter) {
                    return GestureDetector(
                      onTap: () {
                        if (feedback.isNotEmpty) return;
                        setState(() {
                          selectedWordLetters.remove(letter);
                          availableWordLetters.add(letter);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(letter, style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    );
                  }).toList(),
                ),
        ),
        const SizedBox(height: 30),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: availableWordLetters.map((letter) {
            return GestureDetector(
              onTap: () {
                if (feedback.isNotEmpty) return;
                setState(() {
                  availableWordLetters.remove(letter);
                  selectedWordLetters.add(letter);
                  
                  if (availableWordLetters.isEmpty) {
                    String formedWord = selectedWordLetters.join("");
                    checkAnswer(formedWord == q.correctAnswer);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                ),
                child: Text(
                  letter,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGameContent(String title, GameQuestion q) {
    switch (title) {
      case "Цифры":
        return _buildTextInput(q.correctAnswer, isNumber: true);
      case "Выбери правильный ответ":
        return _buildOptionsButtons(q.options, q.correctAnswer);
      case "Быстрый ответ":
        return Column(
          children: [
            Text(
              "Осталось: $_timeLeft сек",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)
            ),
            const SizedBox(height: 16),
            _buildOptionsButtons(q.options, q.correctAnswer),
          ],
        );
      case "Связывание":
        return _buildMatchingGame(q);
      case "Логический ответ":
        return _buildOptionsButtons(q.options, q.correctAnswer);
      case "Правда или ложь":
        return _buildOptionsButtons(q.options, q.correctAnswer, crossAxisCount: 2, childAspectRatio: 1.2);
      case "Реши загадку":
        return _buildTextInput(q.correctAnswer, isNumber: false);
      case "Найди ошибку":
        return _buildFindMistakeGame(q);
      case "Составь пазл":
        return _buildSentencePuzzleGame(q);
      case "Сравнение":
        return _buildOptionsButtons(q.options, q.correctAnswer, crossAxisCount: 3, childAspectRatio: 1.5);
      case "Сортировка":
        return _buildSortingGame(q);
      case "Что лишнее":
        return _buildOptionsButtons(q.options, q.correctAnswer, crossAxisCount: 2, childAspectRatio: 2.0);
      case "Собери слово":
        return _buildWordBuilderGame(q);
      default:
        return const Text("Игра в разработке");
    }
  }

  Widget _buildGameArea(String title) {
    if (isGameOver) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.star_rounded, size: 100, color: Colors.amber),
            const SizedBox(height: 20),
            Text(
              "Игра окончена!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Твой результат: $correctAnswers из 10",
              style: const TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: closeGame,
              icon: const Icon(Icons.arrow_back),
              label: const Text("К списку игр", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      );
    }

    List<GameQuestion> questions = GamesData.gameData[title] ?? [];
    if (questions.isEmpty || currentQuestionIndex >= questions.length) {
      return const Center(child: Text("Ошибка загрузки вопросов."));
    }

    GameQuestion currentQ = questions[currentQuestionIndex];

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 10),
            Text(
              "Вопрос ${currentQuestionIndex + 1} из ${questions.length}",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            if (currentQ.question.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))],
                ),
                child: Text(
                  currentQ.question,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 30),
            _buildGameContent(title, currentQ),
            const SizedBox(height: 30),
            if (feedback.isNotEmpty)
              FadeIn(
                child: Text(
                  feedback,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: feedback.contains("Правильно") ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8EFFF),
      appBar: AppBar(
        title: Text(widget.subjectTitle ?? "Обучающие игры", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        centerTitle: true,
        leading: activeGame != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: closeGame,
              )
            : null,
      ),
      body: activeGame != null
          ? FadeInRight(child: _buildGameArea(activeGame!))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.builder(
                itemCount: gamesList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final game = gamesList[index];
                  return FadeInUp(
                    delay: Duration(milliseconds: 100 * (index % 5)),
                    child: GestureDetector(
                      onTap: () {
                        if (game.containsKey('route')) {
                          Widget selectedScreen;
                          switch (game['route']) {
                            case 'SpaceLab': selectedScreen = const SpaceLabGame(); break;
                            case 'FireflyMath': selectedScreen = const FireflyMathGame(); break;
                            case 'WordCatcher': selectedScreen = const WordCatcherGame(); break;
                            case 'TimeMachine': selectedScreen = const TimeMachineGame(); break;
                            default: return;
                          }
                          Navigator.push(context, MaterialPageRoute(builder: (context) => selectedScreen));
                        } else {
                          startGame(game['title'] as String);
                        }
                      },
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                child: Image.asset(
                                  game['image'] as String,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.videogame_asset, size: 50, color: Colors.blueGrey),
                                    );
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    game['title']!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: Theme.of(context).primaryColor,
                                          fontSize: 15
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
