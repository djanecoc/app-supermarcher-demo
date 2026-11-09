import 'package:flutter_test/flutter_test.dart';
import 'package:market/main.dart';

void main() {
  testWidgets('App starts without crash test', (WidgetTester tester) async {
    await tester.pumpWidget(const SupermarketApp());
  });
}
