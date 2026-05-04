import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ithaki_ui/screens/company/widgets/company_profile_components.dart';

Widget _wrap(Widget child) => MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );

void main() {
  testWidgets('visual placeholder fits compact event media height',
      (tester) async {
    await tester.pumpWidget(
      _wrap(
        const SizedBox(
          width: 160,
          child: CompanyVisualPlaceholder(
            title: 'Workshop',
            subtitle: 'Event media placeholder',
            height: 82,
            iconName: 'assessment',
            borderRadius: 18,
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
