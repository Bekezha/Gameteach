

class LevelInfo {
  final int level;
  final String titleKk;
  final String titleRu;
  final int minPoints;
  final int maxPoints;
  final String assetName;

  LevelInfo({
    required this.level,
    required this.titleKk,
    required this.titleRu,
    required this.minPoints,
    required this.maxPoints,
    required this.assetName,
  });

  double getProgress(int currentPoints) {
    if (currentPoints >= maxPoints) return 1.0;
    if (currentPoints <= minPoints) return 0.0;
    return (currentPoints - minPoints) / (maxPoints - minPoints);
  }
}

class LevelHelper {
  static final List<LevelInfo> levels = [
    LevelInfo(
      level: 1,
      titleKk: "Жаңадан бастаушы",
      titleRu: "Новичок",
      minPoints: 0,
      maxPoints: 200,
      assetName: "level_1_medal",
    ),
    LevelInfo(
      level: 2,
      titleKk: "Шәкірт",
      titleRu: "Ученик",
      minPoints: 201,
      maxPoints: 500,
      assetName: "level_2_medal",
    ),
    LevelInfo(
      level: 3,
      titleKk: "Ізденуші",
      titleRu: "Искатель",
      minPoints: 501,
      maxPoints: 1000,
      assetName: "level_3_medal",
    ),
    LevelInfo(
      level: 4,
      titleKk: "Талпынушы",
      titleRu: "Стремящийся",
      minPoints: 1001,
      maxPoints: 1700,
      assetName: "level_4_medal",
    ),
    LevelInfo(
      level: 5,
      titleKk: "Маман",
      titleRu: "Специалист",
      minPoints: 1701,
      maxPoints: 2600,
      assetName: "level_5_medal",
    ),
    LevelInfo(
      level: 6,
      titleKk: "Сарапшы",
      titleRu: "Эксперт",
      minPoints: 2601,
      maxPoints: 3700,
      assetName: "level_6_cup",
    ),
    LevelInfo(
      level: 7,
      titleKk: "Шебер",
      titleRu: "Мастер",
      minPoints: 3701,
      maxPoints: 5000,
      assetName: "level_7_cup",
    ),
    LevelInfo(
      level: 8,
      titleKk: "Гранд-мастер",
      titleRu: "Гранд-мастер",
      minPoints: 5001,
      maxPoints: 6500,
      assetName: "level_8_cup",
    ),
    LevelInfo(
      level: 9,
      titleKk: "Аңыз",
      titleRu: "Легенда",
      minPoints: 6501,
      maxPoints: 8500,
      assetName: "level_9_cup",
    ),
    LevelInfo(
      level: 10,
      titleKk: "Ғарыш әміршісі",
      titleRu: "Повелитель космоса",
      minPoints: 8501,
      maxPoints: 999999, // Infinite
      assetName: "level_10_cup_cosmic",
    ),
  ];

  static LevelInfo getLevelInfo(int points) {
    return levels.firstWhere(
      (l) => points <= l.maxPoints,
      orElse: () => levels.last,
    );
  }
}
