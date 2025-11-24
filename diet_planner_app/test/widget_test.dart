// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:diet_planner_app/main.dart';
import 'package:diet_planner_app/screens/home_screen_redesigned.dart';

void main() {
  testWidgets('App renders redesigned home screen', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(HomeScreenRedesigned), findsOneWidget);
  });
}
