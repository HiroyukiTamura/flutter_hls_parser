import 'dart:io';

class UnrecognizedInputFormatException extends ParserException {
  UnrecognizedInputFormatException(String message, this.uri): super(message);

  final Uri uri;
}

class ParserException implements IOException {
  ParserException(this.message): super();

  String message;

  @override
  String toString() => 'SignalException: $message';
}