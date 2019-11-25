import 'dart:async';

import 'package:flutter_hls_parser/hls_master_playlist.dart';
import 'package:flutter_hls_parser/hls_media_playlist.dart';
import 'package:flutter_hls_parser/playlist.dart';
import 'hls_playlist_parser.dart';
import 'exception.dart';
import 'util.dart';

class FlutterHlsParser {

  /// parse string lines of m3u8 file.
  ///
  /// [uri] uri of m3u8 file
  /// [inputLineList] content string lines of m3u8 file
  /// @throws [ParserException], [UnrecognizedInputFormatException]
  /// @return [HlsMasterPlaylist] or [HlsMediaPlaylist]
  static Future<HlsPlaylist> parse({Uri uri, List<String> inputLineList}) => HlsPlaylistParser.create().parse(uri, inputLineList);

  /// util method for split codes with white spaces
  /// etc. 'mp4a.40.2 , avc1.66.30' => ['mp4a.40.2', 'avc1.66.30']
  static List<String> splitCodes(String codecs) => Util.splitCodecs(codecs);
}
