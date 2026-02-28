import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diploma_gameteach/victorina.dart';

void main() {
  testWidgets('Correct answer increases score', (WidgetTester tester) async {
    // Экранды іске қосамыз
    await tester.pumpWidget(const MaterialApp(home: VictorinaScreen()));

    // 1-сұрақтың дұрыс жауабы
    expect(find.text('Юпитер'), findsOneWidget);

    // Дұрыс жауапты басамыз
    await tester.tap(find.text('Юпитер'));
    await tester.pump();

    // Future.delayed(1 сек) күтеміз
    await tester.pump(const Duration(seconds: 1));

    // Ұпай 1 болуы керек
    expect(find.textContaining('Ұпай: 1'), findsOneWidget);
  });
}
