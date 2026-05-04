import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<QuestionInputData> _questions = [];
  bool _isLoading = false;

  void _addQuestion() {
    setState(() {
      _questions.add(QuestionInputData());
    });
  }

  void _removeQuestion(int index) {
    setState(() {
      _questions.removeAt(index);
    });
  }

  Future<void> _submitGame() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Введите название игры')));
      return;
    }

    if (_questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Добавьте хотя бы один вопрос')));
      return;
    }

    List<Map<String, dynamic>> finalQuestions = [];
    for (var q in _questions) {
      final qText = q.questionController.text.trim();
      final optA = q.optAController.text.trim();
      final optB = q.optBController.text.trim();
      final optC = q.optCController.text.trim();
      final optD = q.optDController.text.trim();

      if (qText.isEmpty || optA.isEmpty || optB.isEmpty || optC.isEmpty || optD.isEmpty || q.correctOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Заполните все поля во всех вопросах')));
        return;
      }

      String correctAnswer = "";
      if (q.correctOption == 'A') correctAnswer = optA;
      if (q.correctOption == 'B') correctAnswer = optB;
      if (q.correctOption == 'C') correctAnswer = optC;
      if (q.correctOption == 'D') correctAnswer = optD;

      finalQuestions.add({
        'question': qText,
        'options': [optA, optB, optC, optD],
        'correctAnswer': correctAnswer,
      });
    }

    setState(() => _isLoading = true);
    final success = await context.read<GameProvider>().createGame(title, finalQuestions);
    setState(() => _isLoading = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Игра успешно создана!')));
      Navigator.pop(context);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ошибка при создании игры')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать свою игру'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Название игры (напр. Геральдика)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        return FadeInLeft(
                          child: Card(
                            elevation: 3,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Вопрос ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removeQuestion(index),
                                      )
                                    ],
                                  ),
                                  TextField(
                                    controller: _questions[index].questionController,
                                    decoration: const InputDecoration(labelText: 'Текст вопроса'),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildOptionField(_questions[index].optAController, 'Вариант A', 'A', _questions[index], () {
                                    setState(() => _questions[index].correctOption = 'A');
                                  }),
                                  _buildOptionField(_questions[index].optBController, 'Вариант B', 'B', _questions[index], () {
                                    setState(() => _questions[index].correctOption = 'B');
                                  }),
                                  _buildOptionField(_questions[index].optCController, 'Вариант C', 'C', _questions[index], () {
                                    setState(() => _questions[index].correctOption = 'C');
                                  }),
                                  _buildOptionField(_questions[index].optDController, 'Вариант D', 'D', _questions[index], () {
                                    setState(() => _questions[index].correctOption = 'D');
                                  }),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _addQuestion,
                          icon: const Icon(Icons.add),
                          label: const Text('Добавить вопрос'),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _submitGame,
                          icon: const Icon(Icons.save),
                          label: const Text('Сохранить'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber, 
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16)
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
    );
  }

  Widget _buildOptionField(TextEditingController controller, String label, String value, QuestionInputData data, VoidCallback onRadioTapped) {
    return Row(
      children: [
        Radio<String>(
          value: value,
          groupValue: data.correctOption,
          onChanged: (val) => onRadioTapped(),
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label, hintText: 'Введите ответ'),
          ),
        ),
      ],
    );
  }
}

class QuestionInputData {
  final TextEditingController questionController = TextEditingController();
  final TextEditingController optAController = TextEditingController();
  final TextEditingController optBController = TextEditingController();
  final TextEditingController optCController = TextEditingController();
  final TextEditingController optDController = TextEditingController();
  String? correctOption;
}
