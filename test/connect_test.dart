import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:diploma_gameteach/connect.dart';

void main() {
  testWidgets('Correct match increases score', (WidgetTester tester) async {
    // Экранды іске қосамыз
    await tester.pumpWidget(const MaterialApp(home: ConnectScreen()));

    // Сол жақтағы "int" бар екеніне көз жеткіземіз
    expect(find.text('int'), findsOneWidget);

    // Dropdown ашамыз
    await tester.tap(find.byType(DropdownButton<String>).first);
    await tester.pumpAndSettle();

    // Дұрыс жауапты таңдаймыз
    await tester.tap(find.text('бүтін сан').last);
    await tester.pump();

    // 1 секунд күтеміз (Future.delayed бар)
    await tester.pump(const Duration(seconds: 1));

    // Ұпай 1 болуы керек
    expect(find.textContaining('Ұпай: 1'), findsOneWidget);
  });
}
