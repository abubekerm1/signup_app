import 'package:flutter_test/flutter_test.dart';
import 'package:signup_app/signup_tip_coach.dart';

void main() {
  const SignupTipCoach coach = SignupTipCoach();

  test('loadTip returns a fixed password_help tip', () async {
    final String tip = await coach.loadTip(
      forceError: false,
      index: 0,
      delay: Duration.zero,
    );

    expect(SignupTipCoach.category, 'password_help');
    expect(tip, SignupTipCoach.tips.first);
    expect(tip.length, lessThanOrEqualTo(240));
  });

  test('loadTip walks the sample list in order', () async {
    final String second = await coach.loadTip(
      forceError: false,
      index: 1,
      delay: Duration.zero,
    );

    expect(second, SignupTipCoach.tips[1]);
  });

  test('forceError fails without returning a tip', () async {
    expect(
      () => coach.loadTip(forceError: true, delay: Duration.zero),
      throwsA(
        isA<TipLoadException>().having(
          (TipLoadException error) => error.message,
          'message',
          'Tip did not load. Please retry.',
        ),
      ),
    );
  });
}
