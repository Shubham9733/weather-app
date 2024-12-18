import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/main.dart';

void main() {
  testWidgets('Weather app loads and displays weather data', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify loading indicator is shown initially (if you have a loading state).
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for the weather data to load and update the UI.
    await tester.pumpAndSettle();

    // Verify the location and weather data is displayed correctly (example).
    expect(find.text('Location:'), findsOneWidget);
    expect(find.text('Temperature:'), findsOneWidget);
    expect(find.text('Condition:'), findsOneWidget);

    // Verify the temperature and condition are numbers/strings as expected.
    expect(find.textContaining('°C'), findsOneWidget); // Example for temperature
    expect(find.textContaining('Clear'), findsOneWidget); // Example for weather condition

    // Verify refresh button or reload action.
    await tester.tap(find.byIcon(Icons.refresh)); // Assume there's a refresh icon
    await tester.pumpAndSettle();

    // Verify that new weather data is shown after refresh.
    expect(find.textContaining('°C'), findsOneWidget);
    expect(find.textContaining('Clear'), findsOneWidget);
  });
}
