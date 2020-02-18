import 'package:test/test.dart';
import 'package:flutter_hls_parser/src/util.dart';

/// for [Util]
class UtilTest {

  /// for [Util.parseXsDateTime(value)]
  static void testParseXsDateTime(){
    expect(LibUtil.parseXsDateTime('2014-06-19T23:07:42'), 1403219262000);
    expect(LibUtil.parseXsDateTime('2014-08-06T11:00:00Z'), 1407322800000);
    expect(LibUtil.parseXsDateTime('2014-08-06T11:00:00,000Z'), 1407322800000);
    expect(LibUtil.parseXsDateTime('2014-09-19T13:18:55-08:00'), 1411161535000);
    expect(LibUtil.parseXsDateTime('2014-09-19T13:18:55-0800'), 1411161535000);
    expect(LibUtil.parseXsDateTime('2014-09-19T13:18:55.000-0800'), 1411161535000);
    expect(LibUtil.parseXsDateTime('2014-09-19T13:18:55.000-800'), 1411161535000);
  }
}

void main(){
  test('utilTest', () {
    UtilTest.testParseXsDateTime();
  });
}
