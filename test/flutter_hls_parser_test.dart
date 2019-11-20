import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_hls_parser');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterHlsParser.platformVersion, '42');
  });
}
