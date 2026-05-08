import 'package:flutter_test/flutter_test.dart';

import 'package:aplikasi_todolist/main.dart';

void main() {
  testWidgets('renders login page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Agenda Nusantara'), findsOneWidget);
    expect(find.text('LOGIN'), findsOneWidget);
  });
}
