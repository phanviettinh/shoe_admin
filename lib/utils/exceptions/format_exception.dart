class TFormatException implements Exception {
  final String message;
  const TFormatException([this.message = 'An unexpected format error occurred. Please check your input.']);

  factory TFormatException.fromMessage(String message){
    return TFormatException(message);
  }
  String get formattedMessage => message;
  factory TFormatException.fromCode(String code){
    switch(code){
      case 'invalid email format':
        return const TFormatException('the email address format is invalid. Please enter a valid email.');
      default:
        return const TFormatException('An unexpected Firebase error occurred. Please try again.');
    }
  }
}