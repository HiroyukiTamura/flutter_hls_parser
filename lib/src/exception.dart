class ParserException implements Exception {
  const ParserException(this.message) : super();

  final String message;

  @override
  String toString() => 'ParserException: $message';
}

class UnrecognizedInputFormatException extends ParserException {
  UnrecognizedInputFormatException(String message, this.uri) : super(message);

  final Uri uri;
}
