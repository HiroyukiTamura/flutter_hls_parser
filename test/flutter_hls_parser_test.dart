import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_hls_parser/flutter_hls_parser.dart';
import 'package:flutter_hls_parser/main.dart';
import 'package:flutter_hls_parser/hls_master_playlist.dart';
import 'package:flutter_hls_parser/variant.dart';
import 'package:flutter_test/flutter_test.dart' as prefix0;
import 'main_test.dart';
import 'package:flutter_hls_parser/format.dart';
import 'package:quiver/check.dart' as check;

void main() {
  const MethodChannel channel = MethodChannel('flutter_hls_parser');


  const String PLAYLIST_URI = 'https://example.com/test.m3u8';

  const String PLAYLIST_SIMPLE =
'''
#EXTM3U

#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="mp4a.40.2,avc1.66.30",RESOLUTION=304x128
http://example.com/low.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="mp4a.40.2 , avc1.66.30 "
http://example.com/spaces_in_codecs.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=2560000,FRAME-RATE=25,RESOLUTION=384x160
http://example.com/mid.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=7680000,FRAME-RATE=29.997
http://example.com/hi.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=65000,CODECS="mp4a.40.5"
http://example.com/audio-only.m3u8
''';
     

  const String PLAYLIST_WITH_AVG_BANDWIDTH =
'''
#EXTM3U

#EXT-X-STREAM-INF:BANDWIDTH=1280000,
CODECS="mp4a.40.2,avc1.66.30",RESOLUTION=304x128
http://example.com/low.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=1280000,AVERAGE-BANDWIDTH=1270000,

CODECS="mp4a.40.2 , avc1.66.30 "
http://example.com/spaces_in_codecs.m3u8
''';



//  const String PLAYLIST_WITH_INVALID_HEADER =
//      "#EXTMU3\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=1280000,"
//          + "CODECS=\"mp4a.40.2,avc1.66.30\",RESOLUTION=304x128\n"
//          + "http://example.com/low.m3u8\n";
//
//  const String PLAYLIST_WITH_CC =
//      " #EXTM3U \n"
//          + "#EXT-X-MEDIA:TYPE=CLOSED-CAPTIONS,GROUP-ID=\"cc1\","
//          + "LANGUAGE=\"es\",NAME=\"Eng\",INSTREAM-ID=\"SERVICE4\"\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=1280000,"
//          + "CODECS=\"mp4a.40.2,avc1.66.30\",RESOLUTION=304x128\n"
//          + "http://example.com/low.m3u8\n";
//
//  const String PLAYLIST_WITH_CHANNELS_ATTRIBUTE =
//      " #EXTM3U \n"
//          + "#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID=\"audio\",CHANNELS=\"6\",NAME=\"Eng6\","
//          + "URI=\"something.m3u8\"\n"
//          + "#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID=\"audio\",CHANNELS=\"2/6\",NAME=\"Eng26\","
//          + "URI=\"something2.m3u8\"\n"
//          + "#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID=\"audio\",NAME=\"Eng\","
//          + "URI=\"something3.m3u8\"\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=1280000,"
//          + "CODECS=\"mp4a.40.2,avc1.66.30\",AUDIO=\"audio\",RESOLUTION=304x128\n"
//          + "http://example.com/low.m3u8\n";
//
//  const String PLAYLIST_WITHOUT_CC =
//      " #EXTM3U \n"
//          + "#EXT-X-MEDIA:TYPE=CLOSED-CAPTIONS,GROUP-ID=\"cc1\","
//          + "LANGUAGE=\"es\",NAME=\"Eng\",INSTREAM-ID=\"SERVICE4\"\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=1280000,"
//          + "CODECS=\"mp4a.40.2,avc1.66.30\",RESOLUTION=304x128,"
//          + "CLOSED-CAPTIONS=NONE\n"
//          + "http://example.com/low.m3u8\n";
//
//  const String PLAYLIST_WITH_SUBTITLES =
//      " #EXTM3U \n"
//          + "#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID=\"sub1\","
//          + "LANGUAGE=\"es\",NAME=\"Eng\"\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=1280000,"
//          + "CODECS=\"mp4a.40.2,avc1.66.30\",RESOLUTION=304x128\n"
//          + "http://example.com/low.m3u8\n";
//
//  const String PLAYLIST_WITH_AUDIO_MEDIA_TAG =
//      "#EXTM3U\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=2227464,CODECS=\"avc1.640020,mp4a.40.2\",AUDIO=\"aud1\"\n"
//          + "uri1.m3u8\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=8178040,CODECS=\"avc1.64002a,mp4a.40.2\",AUDIO=\"aud1\"\n"
//          + "uri2.m3u8\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=2448841,CODECS=\"avc1.640020,ac-3\",AUDIO=\"aud2\"\n"
//          + "uri1.m3u8\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=8399417,CODECS=\"avc1.64002a,ac-3\",AUDIO=\"aud2\"\n"
//          + "uri2.m3u8\n"
//          + "#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID=\"aud1\",LANGUAGE=\"en\",NAME=\"English\","
//          + "AUTOSELECT=YES,DEFAULT=YES,CHANNELS=\"2\",URI=\"a1/prog_index.m3u8\"\n"
//          + "#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID=\"aud2\",LANGUAGE=\"en\",NAME=\"English\","
//          + "AUTOSELECT=YES,DEFAULT=YES,CHANNELS=\"6\",URI=\"a2/prog_index.m3u8\"\n";
//
//  const String PLAYLIST_WITH_INDEPENDENT_SEGMENTS =
//      " #EXTM3U\n"
//          + "\n"
//          + "#EXT-X-INDEPENDENT-SEGMENTS\n"
//          + "\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=1280000,"
//          + "CODECS=\"mp4a.40.2,avc1.66.30\",RESOLUTION=304x128\n"
//          + "http://example.com/low.m3u8\n"
//          + "\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS=\"mp4a.40.2 , avc1.66.30 \"\n"
//          + "http://example.com/spaces_in_codecs.m3u8\n";
//
//  const String PLAYLIST_WITH_VARIABLE_SUBSTITUTION =
//      " #EXTM3U \n"
//          + "\n"
//          + "#EXT-X-DEFINE:NAME=\"codecs\",VALUE=\"mp4a.40.5\"\n"
//          + "#EXT-X-DEFINE:NAME=\"tricky\",VALUE=\"This/{$nested}/reference/shouldnt/work\"\n"
//          + "#EXT-X-DEFINE:NAME=\"nested\",VALUE=\"This should not be inserted\"\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=65000,CODECS=\"{$codecs}\"\n"
//          + "http://example.com/{$tricky}\n";
//
//  const String PLAYLIST_WITH_MATCHING_STREAM_INF_URLS =
//      "#EXTM3U\n"
//          + "#EXT-X-VERSION:6\n"
//          + "\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=2227464,"
//          + "CLOSED-CAPTIONS=\"cc1\",AUDIO=\"aud1\",SUBTITLES=\"sub1\"\n"
//          + "v5/prog_index.m3u8\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=6453202,"
//          + "CLOSED-CAPTIONS=\"cc1\",AUDIO=\"aud1\",SUBTITLES=\"sub1\"\n"
//          + "v8/prog_index.m3u8\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=5054232,"
//          + "CLOSED-CAPTIONS=\"cc1\",AUDIO=\"aud1\",SUBTITLES=\"sub1\"\n"
//          + "v7/prog_index.m3u8\n"
//          + "\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=2448841,"
//          + "CLOSED-CAPTIONS=\"cc1\",AUDIO=\"aud2\",SUBTITLES=\"sub1\"\n"
//          + "v5/prog_index.m3u8\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=8399417,"
//          + "CLOSED-CAPTIONS=\"cc1\",AUDIO=\"aud2\",SUBTITLES=\"sub1\"\n"
//          + "v9/prog_index.m3u8\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=5275609,"
//          + "CLOSED-CAPTIONS=\"cc1\",AUDIO=\"aud2\",SUBTITLES=\"sub1\"\n"
//          + "v7/prog_index.m3u8\n"
//          + "\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=2256841,"
//          + "CLOSED-CAPTIONS=\"cc1\",AUDIO=\"aud3\",SUBTITLES=\"sub1\"\n"
//          + "v5/prog_index.m3u8\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=8207417,"
//          + "CLOSED-CAPTIONS=\"cc1\",AUDIO=\"aud3\",SUBTITLES=\"sub1\"\n"
//          + "v9/prog_index.m3u8\n"
//          + "#EXT-X-STREAM-INF:BANDWIDTH=6482579,"
//          + "CLOSED-CAPTIONS=\"cc1\",AUDIO=\"aud3\",SUBTITLES=\"sub1\"\n"
//          + "v8/prog_index.m3u8\n"
//          + "\n"
//          + "#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID=\"aud1\",NAME=\"English\",URI=\"a1/index.m3u8\"\n"
//          + "#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID=\"aud2\",NAME=\"English\",URI=\"a2/index.m3u8\"\n"
//          + "#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID=\"aud3\",NAME=\"English\",URI=\"a3/index.m3u8\"\n"
//          + "\n"
//          + "#EXT-X-MEDIA:TYPE=CLOSED-CAPTIONS,"
//          + "GROUP-ID=\"cc1\",NAME=\"English\",INSTREAM-ID=\"CC1\"\n"
//          + "\n"
//          + "#EXT-X-MEDIA:TYPE=SUBTITLES,"
//          + "GROUP-ID=\"sub1\",NAME=\"English\",URI=\"s1/en/prog_index.m3u8\"\n";

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

  test('parseHls1st', () async {
    HlsMasterPlaylist masterPlaylist;
    masterPlaylist = await HlsPlaylistParserTest.parseMasterPlaylist(PLAYLIST_SIMPLE.split('\n'), PLAYLIST_URI);

    List<Variant> variants = masterPlaylist.variants;

    expect(variants.length, 5);
    expect(masterPlaylist.muxedCaptionFormats, isNull);

    for (var i=0; i<variants.length; i++) {
      switch (i) {
        case 0:
          expect(variants[0].format.bitrate, 1280000);
          expect(variants[0].format.codecs, 'mp4a.40.2,avc1.66.30');
          expect(variants[0].format.width, 304);
          expect(variants[0].format.height, 128);
          expect(variants[0].url, Uri.parse('http://example.com/low.m3u8'));
          break;
        case 1:
          expect(variants[1].format.bitrate, 1280000);
          expect(variants[1].format.codecs, 'mp4a.40.2 , avc1.66.30 ');
          expect(variants[1].url, Uri.parse('http://example.com/spaces_in_codecs.m3u8'));
          break;
        case 2:
          expect(variants[2].format.bitrate, 2560000);
          expect(variants[2].format.codecs, isNull);
          expect(variants[2].format.width, 384);
          expect(variants[2].format.height, 160);
          expect(variants[2].format.frameRate, 25);
          expect(variants[2].url, Uri.parse('http://example.com/mid.m3u8'));
          break;
        case 3:
          expect(variants[3].format.bitrate, 7680000);
          expect(variants[3].format.codecs, isNull);
          expect(variants[3].format.width, isNull);
          expect(variants[3].format.height, isNull);
          expect(variants[3].format.frameRate, 29.997);
          expect(variants[3].url, Uri.parse('http://example.com/hi.m3u8'));
          break;
        case 4:
          expect(variants[4].format.bitrate, 65000);
          expect(variants[4].format.codecs, 'mp4a.40.5');
          expect(variants[4].format.width, isNull);
          expect(variants[4].format.height, isNull);
          expect(variants[4].format.frameRate, isNull);
          expect(variants[4].url, Uri.parse('http://example.com/audio-only.m3u8'));
          break;
      }
    }
  });

  test('parseHls2nd', () async {
    HlsMasterPlaylist masterPlaylist = await HlsPlaylistParserTest.parseMasterPlaylist(PLAYLIST_WITH_AVG_BANDWIDTH.split('\n'), PLAYLIST_URI);

    List<Variant> variants = masterPlaylist.variants;

    expect(variants[0].format.bitrate, 1280000);
    expect(variants[1].format.bitrate, 1270000);
  });
}
