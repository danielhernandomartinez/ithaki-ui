import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const IthakiApp());
    expect(find.text('Ithaki'), findsOneWidget);
  });
}
