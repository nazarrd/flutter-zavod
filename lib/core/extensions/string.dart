extension StringExtension on String {
  bool get isValidEmail {
    return RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    ).hasMatch(this);
  }

  String get capitalizeEachFirstLetter {
    try {
      List<String> words = split(' ');
      String result = '';
      for (int i = 0; i < words.length; i++) {
        if (words[i].isNotEmpty) {
          result += '${words[i][0].toUpperCase()}${words[i].substring(1)} ';
        }
      }
      return result.trim().replaceAll(' Of ', ' of ');
    } catch (e) {
      return this;
    }
  }
}
