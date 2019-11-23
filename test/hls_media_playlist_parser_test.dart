import 'package:flutter_hls_parser/main.dart';
import 'package:flutter_hls_parser/hls_media_playlist.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';

void main() {

  const String PLAYLIST_STRING =
  '''
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-PLAYLIST-TYPE:VOD
#EXT-X-START:TIME-OFFSET=-25
#EXT-X-TARGETDURATION:8
#EXT-X-MEDIA-SEQUENCE:2679
#EXT-X-DISCONTINUITY-SEQUENCE:4
#EXT-X-ALLOW-CACHE:YES

#EXTINF:7.975,
#EXT-X-BYTERANGE:51370@0
https://priv.example.com/fileSequence2679.ts

#EXT-X-KEY:METHOD=AES-128,URI="https://priv.example.com/key.php?r=2680",IV=0x1566B
#EXTINF:7.975,segment title
#EXT-X-BYTERANGE:51501@2147483648
https://priv.example.com/fileSequence2680.ts

#EXT-X-KEY:METHOD=NONE
#EXTINF:7.941,segment title .,:/# with interesting chars
#EXT-X-BYTERANGE:51501
https://priv.example.com/fileSequence2681.ts

#EXT-X-DISCONTINUITY
#EXT-X-KEY:METHOD=AES-128,URI="https://priv.example.com/key.php?r=2682"
#EXTINF:7.975
#EXT-X-BYTERANGE:51740
https://priv.example.com/fileSequence2682.ts

#EXTINF:7.975,
https://priv.example.com/fileSequence2683.ts
#EXT-X-ENDLIST
''';

  Future<HlsMediaPlaylist> _parseMediaPlaylist(List<String> extraLines, String uri) async {
    Uri playlistUri = Uri.parse(uri);
    var parser = HlsPlaylistParser.create();
    var playList = await parser.parse(playlistUri, extraLines);
    return playList as HlsMediaPlaylist;
  }

  test('testParseMediaPlaylist', () async {
    HlsMediaPlaylist playlist = await _parseMediaPlaylist(PLAYLIST_STRING.split('\n'), 'https://example.com/test.m3u8');
    expect(playlist.playlistType, HlsMediaPlaylist.PLAYLIST_TYPE_VOD);
    expect(playlist.startOffsetUs, playlist.durationUs - 25000000);

    expect(playlist.mediaSequence, 2679);
    expect(playlist.version, 3);
    expect(playlist.hasEndTag, true);
    expect(playlist.protectionSchemes, null);
    expect(playlist.segments, isNotNull);
    expect(playlist.segments.length, 5);

    expect(playlist.discontinuitySequence + playlist.segments[0].relativeDiscontinuitySequence, 4);
    expect(playlist.segments[0].durationUs, 7975000);
    expect(playlist.segments[0].title, isEmpty);
    expect(playlist.segments[0].fullSegmentEncryptionKeyUri, null);
    expect(playlist.segments[0].encryptionIV, null);
    expect(playlist.segments[0].byterangeLength, 51370);
    expect(playlist.segments[0].byterangeOffset, 0);
    expect(playlist.segments[0].url, 'https://priv.example.com/fileSequence2679.ts');
  });
}