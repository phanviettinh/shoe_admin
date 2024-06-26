class TFirebaseException implements Exception {
  final String code;
  TFirebaseException(this.code);

  String get message {
    switch(code){
      case 'unknown':
        return 'An unknown Firebase error occurred. Please try again.';
      default:
        return 'An unexpected Firebase error occurred. Please try again.';
    }
  }
}