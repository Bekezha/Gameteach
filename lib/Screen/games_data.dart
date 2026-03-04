class GameQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;
  final Map<String, String>? matchingPairs;

  GameQuestion({
    required this.question,
    this.options = const [],
    this.correctAnswer = "",
    this.matchingPairs,
  });
}

class GamesData {
  static final Map<String, List<GameQuestion>> gameData = {
    // Game 1: Цифры (math equations)
    "Цифры": [
      GameQuestion(question: "Сколько будет 7 × 8?", correctAnswer: "56"),
      GameQuestion(question: "Сколько будет 15 + 27?", correctAnswer: "42"),
      GameQuestion(question: "Сколько будет 100 / 4?", correctAnswer: "25"),
      GameQuestion(question: "Сколько будет 9 × 9?", correctAnswer: "81"),
      GameQuestion(question: "Сколько будет 50 - 17?", correctAnswer: "33"),
      GameQuestion(question: "Сколько будет 6 × 7?", correctAnswer: "42"),
      GameQuestion(question: "Сколько будет 12 × 5?", correctAnswer: "60"),
      GameQuestion(question: "Сколько будет 144 / 12?", correctAnswer: "12"),
      GameQuestion(question: "Сколько будет 3 + 8 × 2?", correctAnswer: "19"),
      GameQuestion(question: "Сколько будет 20 - 5 × 3?", correctAnswer: "5"),
    ],

    // Game 2: Выбери правильный ответ (trivia)
    "Выбери правильный ответ": [
      GameQuestion(question: "Какая планета самая большая в Солнечной системе?", options: ["Земля", "Марс", "Юпитер", "Сатурн"], correctAnswer: "Юпитер"),
      GameQuestion(question: "Как называют спутник Земли?", options: ["Солнце", "Луна", "Фобос", "Титан"], correctAnswer: "Луна"),
      GameQuestion(question: "Сколько океанов на Земле?", options: ["3", "4", "5", "6"], correctAnswer: "5"),
      GameQuestion(question: "Какая птица не умеет летать, но отлично плавает?", options: ["Пингвин", "Орел", "Страус", "Пеликан"], correctAnswer: "Пингвин"),
      GameQuestion(question: "В каком городе находится Эйфелева башня?", options: ["Рим", "Лондон", "Париж", "Берлин"], correctAnswer: "Париж"),
      GameQuestion(question: "Что из этого является овощем?", options: ["Яблоко", "Банан", "Морковь", "Клубника"], correctAnswer: "Морковь"),
      GameQuestion(question: "Как называется самое быстрое наземное животное?", options: ["Лев", "Гепард", "Тигр", "Леопард"], correctAnswer: "Гепард"),
      GameQuestion(question: "Сколько континентов на Земле?", options: ["5", "6", "7", "8"], correctAnswer: "6"),
      GameQuestion(question: "Какой цвет получается при смешивании синего и желтого?", options: ["Зеленый", "Фиолетовый", "Оранжевый", "Коричневый"], correctAnswer: "Зеленый"),
      GameQuestion(question: "Сколько цветов в радуге?", options: ["5", "6", "7", "8"], correctAnswer: "7"),
    ],

    // Game 3: Быстрый ответ (fast answer)
    "Быстрый ответ": [
      GameQuestion(question: "Сколько дней в високосном году?", options: ["365", "364", "366", "367"], correctAnswer: "366"),
      GameQuestion(question: "Сколько часов в сутках?", options: ["12", "24", "48", "60"], correctAnswer: "24"),
      GameQuestion(question: "Сколько месяцев в году?", options: ["10", "11", "12", "13"], correctAnswer: "12"),
      GameQuestion(question: "Что идет после понедельника?", options: ["Вторник", "Среда", "Четверг", "Пятница"], correctAnswer: "Вторник"),
      GameQuestion(question: "Сколько букв в русском алфавите?", options: ["30", "31", "32", "33"], correctAnswer: "33"),
      GameQuestion(question: "Сколько лап у паука?", options: ["6", "8", "10", "12"], correctAnswer: "8"),
      GameQuestion(question: "Как называется детеныш коровы?", options: ["Жеребенок", "Теленок", "Щенок", "Котенок"], correctAnswer: "Теленок"),
      GameQuestion(question: "Какой месяц первый в году?", options: ["Декабрь", "Январь", "Февраль", "Март"], correctAnswer: "Январь"),
      GameQuestion(question: "Какая фигура имеет 3 угла?", options: ["Квадрат", "Круг", "Треугольник", "Прямоугольник"], correctAnswer: "Треугольник"),
      GameQuestion(question: "Сколько пальцев на одной руке?", options: ["4", "5", "6", "10"], correctAnswer: "5"),
    ],

    // Game 4: Связывание (Advanced mechanics: Drag points to match words)
    "Связывание": [
      GameQuestion(question: "Свяжи слова по смыслу", matchingPairs: {"Собака": "Будка", "Птица": "Гнездо", "Медведь": "Берлога", "Пчела": "Улей", "Курица": "Курятник", "Лошадь": "Конюшня"}),
      GameQuestion(question: "Свяжи объекты и их цвета", matchingPairs: {"Небо": "Синее", "Трава": "Зеленая", "Солнце": "Желтое", "Снег": "Белый", "Уголь": "Черный", "Апельсин": "Оранжевый"}),
      GameQuestion(question: "Кто что ест?", matchingPairs: {"Корова": "Сено", "Кот": "Рыба", "Собака": "Кость", "Мышь": "Сыр", "Обезьяна": "Банан", "Заяц": "Морковь"}),
      GameQuestion(question: "Найди пару (антонимы)", matchingPairs: {"День": "Ночь", "Белый": "Черный", "Горячий": "Холодный", "Быстрый": "Медленный", "Высокий": "Низкий", "Толстый": "Тонкий"}),
      GameQuestion(question: "Профессии и предметы", matchingPairs: {"Врач": "Шприц", "Повар": "Кастрюля", "Учитель": "Указка", "Художник": "Кисть", "Строитель": "Кирпич", "Пожарный": "Шланг"}),
      GameQuestion(question: "Животные и их детеныши", matchingPairs: {"Корова": "Теленок", "Кошка": "Котенок", "Собака": "Щенок", "Овца": "Ягненок", "Курица": "Цыпленок", "Лошадь": "Жеребенок"}),
      GameQuestion(question: "Свяжи транспорт и среду", matchingPairs: {"Самолет": "Небо", "Корабль": "Море", "Поезд": "Рельсы", "Машина": "Дорога", "Ракета": "Космос", "Подлодка": "Океан"}),
      GameQuestion(question: "Предметы и сезоны", matchingPairs: {"Снег": "Зима", "Подснежник": "Весна", "Жара": "Лето", "Листопад": "Осень", "Санки": "Декабрь", "Арбуз": "Август"}),
      GameQuestion(question: "Свяжи деревья и их плоды", matchingPairs: {"Дуб": "Желудь", "Яблоня": "Яблоко", "Груша": "Груша", "Сосна": "Шишка", "Лещина": "Орех", "Слива": "Слива"}),
      GameQuestion(question: "Части тела и чувства", matchingPairs: {"Глаза": "Зрение", "Уши": "Слух", "Нос": "Обоняние", "Язык": "Вкус", "Кожа": "Осязание", "Ноги": "Ходьба"}),
    ],

    // Game 5: Логический ответ (logic)
    "Логический ответ": [
      GameQuestion(question: "Что тяжелее: килограмм ваты или килограмм железа?", options: ["Вата", "Железо", "Одинаково"], correctAnswer: "Одинаково"),
      GameQuestion(question: "У отца Мэри 5 дочерей. Четырех зовут Чача, Чече, Чичи, Чочо. Как зовут пятую?", options: ["Чучу", "Мэри", "Аня"], correctAnswer: "Мэри"),
      GameQuestion(question: "Что можно увидеть с закрытыми глазами?", options: ["Темноту", "Сны", "Ничего"], correctAnswer: "Сны"),
      GameQuestion(question: "На каком дереве сидит ворона во время проливного дождя?", options: ["На высоком", "На мокром", "На сухом"], correctAnswer: "На мокром"),
      GameQuestion(question: "Какой месяц короче всех?", options: ["Февраль", "Май", "Любой"], correctAnswer: "Май"),
      GameQuestion(question: "Что принадлежит вам, но другие используют это чаще, чем вы?", options: ["Ваше имя", "Ваш телефон", "Ваши деньги"], correctAnswer: "Ваше имя"),
      GameQuestion(question: "Чем больше из нее берешь, тем больше она становится. Что это?", options: ["Яма", "Гора", "Река"], correctAnswer: "Яма"),
      GameQuestion(question: "Что может путешествовать по свету, оставаясь в одном и том же углу?", options: ["Марка", "Свет", "Ветер"], correctAnswer: "Марка"),
      GameQuestion(question: "Когда мы смотрим на цифру 2, а говорим 10?", options: ["На часах", "В магазине", "В школе"], correctAnswer: "На часах"),
      GameQuestion(question: "Вы опередили лыжника на 2-й позиции. Какое место вы теперь занимаете?", options: ["Первое", "Второе", "Третье"], correctAnswer: "Второе"),
    ],

    // Game 6: Правда или ложь (true/false)
    "Правда или ложь": [
      GameQuestion(question: "Солнце вращается вокруг Земли.", options: ["Правда", "Ложь"], correctAnswer: "Ложь"),
      GameQuestion(question: "Вода закипает при 100 градусах по Цельсию.", options: ["Правда", "Ложь"], correctAnswer: "Правда"),
      GameQuestion(question: "Пауки — это насекомые.", options: ["Правда", "Ложь"], correctAnswer: "Ложь"),
      GameQuestion(question: "Зимой дни короче, чем летом.", options: ["Правда", "Ложь"], correctAnswer: "Правда"),
      GameQuestion(question: "У кошки 9 жизней.", options: ["Правда", "Ложь"], correctAnswer: "Ложь"),
      GameQuestion(question: "Пингвины умеют летать.", options: ["Правда", "Ложь"], correctAnswer: "Ложь"),
      GameQuestion(question: "Радуга появляется после дождя.", options: ["Правда", "Ложь"], correctAnswer: "Правда"),
      GameQuestion(question: "Рыбы дышат жабрами.", options: ["Правда", "Ложь"], correctAnswer: "Правда"),
      GameQuestion(question: "Молоко дают куры.", options: ["Правда", "Ложь"], correctAnswer: "Ложь"),
      GameQuestion(question: "Человек состоит в основном из воды.", options: ["Правда", "Ложь"], correctAnswer: "Правда"),
    ],

    // Game 7: Реши загадку (riddles via text input)
    "Реши загадку": [
      GameQuestion(question: "Висит груша, нельзя скушать.", correctAnswer: "Лампочка"),
      GameQuestion(question: "Зимой и летом одним цветом.", correctAnswer: "Елка"),
      GameQuestion(question: "Без окон, без дверей, полна горница людей.", correctAnswer: "Огурец"),
      GameQuestion(question: "Сидит дед, во сто шуб одет, кто его раздевает, тот слезы проливает.", correctAnswer: "Лук"),
      GameQuestion(question: "Не лает, не кусает, а в дом не пускает.", correctAnswer: "Замок"),
      GameQuestion(question: "Два конца, два кольца, посредине гвоздик.", correctAnswer: "Ножницы"),
      GameQuestion(question: "Течет, течет — не вытечет, бежит, бежит — не выбежит.", correctAnswer: "Река"),
      GameQuestion(question: "Сто одежек и все без застежек.", correctAnswer: "Капуста"),
      GameQuestion(question: "Красная девица сидит в темнице, а коса на улице.", correctAnswer: "Морковь"),
      GameQuestion(question: "Сама не ест, а всех кормит.", correctAnswer: "Ложка"),
    ],

    // Game 8: Найди ошибку (find mistake - tap the wrong word in sentence)
    "Найди ошибку": [
      GameQuestion(question: "Найди слово с ошибкой:", options: ["Мальчик", "пашел", "в", "школу", "утром."], correctAnswer: "пашел"),
      GameQuestion(question: "Найди слово с ошибкой:", options: ["Солнце", "ярко", "светит", "на", "небе,", "птицы", "пают."], correctAnswer: "пают."),
      GameQuestion(question: "Найди слово с ошибкой:", options: ["Ношью", "на", "небе", "появляется", "луна", "и", "звезды."], correctAnswer: "Ношью"),
      GameQuestion(question: "Найди слово с ошибкой:", options: ["Зимой", "очень", "холодна", "и", "идет", "снег."], correctAnswer: "холодна"),
      GameQuestion(question: "Найди слово с логической ошибкой:", options: ["Корова", "дает", "вкусное", "яблоко."], correctAnswer: "яблоко."),
      GameQuestion(question: "Найди слово с ошибкой:", options: ["Сабака", "громко", "лает", "на", "прохожих."], correctAnswer: "Сабака"),
      GameQuestion(question: "Найди слово с ошибкой:", options: ["Вчера", "мы", "хадили", "в", "зоопарк."], correctAnswer: "хадили"),
      GameQuestion(question: "Найди слово с логической ошибкой:", options: ["Самолет", "плывет", "высоко", "в", "облаках."], correctAnswer: "плывет"),
      GameQuestion(question: "Найди слово с ошибкой:", options: ["Пажарный", "быстро", "потушил", "огонь."], correctAnswer: "Пажарный"),
      GameQuestion(question: "Найди слово с ошибкой:", options: ["На", "стале", "лежит", "вкусный", "торт."], correctAnswer: "стале"),
    ],

    // Game 9: Составь пазл (Sentence puzzle - put words in order)
    "Составь пазл": [
      GameQuestion(question: "Собери предложение из слов:", options: ["Я", "очень", "люблю", "вкусные", "яблоки"], correctAnswer: "Я очень люблю вкусные яблоки"),
      GameQuestion(question: "Собери предложение из слов:", options: ["Папа", "купил", "новую", "красную", "машину"], correctAnswer: "Папа купил новую красную машину"),
      GameQuestion(question: "Собери предложение из слов:", options: ["Птицы", "поют", "веселые", "песни", "весной"], correctAnswer: "Птицы поют веселые песни весной"),
      GameQuestion(question: "Собери предложение из слов:", options: ["Мама", "испекла", "сладкий", "вкусный", "пирог"], correctAnswer: "Мама испекла сладкий вкусный пирог"),
      GameQuestion(question: "Собери предложение из слов:", options: ["Мальчик", "быстро", "бежит", "по", "улице"], correctAnswer: "Мальчик быстро бежит по улице"),
      GameQuestion(question: "Собери предложение из слов:", options: ["Солнце", "ярко", "светит", "в", "небе"], correctAnswer: "Солнце ярко светит в небе"),
      GameQuestion(question: "Собери предложение из слов:", options: ["Дети", "весело", "играют", "во", "дворе"], correctAnswer: "Дети весело играют во дворе"),
      GameQuestion(question: "Собери предложение из слов:", options: ["Собака", "громко", "лает", "на", "кошку"], correctAnswer: "Собака громко лает на кошку"),
      GameQuestion(question: "Собери предложение из слов:", options: ["Рыба", "быстро", "плавает", "в", "реке"], correctAnswer: "Рыба быстро плавает в реке"),
      GameQuestion(question: "Собери предложение из слов:", options: ["Кот", "спит", "на", "мягком", "диване"], correctAnswer: "Кот спит на мягком диване"),
    ],
  };
}
