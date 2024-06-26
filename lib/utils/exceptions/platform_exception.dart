class TPlatformException implements Exception {
  final String code;
  TPlatformException(this.code);

  String get message {
    switch(code){
      case 'INVALID_LOGIN_CREDENTIALS':
        return 'Invalid login credentials. Please ...';
      default:
        return 'An unexpected Firebase error occurred. Please try again.';
    }
  }
}