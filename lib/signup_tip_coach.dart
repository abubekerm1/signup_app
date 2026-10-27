// Fixed sample tips. This class never sees the name, email, or password.
class SignupTipCoach {
  const SignupTipCoach();

  static const String category = 'password_help';

  static const List<String> tips = <String>[
    'Pick three words you remember and put a number at the end.',
    'Do not use your name or your birthday for the password.',
    'A short sentence is ok if the password is long enough.',
  ];

  Future<String> loadTip({
    required bool forceError,
    int index = 0,
    Duration delay = const Duration(milliseconds: 700),
  }) async {
    await Future<void>.delayed(delay);

    final List<String>? matches = _tipsByCategory[category];
    if (forceError || matches == null || matches.isEmpty) {
      throw const TipLoadException('Tip did not load. Please retry.');
    }

    final String tip = matches[index.abs() % matches.length];
    if (tip.length > 240) {
      throw const TipLoadException('Tip did not load. Please retry.');
    }
    return tip;
  }
}

class TipLoadException implements Exception {
  const TipLoadException(this.message);

  final String message;

  @override
  String toString() => message;
}

const Map<String, List<String>> _tipsByCategory = <String, List<String>>{
  SignupTipCoach.category: SignupTipCoach.tips,
};
