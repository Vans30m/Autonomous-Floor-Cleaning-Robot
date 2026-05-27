// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:floor_cleaning_robot_controller_app/main.dart';

void main() {
  testWidgets('Controller screen renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const RobotApp());

    // Verify that key UI elements are present.
    expect(find.text('MODE'), findsOneWidget);
    expect(find.text('MOP SPEED'), findsOneWidget);
    expect(find.text('AUTO'), findsOneWidget);
    expect(find.text('PAUSE'), findsOneWidget);
    expect(find.text('Connect'), findsOneWidget);
  });
}
