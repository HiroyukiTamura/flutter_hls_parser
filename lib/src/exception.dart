class ParserException implements Exception {
  const ParserException(this.message) : super();

  final String message;

  @override
  String toString() => 'ParserException: $message';
}
