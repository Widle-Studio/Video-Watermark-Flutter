import 'package:flutter_test/flutter_test.dart';

import 'package:ib/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Video Watermark Example'), findsOneWidget);
    expect(find.text('Add Watermark'), findsOneWidget);
  });
}
