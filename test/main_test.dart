import 'package:flutter_hls_parser/hls_master_playlist.dart';
import 'package:flutter_hls_parser/main.dart';
import 'package:flutter_hls_parser/play_list.dart';

///@[HlsPlaylistParser]
class HlsPlaylistParserTest {

  ///@[HlsPlaylistParser.parseMasterPlaylist(extraLines, baseUri)]
  static Future<HlsMasterPlaylist> parseMasterPlaylist(List<String> extraLines, String uri) async {
    Uri playlistUri = Uri.parse(uri);
    var parser = HlsPlaylistParser.create();
    var playList = await parser.parse(playlistUri, extraLines);
    return playList as HlsMasterPlaylist;
  }
}