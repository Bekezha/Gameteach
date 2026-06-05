import 'package:flutter/material.dart';

class L10n {
  static final Map<String, Map<String, String>> _localizedValues = {
    'ru': {
      'app_title': 'GameTeach',
      'home': 'Главная',
      'settings': 'Настройки',
      'games': 'Игры',
      'profile': 'Профиль',
      'language': 'Язык',
      'dark_mode': 'Темный режим',
      'my_games': 'Мои игры',
      'create_game': 'Создать игру',
      'next': 'Далее',
      'correct': 'Правильно!',
      'incorrect': 'Неправильно!',
      'score': 'Счет',
      'time_left': 'Осталось времени',
      // Game specific
      'space_lab_title': 'Космическая лаборатория',
      'firefly_math_title': 'Магический лес',
      'word_catcher_title': 'Ловец слов',
      'time_machine_title': 'Машина времени',
    },
    'kk': {
      'app_title': 'GameTeach',
      'home': 'Басты бет',
      'settings': 'Баптаулар',
      'games': 'Ойындар',
      'profile': 'Профиль',
      'language': 'Тіл',
      'dark_mode': 'Қараңғы режим',
      'my_games': 'Менің ойындарым',
      'create_game': 'Ойын жасау',
      'next': 'Келесі',
      'correct': 'Дұрыс!',
      'incorrect': 'Қате!',
      'score': 'Ұпай',
      'time_left': 'Қалған уақыт',
       // Game specific
      'space_lab_title': 'Космикалық зертхана',
      'firefly_math_title': 'Сиқырлы орман',
      'word_catcher_title': 'Сөз аулаушы',
      'time_machine_title': 'Уақыт машинасы',
    },
    'en': {
      'app_title': 'GameTeach',
      'home': 'Home',
      'settings': 'Settings',
      'games': 'Games',
      'profile': 'Profile',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'my_games': 'My Games',
      'create_game': 'Create Game',
      'next': 'Next',
      'correct': 'Correct!',
      'incorrect': 'Incorrect!',
      'score': 'Score',
      'time_left': 'Time Left',
       // Game specific
      'space_lab_title': 'Space Lab',
      'firefly_math_title': 'Magic Forest',
      'word_catcher_title': 'Word Catcher',
      'time_machine_title': 'Time Machine',
    },
  };

  static String getString(BuildContext context, String key) {
    // We should ideally use Provider to get current locale, but for simplicity:
    // This is a helper that will be used in build methods.
    return _localizedValues[Localizations.localeOf(context).languageCode]?[key] ?? key;
  }
}
