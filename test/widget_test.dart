import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_an/main.dart';

void main() {
  testWidgets('App compiles and shows title', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: HomeDecisionApp()));

    expect(find.text('Rent or Own'), findsWidgets);
  });
}
