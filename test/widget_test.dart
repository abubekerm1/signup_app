import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/main.dart';
import 'package:signup_app/signup_tip_coach.dart';

void main() {
  Future<void> pumpSignup(WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SignupPage(tipDelay: Duration(milliseconds: 30)),
      ),
    );
  }

  testWidgets('app opens on the signup page', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Join Pet Pals'), findsOneWidget);
    expect(find.text('Create your account'), findsOneWidget);
    expect(find.text('Get a signup tip'), findsOneWidget);
  });

  testWidgets('empty form shows error messages', (WidgetTester tester) async {
    await pumpSignup(tester);

    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter a password'), findsOneWidget);
    expect(
      find.text('Demo signup complete — your form passed validation!'),
      findsNothing,
    );
  });

  testWidgets('email without @ shows an email error', (
    WidgetTester tester,
  ) async {
    await pumpSignup(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'Sara');
    await tester.enterText(find.byType(TextFormField).at(1), 'sara.email');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret1');
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('Please enter a valid email'), findsOneWidget);
    expect(
      find.text('Demo signup complete — your form passed validation!'),
      findsNothing,
    );
  });

  testWidgets('short password shows a password error', (
    WidgetTester tester,
  ) async {
    await pumpSignup(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'Sara');
    await tester.enterText(find.byType(TextFormField).at(1), 'sara@email.com');
    await tester.enterText(find.byType(TextFormField).at(2), '12345');
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(
      find.text('Password must be at least 6 characters'),
      findsOneWidget,
    );
    expect(
      find.text('Demo signup complete — your form passed validation!'),
      findsNothing,
    );
  });

  testWidgets('valid form shows the green success message', (
    WidgetTester tester,
  ) async {
    await pumpSignup(tester);

    await tester.enterText(find.byType(TextFormField).at(0), 'Sara');
    await tester.enterText(find.byType(TextFormField).at(1), 'sara@email.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'secret1');
    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(
      find.text('Demo signup complete — your form passed validation!'),
      findsOneWidget,
    );
  });

  testWidgets('tip button shows loading then a preset tip', (
    WidgetTester tester,
  ) async {
    await pumpSignup(tester);

    await tester.ensureVisible(find.text('Get a signup tip'));
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump();

    expect(find.text('Loading tip...'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump();

    expect(find.text('Preset demo tip—not live AI.'), findsOneWidget);
    expect(find.text(SignupTipCoach.tips.first), findsOneWidget);
    expect(find.text('Loading tip...'), findsNothing);
  });

  testWidgets('a shown tip still does not approve signup', (
    WidgetTester tester,
  ) async {
    await pumpSignup(tester);

    await tester.ensureVisible(find.text('Get a signup tip'));
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump();

    expect(find.text('Preset demo tip—not live AI.'), findsOneWidget);

    await tester.ensureVisible(find.text('Sign Up'));
    await tester.tap(find.text('Sign Up'));
    await tester.pump();

    expect(find.text('Please enter your name'), findsOneWidget);
    expect(
      find.text('Demo signup complete — your form passed validation!'),
      findsNothing,
    );
  });

  testWidgets('tip text does not copy the password field', (
    WidgetTester tester,
  ) async {
    await pumpSignup(tester);

    await tester.enterText(
      find.byType(TextFormField).at(2),
      'zzz-not-in-tip',
    );
    await tester.ensureVisible(find.text('Get a signup tip'));
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump();

    final Text tip = tester.widget<Text>(find.byKey(const Key('presetTipText')));
    expect(tip.data, isNot(contains('zzz-not-in-tip')));
    expect(SignupTipCoach.tips, contains(tip.data));
    expect(tip.data!.length, lessThanOrEqualTo(240));
  });

  testWidgets('tip error can be retried', (WidgetTester tester) async {
    await pumpSignup(tester);

    await tester.ensureVisible(find.text('Make the tip fail'));
    await tester.tap(find.text('Make the tip fail'));
    await tester.pump();

    await tester.ensureVisible(find.text('Get a signup tip'));
    await tester.tap(find.text('Get a signup tip'));
    await tester.pump();
    expect(find.text('Loading tip...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump();

    expect(find.text('Tip did not load. Please retry.'), findsOneWidget);
    expect(find.text('Preset demo tip—not live AI.'), findsNothing);
    expect(find.text('Retry'), findsOneWidget);

    await tester.tap(find.text('Retry'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump();
    expect(find.text('Tip did not load. Please retry.'), findsOneWidget);

    await tester.tap(find.text('Make the tip fail'));
    await tester.pump();
    await tester.tap(find.text('Retry'));
    await tester.pump();
    expect(find.text('Loading tip...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 30));
    await tester.pump();

    expect(find.text('Preset demo tip—not live AI.'), findsOneWidget);
    expect(find.text('Tip did not load. Please retry.'), findsNothing);
  });

  testWidgets('short phone screen can open the form', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(320, 480);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      const MaterialApp(home: SignupPage()),
    );

    expect(find.text('Create your account'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
