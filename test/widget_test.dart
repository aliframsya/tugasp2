import 'package:flutter_test/flutter_test.dart';
import 'package:kantin_bu_sari/main.dart';

void main() {
  testWidgets('App loads and displays title', (WidgetTester tester) async {
    await tester.pumpWidget(const KantinBuSariApp());
    await tester.pumpAndSettle();

    expect(find.text('Kantin Bu Sari'), findsOneWidget);
  });
}
