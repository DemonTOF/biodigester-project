import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:biodigester_mobile/features/monitoring/presentation/pages/widgets/tabbed_date_time_picker.dart';

void main() {
  testWidgets('TabbedDateTimePickerDialog UI and Logic Test', (
    WidgetTester tester,
  ) async {
    final initialDateTime = DateTime(2025, 9, 3, 10, 30);

    DateTime? result;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(primaryColor: Colors.blue),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () async {
                  result = await showDialog<DateTime>(
                    context: context,
                    builder: (context) => TabbedDateTimePickerDialog(
                      initialDateTime: initialDateTime,
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      ),
    );

    // 1. Open Dialog
    await tester.tap(find.text('Open Dialog'));
    await tester.pumpAndSettle();

    // 2. Check Tabs
    expect(find.text('Fecha'), findsOneWidget);
    expect(find.text('Hora'), findsOneWidget);

    // 3. Check initial Date (CalendarDatePicker)
    // Note: Localization might affect this string, but 'September 2025' is expected for default locale
    expect(find.textContaining('2025'), findsWidgets);

    // 4. Switch to Time Tab
    await tester.tap(find.text('Hora'));
    await tester.pumpAndSettle();

    // 5. Check initial Time
    expect(find.text('10'), findsOneWidget);
    expect(find.text('30'), findsOneWidget);

    // 6. Accept and verify result
    await tester.tap(find.text('Aceptar'));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.year, 2025);
    expect(result!.month, 9);
    expect(result!.day, 3);
    expect(result!.hour, 10);
    expect(result!.minute, 30);
  });
}
