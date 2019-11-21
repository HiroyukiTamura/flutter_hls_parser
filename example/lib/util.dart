import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

class Util {

  static bool startsWith(List<int> source, List<int> checker) {
    for (int i = 0; i < checker.length; i++) {
      if (source[i] != checker[i]) {
        return false;
      }
    }
    return true;
  }

  static String excludeWhiteSpace({@required String string, @required bool skipLinebreaks}) =>
      string.split('').where((it) { // ignore: always_specify_types
        int unitCode = it.codeUnitAt(0);
        return !(isWhitespace(unitCode) ||
            (skipLinebreaks && isLineBreak(unitCode)));
      }).join();

  static bool isLineBreak(int codeUnit) =>
      (codeUnit == '\n'.codeUnitAt(0)) || (codeUnit == '\r'.codeUnitAt(0));
}

class CencType {
  static const String CENC = 'TYPE_CENC';
  static const String CBCS = 'TYPE_CBCS';
}