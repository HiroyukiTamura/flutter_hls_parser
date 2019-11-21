import 'package:flutter_hls_parser_example/mime_types.dart';
import 'package:meta/meta.dart';
import 'package:quiver/strings.dart';

class Util {

  static const int SELECTION_FLAG_DEFAULT = 1;
  static const int SELECTION_FLAG_FORCED = 1 << 1; // 2
  static const int SELECTION_FLAG_AUTOSELECT = 1 << 2; // 4
  static const int ROLE_FLAG_DESCRIBES_VIDEO = 1 << 9;
  static const int ROLE_FLAG_DESCRIBES_MUSIC_AND_SOUND = 1 << 10;
  static const int ROLE_FLAG_TRANSCRIBES_DIALOG = 1 << 12;
  static const int ROLE_FLAG_EASY_TO_READ = 1 << 13;

  /// A type constant for tracks of unknown type. 
  static const int TRACK_TYPE_UNKNOWN = -1;
  /// A type constant for tracks of some default type, where the type itself is unknown. 
  static const int TRACK_TYPE_DEFAULT = 0;
  /// A type constant for audio tracks. 
  static const int TRACK_TYPE_AUDIO = 1;
  /// A type constant for video tracks. 
  static const int TRACK_TYPE_VIDEO = 2;
  /// A type constant for text tracks. 
  static const int TRACK_TYPE_TEXT = 3;
  /// A type constant for metadata tracks. 
  static const int TRACK_TYPE_METADATA = 4;
  /// A type constant for camera motion tracks. 
  static const int TRACK_TYPE_CAMERA_MOTION = 5;
  /// A type constant for a dummy or empty track. 
  static const int TRACK_TYPE_NONE = 6;

  static const int TIME_UNSET = -1;
  static const int LENGTH_UNSET = -1;

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

  static String getCodecsOfType(String codecs, int trackType) {
    var list = splitCodecs(codecs);
    if (list.isEmpty)
      return null;
    for (var codec in list) {
      if (trackType == MimeTypes.getTrackTypeOfCodec(objectType))
    }
  }

  static List<String> splitCodecs(String codecs) => codecs?.isNotEmpty == false ? <String>[] : codecs.trim().split('(\\s*,\\s*)');
//  public static @Nullable String getCodecsOfType(String codecs, int trackType) {
//    String[] codecArray = splitCodecs(codecs);
//    if (codecArray.length == 0) {
//      return null;
//    }
//    StringBuilder builder = new StringBuilder();
//    for (String codec : codecArray) {
//      if (trackType == MimeTypes.getTrackTypeOfCodec(codec)) {
//        if (builder.length() > 0) {
//          builder.append(",");
//        }
//        builder.append(codec);
//      }
//    }
//    return builder.length() > 0 ? builder.toString() : null;
//  }
}

class CencType {
  static const String CENC = 'TYPE_CENC';
  static const String CBCS = 'TYPE_CBCS';
}