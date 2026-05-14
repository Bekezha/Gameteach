# diploma_gameteach

A new Flutter project.

## Развёртывание (GitHub и телефон)

Репозиторий на GitHub: [https://github.com/Bekezha/Gameteach.git](https://github.com/Bekezha/Gameteach.git).

### Выложить код в GitHub

Если у вас уже есть локальный проект, а на GitHub репозиторий пустой:

```powershell
git remote add gameteach https://github.com/Bekezha/Gameteach.git
git push -u gameteach main
```

Если `origin` должен указывать на этот репозиторий:

```powershell
git remote set-url origin https://github.com/Bekezha/Gameteach.git
git push -u origin main
```

### Render (API)

В корне репозитория есть [render.yaml](render.yaml): Node, каталог `lib/server`, `npm install` / `npm start`, проверка **`GET /health`**. Секреты **`MONGO_URI`** и **`JWT_SECRET`** по-прежнему задаёте только вы в дашборде Render (или при первом применении Blueprint). Регион в файле — `frankfurt`; при необходимости замените на другой из списка Render.

### Сборка APK на GitHub Actions

После пуша в ветку `main` или `master` запускается workflow [Android release APK](.github/workflows/android-build.yml). Во вкладке **Actions** откройте успешный запуск → раздел **Artifacts** → скачайте **app-release-apk** (файл `app-release.apk`). Его можно установить на Android (разрешите установку из неизвестных источников для этого файла).

Перед первой сборкой в репозитории должен быть файл [.env.example](.env.example): при сборке он копируется в `.env`. Если нужен другой `API_URL` или несколько переменных, в настройках репозитория GitHub создайте секрет **`DOTENV`** с полным текстом файла `.env` (не коммитьте секреты в git).

### Локальная сборка на своём ПК

```powershell
copy .env.example .env
flutter pub get
flutter build apk --release
```

Готовый APK: `build\app\outputs\flutter-apk\app-release.apk`.

Для публикации в Google Play обычно нужен подписанный **AAB** (`flutter build appbundle`), отдельный ключ подписи и настройка в Android Studio — это делается вручную в консоли разработчика Play.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
