// ignore_for_file: prefer_const_constructors

/*
Important commands:
flutter test
- runs all test

flutter test --plain-name '{description of test}'
- runs specific test based on description name
*/

import 'dart:convert';

import 'package:ase456_group_project/screens/advanced.dart';
import 'package:ase456_group_project/screens/money.dart';
import 'package:ase456_group_project/screens/scientific.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ase456_group_project/ui_elements/button.dart';
import 'package:ase456_group_project/screens/simple.dart';
import 'package:ase456_group_project/screens/unit.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

http.Client httpClient = http.Client();

void main() {
  /* 
  ---------------------------------------------------------------------------------------
  simple.dart 
  ---------------------------------------------------------------------------------------
  */
  testWidgets('simple: Initial state of Simple widget',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Simple(buttonColor: Colors.blue,)));

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text &&
            widget.data == '0' &&
            widget.style?.fontSize == 36,
      ),
      findsOneWidget,
    );
    expect(find.byType(MyButton), findsWidgets);
  }, tags: 'simple');

  testWidgets('simple: test addition', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Simple(buttonColor: Colors.blue,)));

    await tapButton(tester, '1');
    await tapButton(tester, '2');
    await tapButton(tester, '+');
    await tapButton(tester, '3');
    await tapButton(tester, '4');
    await tapButton(tester, '=');

    expect(find.text('46.0'), findsOneWidget);
  }, tags: 'simple');

  testWidgets('simple: test subtration', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Simple(buttonColor: Colors.blue,)));

    await tapButton(tester, '1');
    await tapButton(tester, '2');
    await tapButton(tester, '-');
    await tapButton(tester, '3');
    await tapButton(tester, '=');

    expect(find.text('9.0'), findsOneWidget);
  }, tags: 'simple');

  testWidgets('simple: test multiplication', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Simple(buttonColor: Colors.blue,)));

    await tapButton(tester, '1');
    await tapButton(tester, '2');
    await tapButton(tester, '*');
    await tapButton(tester, '3');
    await tapButton(tester, '=');

    expect(find.text('36.0'), findsOneWidget);
  }, tags: 'simple');

  testWidgets('simple: test division', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Simple(buttonColor: Colors.blue,)));

    await tapButton(tester, '1');
    await tapButton(tester, '2');
    await tapButton(tester, '/');
    await tapButton(tester, '3');
    await tapButton(tester, '=');

    expect(find.text('4.0'), findsOneWidget);
  }, tags: 'simple');

  testWidgets('simple: test decimal use', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Simple(buttonColor: Colors.blue,)));

    await tapButton(tester, '1');
    await tapButton(tester, '2');
    await tapButton(tester, '.');
    await tapButton(tester, '2');
    await tapButton(tester, '-');
    await tapButton(tester, '3');
    await tapButton(tester, '=');

    expect(find.text('9.2'), findsOneWidget);
  }, tags: 'simple');

  testWidgets('simple: test clear', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Simple(buttonColor: Colors.blue,)));

    await tapButton(tester, '1');
    await tapButton(tester, '2');
    await tapButton(tester, '.');
    await tapButton(tester, '2');
    await tapButton(tester, '-');
    await tapButton(tester, '3');
    await tapButton(tester, '=');
    await tapButton(tester, 'C');

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text &&
            widget.data == '0' &&
            widget.style?.fontSize == 36,
      ),
      findsOneWidget,
    );
  }, tags: 'simple');

  /* 
  ---------------------------------------------------------------------------------------
  unit.dart
  ---------------------------------------------------------------------------------------
  */
  testWidgets('unit: test density', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Unit()));
    Finder textFieldFinder = find.widgetWithText(TextField, 'Amount').first;

    await tapButton(tester, 'AMOUNT_OF_SUBSTANCE');
    await tapButton(tester, 'DENSITY');
    await tester.enterText(textFieldFinder, '40');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.textContaining('4000'), findsOneWidget);
  }, tags: 'unit');

  testWidgets('unit: 0 test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Unit()));
    Finder textFieldFinder = find.widgetWithText(TextField, 'Amount').first;

    await tapButton(tester, 'AMOUNT_OF_SUBSTANCE');
    await tapButton(tester, 'ANGLE');
    await tester.enterText(textFieldFinder, '0');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.textContaining('0'), findsAtLeast(2));
  }, tags: 'unit');

  testWidgets('unit: large number', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Unit()));
    Finder textFieldFinder = find.widgetWithText(TextField, 'Amount').first;

    await tapButton(tester, 'AMOUNT_OF_SUBSTANCE');
    await tapButton(tester, 'MASS');
    await tester.enterText(textFieldFinder,
        '999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.textContaining('2.0000000000000002e+175'), findsOneWidget);
  }, tags: 'unit');

  testWidgets('unit: test second input', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: Unit()));
    Finder textFieldFinder = find.widgetWithText(TextField, 'Amount').last;

    await tapButton(tester, 'AMOUNT_OF_SUBSTANCE');
    await drag(tester, 'AMOUNT_OF_SUBSTANCE', 'TEMPERATURE');
    await tapButton(tester, 'TEMPERATURE');
    await tester.enterText(textFieldFinder, '90');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(find.textContaining('40'), findsOneWidget);
  }, tags: 'unit');

  /* 
  ---------------------------------------------------------------------------------------
  money.dart
  WARNING: TESTS MAY BECOME OUT OF DATE IN THE EVENT OF ECONOMIC CHANGE
  ---------------------------------------------------------------------------------------
  */

  testWidgets('money: Conversion from USD to EUR Test',
      (WidgetTester tester) async {
    final mockClient = MockClient((request) async {
      final Map<String, dynamic> responseData = {
        'USD_EUR': 0.85,
      };
      return http.Response(json.encode(responseData), 200);
    });

    httpClient = mockClient;

    await tester.pumpWidget(
      MaterialApp(
        home: Money(),
      ),
    );

    Finder textFieldFinder = find.widgetWithText(TextField, 'Amount').first;

    await tester.enterText(textFieldFinder, '90');
    await tester.pump();
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(TextField, 'Amount').last, isNot('0'));
    expect(find.widgetWithText(TextField, 'Amount').last, isNot(''));
    expect(find.widgetWithText(TextField, 'Amount').last, isNot('Amount'));

    // Reset the global variable to the original HTTP client
    httpClient = http.Client();
  }, tags: 'money');

  /* 
  ---------------------------------------------------------------------------------------
  advanced.dart
  ---------------------------------------------------------------------------------------
  */

  testWidgets('advanced: Test basic functions', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdvancedCalculator(buttonColor: Colors.blue,)));

    await tapButton(tester, '1');
    await tapButton(tester, '2');
    await tapButton(tester, '+');
    await tapButton(tester, '3');
    await tapButton(tester, '4');
    await tapButton(tester, '=');

    expect(find.text('46.0'), findsOneWidget);
  }, tags: 'advanced');

  testWidgets('advanced: Clear input', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdvancedCalculator(buttonColor: Colors.blue,)));

    await tapButton(tester, '1');
    await tapButton(tester, '3');
    await tapButton(tester, '4');
    await tapButton(tester, 'C');
    await tapButton(tester, '3');
    await tapButton(tester, 'C');

    expect(
      find.byWidgetPredicate(
        (Widget widget) =>
            widget is Text &&
            widget.data == '0' &&
            widget.style?.fontSize == 36,
      ),
      findsOneWidget,
    );
    expect(find.byType(MyButton), findsWidgets);
  }, tags: 'advanced');

  testWidgets('advanced: Negative number test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdvancedCalculator(buttonColor: Colors.blue,)));

    await tapButton(tester, '1');
    await tapButton(tester, '±');

    expect(find.text('-1'), findsOneWidget);

    await tapButton(tester, '+');
    await tapButton(tester, '16');
    await tapButton(tester, '±');
    await tapButton(tester, '=');

    expect(find.text('-17'), findsOneWidget);
  }, tags: 'advanced');

  testWidgets('advanced: log test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdvancedCalculator(buttonColor: Colors.blue,)));

    await tapButton(tester, 'log');
    await tapButton(tester, '9');
    await tapButton(tester, '8');
    await tapButton(tester, '=');

    expect(find.text('1.9912260756924949'), findsOneWidget);
  }, tags: 'advanced');

  testWidgets('advanced: constants test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdvancedCalculator(buttonColor: Colors.blue,)));

    await tapButton(tester, 'pi');
    await tapButton(tester, '+');
    await tapButton(tester, 'e');
    await tapButton(tester, '=');

    expect(find.text('5.859874482048838'), findsOneWidget);
  }, tags: 'advanced');

  testWidgets('advanced: using functions in tandem',
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: AdvancedCalculator(buttonColor: Colors.blue,)));

    await tapButton(tester, '8');
    await tapButton(tester, 'sqrt(1/2)');
    await tapButton(tester, '+');
    await tapButton(tester, '8');
    await tapButton(tester, 'exp');
    await tapButton(tester, '=');

    expect(find.text('5.859874482048838'), findsOneWidget);
  }, tags: 'advanced');

  /* 
  ---------------------------------------------------------------------------------------
  scientific.dart
  ---------------------------------------------------------------------------------------
  */

  testWidgets('Test sin button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: ScientificCalculator(buttonColor: Colors.blue,)));

    expect(find.text('0'), findsOneWidget);
  }, tags: 'scientific');
}

Future<void> tapButton(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

Future<void> drag(WidgetTester tester, String draggable, String item) async {
  await tester.dragUntilVisible(
    find.text(item),
    find.text(draggable).first,
    const Offset(0, -50),
  );
  await tester.pumpAndSettle();
}