import 'package:flutter/services.dart';
import 'package:flutter_hls_parser/src/metadata.dart';
import 'package:test/test.dart';
import 'package:flutter_hls_parser/src/hls_master_playlist.dart';
import 'package:flutter_hls_parser/src/exception.dart';
import 'package:flutter_hls_parser/src/mime_types.dart';
import 'package:flutter_hls_parser/src/variant_info.dart';
import 'package:flutter_hls_parser/src/hls_track_metadata_entry.dart';
import 'package:flutter_hls_parser/src/hls_playlist_parser.dart';

void main() {
  const channel = MethodChannel('flutter_hls_parser');


  const PLAYLIST_URI = 'https://example.com/test.m3u8';

  const PLAYLIST_SIMPLE =
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
     

  const PLAYLIST_WITH_AVG_BANDWIDTH =
'''
#EXTM3U

#EXT-X-STREAM-INF:BANDWIDTH=1280000,
CODECS="mp4a.40.2,avc1.66.30",RESOLUTION=304x128
http://example.com/low.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=1280000,AVERAGE-BANDWIDTH=1270000,

CODECS="mp4a.40.2 , avc1.66.30 "
http://example.com/spaces_in_codecs.m3u8
''';


  const PLAYLIST_WITH_INVALID_HEADER =
'''
#EXTMU3
#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="mp4a.40.2,avc1.66.30",RESOLUTION=304x128
http://example.com/low.m3u8
''';


  const PLAYLIST_WITH_CC =
'''
 #EXTM3U 
#EXT-X-MEDIA:TYPE=CLOSED-CAPTIONS,GROUP-ID="cc1","LANGUAGE="es",NAME="Eng",INSTREAM-ID="SERVICE4"
#EXT-X-STREAM-INF:BANDWIDTH=1280000, CODECS="mp4a.40.2,avc1.66.30",RESOLUTION=304x128
http://example.com/low.m3u8
''';


  const PLAYLIST_WITH_CHANNELS_ATTRIBUTE =
'''
 #EXTM3U 
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",CHANNELS="6",NAME="Eng6",URI="something.m3u8"
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",CHANNELS="2/6",NAME="Eng26",URI="something2.m3u8"
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",NAME="Eng",URI="something3.m3u8"
#EXT-X-STREAM-INF:BANDWIDTH=1280000,
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio",NAME="Eng",CODECS="mp4a.40.2,avc1.66.30",AUDIO="audio",RESOLUTION=304x128,URI="something3.m3u8"
#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="mp4a.40.2,avc1.66.30",AUDIO="audio",RESOLUTION=304x128
http://example.com/low.m3u8
''';


  const PLAYLIST_WITHOUT_CC =
'''
 #EXTM3U 
#EXT-X-MEDIA:TYPE=CLOSED-CAPTIONS,GROUP-ID="cc1",LANGUAGE="es",NAME="Eng",INSTREAM-ID="SERVICE4"
#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="mp4a.40.2,avc1.66.30",RESOLUTION=304x128,CLOSED-CAPTIONS=NONE
http://example.com/low.m3u8
''';


  const PLAYLIST_WITH_SUBTITLES =
  '''
 #EXTM3U 
#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="sub1",LANGUAGE="es",NAME="Eng"
#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="mp4a.40.2,avc1.66.30",RESOLUTION=304x128
http://example.com/low.m3u8
  ''';

  const PLAYLIST_WITH_AUDIO_MEDIA_TAG =
'''
#EXTM3U
#EXT-X-STREAM-INF:BANDWIDTH=2227464,CODECS="avc1.640020,mp4a.40.2",AUDIO="aud1"
uri1.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=8178040,CODECS="avc1.64002a,mp4a.40.2",AUDIO="aud1"
uri2.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=2448841,CODECS="avc1.640020,ac-3",AUDIO="aud2"
uri1.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=8399417,CODECS="avc1.64002a,ac-3",AUDIO="aud2"
uri2.m3u8
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aud1",LANGUAGE="en",NAME="English",AUTOSELECT=YES,DEFAULT=YES,CHANNELS="2",URI="a1/prog_index.m3u8
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aud2",LANGUAGE="en",NAME="English",AUTOSELECT=YES,DEFAULT=YES,CHANNELS="6",URI="a2/prog_index.m3u8
''';


  const PLAYLIST_WITH_INDEPENDENT_SEGMENTS =
'''
 #EXTM3U 

#EXT-X-INDEPENDENT-SEGMENTS

#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="mp4a.40.2,avc1.66.30",RESOLUTION=304x128
http://example.com/low.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=1280000,CODECS="mp4a.40.2 , avc1.66.30 "
http://example.com/spaces_in_codecs.m3u8
''';


  const PLAYLIST_WITH_MATCHING_STREAM_INF_URLS =
'''
#EXTM3U
#EXT-X-VERSION:

#EXT-X-STREAM-INF:BANDWIDTH=2227464,CLOSED-CAPTIONS="cc1",AUDIO="aud1",SUBTITLES="sub1"
v5/prog_index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=6453202,CLOSED-CAPTIONS="cc1",AUDIO="aud1",SUBTITLES="sub1"
v8/prog_index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=5054232,CLOSED-CAPTIONS="cc1",AUDIO="aud1",SUBTITLES="sub1"
v7/prog_index.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=2448841,CLOSED-CAPTIONS="cc1",AUDIO="aud2",SUBTITLES="sub1"
v5/prog_index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=8399417,CLOSED-CAPTIONS="cc1",AUDIO="aud2",SUBTITLES="sub1"
v9/prog_index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=5275609,CLOSED-CAPTIONS="cc1",AUDIO="aud2",SUBTITLES="sub1"
v7/prog_index.m3u8

#EXT-X-STREAM-INF:BANDWIDTH=2256841,CLOSED-CAPTIONS="cc1",AUDIO="aud3",SUBTITLES="sub1"
v5/prog_index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=8207417,CLOSED-CAPTIONS="cc1",AUDIO="aud3",SUBTITLES="sub1"
v9/prog_index.m3u8
#EXT-X-STREAM-INF:BANDWIDTH=6482579,CLOSED-CAPTIONS="cc1",AUDIO="aud3",SUBTITLES="sub1"
v8/prog_index.m3u8

#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aud1",NAME="English",URI="a1/index.m3u8"
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aud2",NAME="English",URI="a2/index.m3u8
#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="aud3",NAME="English",URI="a3/index.m3u8

#EXT-X-MEDIA:TYPE=CLOSED-CAPTIONS,GROUP-ID="cc1",NAME="English",INSTREAM-ID="CC1"
#EXT-X-MEDIA:TYPE=SUBTITLES,GROUP-ID="sub1",NAME="English",URI="s1/en/prog_index.m3u8"
''';


  const PLAYLIST_WITH_VARIABLE_SUBSTITUTION =
r'''
 #EXTM3U 

#EXT-X-DEFINE:NAME="codecs",VALUE="mp4a.40.5"
#EXT-X-DEFINE:NAME="tricky",VALUE="This/{$nested}/reference/shouldnt/work"
#EXT-X-DEFINE:NAME="nested",VALUE="This should not be inserted"
#EXT-X-STREAM-INF:BANDWIDTH=65000,CODECS="{$codecs}"
http://example.com/{$tricky}
''';

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  Metadata _createExtXStreamInfMetadata(List<VariantInfo> infos) =>
      Metadata([HlsTrackMetadataEntry(variantInfos: infos)]);

  Metadata _createExtXMediaMetadata(String groupId, String name) =>
      Metadata([HlsTrackMetadataEntry(groupId: groupId, name: name, variantInfos: [])]);// ignore: always_specify_types

  VariantInfo _createVariantInfo(int bitrate, String audioGroupId) =>
      VariantInfo(
          bitrate: bitrate,
          audioGroupId: audioGroupId,
          subtitleGroupId: 'sub1',
          captionGroupId: 'cc1');

  ///@[HlsPlaylistParser.parseMasterPlaylist(extraLines, baseUri)]
  Future<HlsMasterPlaylist> parseMasterPlaylist(String uri, List<String> extraLines) async {
    var playlistUri = Uri.parse(uri);
    var parser = HlsPlaylistParser.create();
    var playList = await parser.parse(playlistUri, extraLines);
    return playList as HlsMasterPlaylist;
  }

  test('testParseMasterPlaylist', () async {
    HlsMasterPlaylist masterPlaylist;
    masterPlaylist = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_SIMPLE.split('\n'));

    var variants = masterPlaylist.variants;

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

  test('testMasterPlaylistWithBandwdithAverage', () async {
    var masterPlaylist = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_AVG_BANDWIDTH.split('\n'));

    var variants = masterPlaylist.variants;

    expect(variants[0].format.bitrate, 1280000);
    expect(variants[1].format.bitrate, 1270000);
  });

  test('testPlaylistWithInvalidHeader', () async {
    try {
      await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_INVALID_HEADER.split('\n'));
      fail('Expected exception not thrown.');
    } on ParserException catch (_) {
    // Expected due to invalid header.
    }
  });

  test('testPlaylistWithClosedCaption', () async {
    var masterPlaylist = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_CC.split('\n'), );
    expect(masterPlaylist.muxedCaptionFormats.length, 1);
    expect(masterPlaylist.muxedCaptionFormats[0].sampleMimeType, MimeTypes.APPLICATION_CEA708);
    expect(masterPlaylist.muxedCaptionFormats[0].accessibilityChannel, 4);
    expect(masterPlaylist.muxedCaptionFormats[0].language, 'es');
  });

  test('testPlaylistWithChannelsAttribute', () async {
    var masterPlaylist = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_CHANNELS_ATTRIBUTE.split('\n'));
    var audios = masterPlaylist.audios;
    expect(audios.length, 3);
    expect(audios[0].format.channelCount, 6);
    expect(audios[1].format.channelCount, 2);
    expect(audios[2].format.channelCount, isNull);
  });

  test('testPlaylistWithoutClosedCaptions', () async {
    var masterPlaylist = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITHOUT_CC.split('\n'), );
    expect(masterPlaylist.muxedCaptionFormats, isEmpty);
  });

  test('testCodecPropagation', () async {
    var masterPlaylist = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_AUDIO_MEDIA_TAG.split('\n'), );
    expect(masterPlaylist.audios[0].format.codecs, 'mp4a.40.2');
    expect(masterPlaylist.audios[0].format.sampleMimeType, MimeTypes.AUDIO_AAC);
    expect(masterPlaylist.audios[1].format.codecs, 'ac-3');
    expect(masterPlaylist.audios[1].format.sampleMimeType, MimeTypes.AUDIO_AC3);
  });

  test('testAudioIdPropagation', () async {
    var playlist = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_AUDIO_MEDIA_TAG.split('\n'), );
    expect(playlist.audios[0].format.id, 'aud1:English');
    expect(playlist.audios[1].format.id, 'aud2:English');
  });

  test('testCCIdPropagation', () async {
    var playlist = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_CC.split('\n'), );
    expect(playlist.muxedCaptionFormats[0].id, 'cc1:Eng');
  });

  test('testSubtitleIdPropagation', () async {
    var playlist = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_SUBTITLES.split('\n'), );
    expect(playlist.subtitles[0].format.id, 'sub1:Eng');
  });

  test('testIndependentSegments', () async {
    var playlistWithIndependentSegments = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_INDEPENDENT_SEGMENTS.split('\n'));
    expect(playlistWithIndependentSegments.hasIndependentSegments, true);
    var playlistWithoutIndependentSegments = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_SIMPLE.split('\n'));
    expect(playlistWithoutIndependentSegments.hasIndependentSegments, false);
  });

  test('testVariableSubstitution', () async {
    var playlistWithSubstitutions = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_VARIABLE_SUBSTITUTION.split('\n'));
    var variant = playlistWithSubstitutions.variants[0];
    expect(variant.format.codecs, 'mp4a.40.5');
    expect(variant.url, Uri.parse('http://example.com/This/{\$nested}/reference/shouldnt/work'));
  });

  test('testHlsMetadata', () async {
    var playlist = await parseMasterPlaylist(PLAYLIST_URI, PLAYLIST_WITH_MATCHING_STREAM_INF_URLS.split('\n'));

    expect(playlist.variants.length, 4);

    // ignore: always_specify_types
    expect(playlist.variants[0].format.metadata, _createExtXStreamInfMetadata([
      _createVariantInfo(2227464, 'aud1'),
      _createVariantInfo(2448841, 'aud2'),
      _createVariantInfo(2256841, 'aud3'),
    ]));
    // ignore: always_specify_types
    expect(playlist.variants[1].format.metadata, _createExtXStreamInfMetadata([
      _createVariantInfo(6453202, 'aud1'),
      _createVariantInfo(6482579, 'aud3'),
    ]));
    // ignore: always_specify_types
    expect(playlist.variants[2].format.metadata, _createExtXStreamInfMetadata([
      _createVariantInfo(5054232, 'aud1'),
      _createVariantInfo(5275609, 'aud2'),
    ]));
    // ignore: always_specify_types
    expect(playlist.variants[3].format.metadata, _createExtXStreamInfMetadata([
      _createVariantInfo(8399417, 'aud2'),
      _createVariantInfo(8207417, 'aud3'),
    ]));

    expect(playlist.audios.length, 3);
    expect(playlist.audios[0].format.metadata, _createExtXMediaMetadata('aud1', 'English'));
    expect(playlist.audios[1].format.metadata, _createExtXMediaMetadata('aud2', 'English'));
    expect(playlist.audios[2].format.metadata, _createExtXMediaMetadata('aud3', 'English'));
  });
}
