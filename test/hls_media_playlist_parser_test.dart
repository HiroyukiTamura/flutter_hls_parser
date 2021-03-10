import 'package:flutter_hls_parser/src/hls_media_playlist.dart';
import 'package:flutter_hls_parser/src/util.dart';
import 'package:test/test.dart';
import 'package:flutter_hls_parser/src/exception.dart';
import 'package:flutter_hls_parser/src/hls_master_playlist.dart';
import 'package:flutter_hls_parser/src/hls_playlist_parser.dart';


void main() {

  const PLAYLIST_URL = 'https://example.com/test.m3u8';

  const PLAYLIST_STRING =
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
  
  const PLAYLIST_STRING_AES =
'''
#EXTM3U
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:8,
https://priv.example.com/1.ts

#EXT-X-KEY:METHOD=SAMPLE-AES,URI="data:text/plain;base64,VGhpcyBpcyBhbiBlYXN0ZXIgZWdn",IV=0x9358382AEB449EE23C3D809DA0B9CCD3,KEYFORMATVERSIONS="1",KEYFORMAT="com.widevine",IV=0x1566B
#EXTINF:8,
https://priv.example.com/2.ts
#EXT-X-ENDLIST;
''';

  const PLAYLIST_STRING_AES_CENC =
'''
#EXTM3U
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:8,
https://priv.example.com/1.ts

#EXT-X-KEY:URI="data:text/plain;base64,VGhpcyBpcyBhbiBlYXN0ZXIgZWdn",IV=0x9358382AEB449EE23C3D809DA0B9CCD3,KEYFORMATVERSIONS="1",KEYFORMAT="urn:uuid:edef8ba9-79d6-4ace-a3c8-27dcd51d21ed",IV=0x1566B,METHOD=SAMPLE-AES-CENC 
#EXTINF:8,
https://priv.example.com/2.ts
#EXT-X-ENDLIST
''';
  
  const PLAYLIST_STRING_AES_CTR =
'''
#EXTM3U
#EXT-X-MEDIA-SEQUENCE:0
#EXTINF:8,
https://priv.example.com/1.ts

#EXT-X-KEY:METHOD=SAMPLE-AES-CTR,URI="data:text/plain;base64,VGhpcyBpcyBhbiBlYXN0ZXIgZWdn",IV=0x9358382AEB449EE23C3D809DA0B9CCD3,KEYFORMATVERSIONS="1",KEYFORMAT="com.widevine",IV=0x1566B
#EXTINF:8,
https://priv.example.com/2.ts
#EXT-X-ENDLIST;
''';
  
  const PLAYLIST_STRING_MULTI_EXT =
'''
#EXTM3U
#EXT-X-VERSION:6
#EXT-X-TARGETDURATION:6
#EXT-X-MAP:URI="map.mp4"
#EXTINF:5.005,
s000000.mp4
#EXT-X-KEY:METHOD=SAMPLE-AES,KEYFORMAT="urn:uuid:edef8ba9-79d6-4ace-a3c8-27dcd51d21ed",KEYFORMATVERSIONS="1",URI="data:text/plain;base64,Tm90aGluZyB0byBzZWUgaGVyZQ=="
#EXT-X-KEY:METHOD=SAMPLE-AES,KEYFORMAT="com.microsoft.playready",KEYFORMATVERSIONS="1",URI="data:text/plain;charset=UTF-16;base64,VGhpcyBpcyBhbiBlYXN0ZXIgZWdn"
#EXT-X-KEY:METHOD=SAMPLE-AES,KEYFORMAT="com.apple.streamingkeydelivery",KEYFORMATVERSIONS="1",URI="skd://QW5vdGhlciBlYXN0ZXIgZWdn"
#EXT-X-MAP:URI="map.mp4"
#EXTINF:5.005,
s000000.mp4
#EXTINF:5.005,
s000001.mp4
#EXT-X-KEY:METHOD=SAMPLE-AES,KEYFORMAT="urn:uuid:edef8ba9-79d6-4ace-a3c8-27dcd51d21ed",KEYFORMATVERSIONS="1",URI="data:text/plain;base64,RG9uJ3QgeW91IGdldCB0aXJlZCBvZiBkb2luZyB0aGlzPw=="

#EXT-X-KEY:METHOD=SAMPLE-AES,KEYFORMAT="com.microsoft.playready",KEYFORMATVERSIONS="1",URI="data:text/plain;charset=UTF-16;base64,T2ssIGl0J3Mgbm90IGZ1biBhbnltb3Jl"
#EXT-X-KEY:METHOD=SAMPLE-AES,KEYFORMAT="com.apple.streamingkeydelivery",KEYFORMATVERSIONS="1",URI="skd://V2FpdCB1bnRpbCB5b3Ugc2VlIHRoZSBuZXh0IG9uZSE="
#EXTINF:5.005,
s000024.mp4
#EXTINF:5.005,
s000025.mp4
#EXT-X-KEY:METHOD=NONE
#EXTINF:5.005,
s000026.mp4
#EXTINF:5.005,
s000026.mp4;
''';

  const PLAYLIST_STRING_GAP_TAG =
'''
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:5
#EXT-X-PLAYLIST-TYPE:VOD
#EXT-X-MEDIA-SEQUENCE:0
#EXT-X-PROGRAM-DATE-TIME:2016-09-22T02:00:01+00:00
#EXT-X-KEY:METHOD=AES-128,URI="https://example.com/key?value=something"
#EXTINF:5.005,
02/00/27.ts
#EXTINF:5.005,
02/00/32.ts
#EXT-X-KEY:METHOD=NONE
#EXTINF:5.005,
#EXT-X-GAP
../dummy.ts
#EXT-X-KEY:METHOD=AES-128,URI="https://key-service.bamgrid.com/1.0/key?hex-value=9FB8989D15EEAAF8B21B860D7ED3072A",IV=0x410C8AC18AA42EFA18B5155484F5FC34
#EXTINF:5.005,
02/00/42.ts
#EXTINF:5.005,
02/00/47.ts
''';
  
  const PLAYLIST_STRING_MAP_TAG =
'''
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:5
#EXT-X-MEDIA-SEQUENCE:10
#EXTINF:5.005,
02/00/27.ts
#EXT-X-MAP:URI="init1.ts"
#EXTINF:5.005,
02/00/32.ts
#EXTINF:5.005,
02/00/42.ts
#EXT-X-MAP:URI="init2.ts"
#EXTINF:5.005,
02/00/47.ts;
''';

  const PLAYLIST_STRING_ENCRYPTED_MAP =
'''
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:5
#EXT-X-MEDIA-SEQUENCE:10
#EXT-X-KEY:METHOD=AES-128,URI="https://priv.example.com/key.php?r=2680",IV=0x1566B
#EXT-X-MAP:URI="init1.ts"
#EXTINF:5.005,
02/00/32.ts
#EXT-X-KEY:METHOD=NONE
#EXT-X-MAP:URI="init2.ts"
#EXTINF:5.005,
02/00/47.ts
''';
    
  const PLAYLIST_STRING_WRONG_ENCRYPTED_MAP =
'''
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:5
#EXT-X-MEDIA-SEQUENCE:10
#EXT-X-KEY:METHOD=AES-128,URI="https://priv.example.com/key.php?r=2680"
#EXT-X-MAP:URI="init1.ts"
#EXTINF:5.005,
02/00/32.ts
''';
  
  const PLAYLIST_STRING_PLANE =
'''
#EXTM3U
#EXT-X-VERSION:3
#EXT-X-TARGETDURATION:5
#EXT-X-MEDIA-SEQUENCE:10
#EXTINF:5.005,
02/00/27.ts
#EXT-X-MAP:URI="init1.ts"
#EXTINF:5.005,
02/00/32.ts
#EXTINF:5.005,
02/00/42.ts
#EXT-X-MAP:URI="init2.ts"
#EXTINF:5.005,
02/00/47.ts;
''';
  
  const PLAYLIST_STRING_VARIABLE_SUBSITUATION =
r'''
#EXTM3U
#EXT-X-VERSION:8
#EXT-X-DEFINE:NAME="underscore_1",VALUE="{"
#EXT-X-DEFINE:NAME="dash-1",VALUE="replaced_value.ts"
#EXT-X-TARGETDURATION:5
#EXT-X-MEDIA-SEQUENCE:10
#EXTINF:5.005,
segment1.ts
#EXT-X-MAP:URI="{$dash-1}"
#EXTINF:5.005
segment{$underscore_1}$name_1}
''';
  
  const PLAYLIST_STRING_INHERITED_VS = 
r''' 
#EXTM3U
#EXT-X-VERSION:8
#EXT-X-TARGETDURATION:5
#EXT-X-MEDIA-SEQUENCE:10
#EXT-X-DEFINE:IMPORT="imported_base"
#EXTINF:5.005,
{$imported_base}1.ts
#EXTINF:5.005,
{$imported_base}2.ts
#EXTINF:5.005,
{$imported_base}3.ts
#EXTINF:5.005,
{$imported_base}4.ts
''';
  

  Future<HlsMediaPlaylist> _parseMediaPlaylist(List<String> extraLines, String uri) async {
    var playlistUri = Uri.parse(uri);
    var parser = HlsPlaylistParser.create();
    var playList = await parser.parse(playlistUri, extraLines);
    return playList as HlsMediaPlaylist;
  }

  test('testParseMediaPlaylist', () async {
    var playlist = await _parseMediaPlaylist(PLAYLIST_STRING.split('\n'), PLAYLIST_URL);
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

    expect(playlist.segments[1].relativeDiscontinuitySequence, 0);
    expect(playlist.segments[1].durationUs, 7975000);
    expect(playlist.segments[1].title, 'segment title');
    expect(playlist.segments[1].fullSegmentEncryptionKeyUri, 'https://priv.example.com/key.php?r=2680');
    expect(playlist.segments[1].encryptionIV, '0x1566B');
    expect(playlist.segments[1].byterangeLength, 51501);
    expect(playlist.segments[1].byterangeOffset, 2147483648);
    expect(playlist.segments[1].url, 'https://priv.example.com/fileSequence2680.ts');

    expect(playlist.segments[2].relativeDiscontinuitySequence, 0);
    expect(playlist.segments[2].durationUs, 7941000);
    expect(playlist.segments[2].title, 'segment title .,:/# with interesting chars');
    expect(playlist.segments[2].fullSegmentEncryptionKeyUri, null);
    expect(playlist.segments[2].encryptionIV, null);
    expect(playlist.segments[2].byterangeLength, 51501);
    expect(playlist.segments[2].byterangeOffset, 2147535149);
    expect(playlist.segments[2].url, 'https://priv.example.com/fileSequence2681.ts');

    expect(playlist.segments[3].relativeDiscontinuitySequence, 1);
    expect(playlist.segments[3].durationUs, 7975000);
    expect(playlist.segments[3].title, isEmpty);
    expect(playlist.segments[3].fullSegmentEncryptionKeyUri, 'https://priv.example.com/key.php?r=2682');
    expect(playlist.segments[3].encryptionIV, 'A7A'.toLowerCase());
    expect(playlist.segments[3].byterangeLength, 51740);
    expect(playlist.segments[3].byterangeOffset, 2147586650);
    expect(playlist.segments[3].url, 'https://priv.example.com/fileSequence2682.ts');

    expect(playlist.segments[4].relativeDiscontinuitySequence, 1);
    expect(playlist.segments[4].durationUs, 7975000);
    expect(playlist.segments[4].fullSegmentEncryptionKeyUri, 'https://priv.example.com/key.php?r=2682');
    expect(playlist.segments[4].encryptionIV, 'A7B'.toLowerCase());
    expect(playlist.segments[4].byterangeLength, null);
    expect(playlist.segments[4].byterangeOffset, null);
    expect(playlist.segments[4].url, 'https://priv.example.com/fileSequence2683.ts');
  });

  test('testParseSampleAesMethod', () async {
    var playlist = await _parseMediaPlaylist(PLAYLIST_STRING_AES.split('\n'), PLAYLIST_URL);
    expect(playlist.protectionSchemes.schemeType, CencType.CBCS);
//    expect(playlist.protectionSchemes.schemeData[0].uuid, true);
    expect(playlist.protectionSchemes.schemeData[0].data?.isNotEmpty != true, true);
    expect(playlist.segments[0].drmInitData, null);
//    expect(playlist.segments[1].drmInitData.schemeData[0].uuid, true);
    expect(playlist.segments[1].drmInitData.schemeData[0].data?.isNotEmpty != false, true);
  });

  test('testParseSampleAesCtrMethod', () async {
    var playlist = await _parseMediaPlaylist(PLAYLIST_STRING_AES_CTR.split('\n'), PLAYLIST_URL);

    expect(playlist.protectionSchemes.schemeType, CencType.CENC);
//    expect(playlist.protectionSchemes.schemeData[0].uuid, true);
    expect(playlist.protectionSchemes.schemeData[0].data?.isNotEmpty != true, true);
  });

  test('testParseSampleAesCencMethod', () async {
    var playlist = await _parseMediaPlaylist(PLAYLIST_STRING_AES_CENC.split('\n'), PLAYLIST_URL);

    expect(playlist.protectionSchemes.schemeType, CencType.CENC);
//    expect(playlist.protectionSchemes.schemeData[0].uuid, true);
    expect(playlist.protectionSchemes.schemeData[0].data?.isNotEmpty != true, true);
  });

  test('testMultipleExtXKeysForSingleSegment', () async {
    var playlist = await _parseMediaPlaylist(PLAYLIST_STRING_MULTI_EXT.split('\n'), PLAYLIST_URL);

    expect(playlist.protectionSchemes?.schemeType, CencType.CBCS);
    expect(playlist.protectionSchemes?.schemeData?.length, 2);
//    expect(playlist.protectionSchemes.schemeData[0].uuid, true);
    expect(playlist.protectionSchemes.schemeData[0].data?.isNotEmpty != true, true);
    //    expect(playlist.protectionSchemes.schemeData[0].uuid, true);
    expect(playlist.protectionSchemes.schemeData[1].data?.isNotEmpty != true, true);

    expect(playlist.segments[0].drmInitData, null);

//    expect(playlist.segments[0].drmInitData.schemeData[0].uuid, true);
    expect(playlist.segments[1].drmInitData.schemeData[0].data?.isNotEmpty != false, true);
    //    expect(playlist.segments[0].drmInitData.schemeData[0].uuid, true);
    expect(playlist.segments[1].drmInitData.schemeData[1].data?.isNotEmpty != false, true);

    expect(playlist.segments[1].drmInitData, playlist.segments[2].drmInitData);
    expect(playlist.segments[2].drmInitData == playlist.segments[3].drmInitData, false);

//    expect(playlist.segments[3].drmInitData.schemeData[0].uuid, true);
    expect(playlist.segments[3].drmInitData.schemeData[0].data?.isNotEmpty != false, true);
    //    expect(playlist.segments[3].drmInitData.schemeData[1].uuid, true);
    expect(playlist.segments[3].drmInitData.schemeData[1].data?.isNotEmpty != false, true);

    expect(playlist.segments[3].drmInitData, playlist.segments[4].drmInitData);
    expect(playlist.segments[5].drmInitData, null);
    expect(playlist.segments[6].drmInitData, null);
  });


  test('testGapTag', () async {
    var playlist = await _parseMediaPlaylist(PLAYLIST_STRING_GAP_TAG.split('\n'), PLAYLIST_URL);
    expect(playlist.hasEndTag, false);
    expect(playlist.segments[1].hasGapTag, false);
    expect(playlist.segments[2].hasGapTag, true);
    expect(playlist.segments[3].hasGapTag, false);
  });


  test('testMapTag', () async {
    var playlist = await _parseMediaPlaylist(PLAYLIST_STRING_MAP_TAG.split('\n'), PLAYLIST_URL);

    var segments = playlist.segments;
    expect(segments[0].initializationSegment, null);
    expect(identical(segments[1].initializationSegment, segments[2].initializationSegment), true);
    expect(segments[1].initializationSegment.url, 'init1.ts');
    expect(segments[3].initializationSegment.url, 'init2.ts');
  });

  test('testEncryptedMapTag', () async {
    var playlist = await _parseMediaPlaylist(PLAYLIST_STRING_ENCRYPTED_MAP.split('\n'), PLAYLIST_URL);

    var segments = playlist.segments;

    expect(segments[0].initializationSegment.fullSegmentEncryptionKeyUri, 'https://priv.example.com/key.php?r=2680');
    expect(segments[0].encryptionIV, '0x1566B');
    expect(segments[1].initializationSegment.fullSegmentEncryptionKeyUri, null);
    expect(segments[1].encryptionIV, null);
  });

  test('testEncryptedMapTagWithNoIvFailure', () async {
    try {
      await _parseMediaPlaylist(PLAYLIST_STRING_WRONG_ENCRYPTED_MAP.split('\n'), PLAYLIST_URL);
      fail('forced failure');
    } on ParserException catch (_) {

    }
  });

  test('testMasterPlaylistAttributeInheritance', () async {
    var playlist = await _parseMediaPlaylist(PLAYLIST_STRING_PLANE.split('\n'), PLAYLIST_URL);//todoいい加減このURL共通化する
    
    expect(playlist.hasIndependentSegments, false);

    var masterPlaylist = HlsMasterPlaylist(
      baseUri: 'https://example.com/',
        tags: [],
        variants: [],
        videos: [],
        audios: [],
        subtitles: [],
        closedCaptions: [],
        muxedAudioFormat: null,
        muxedCaptionFormats: null,
        hasIndependentSegments: true,
        variableDefinitions: {},
        sessionKeyDrmInitData: []);
    var h = await HlsPlaylistParser.create(masterPlaylist: masterPlaylist).parse(Uri.parse(PLAYLIST_URL), PLAYLIST_STRING_PLANE.split('\n'));
    var hlsMediaPlaylist = h as HlsMediaPlaylist;

    expect(hlsMediaPlaylist.hasIndependentSegments, true);
  });


  test('testVariableSubstitution', () async {
    var playlist = await _parseMediaPlaylist(PLAYLIST_STRING_VARIABLE_SUBSITUATION.split('\n'), PLAYLIST_URL);//todoいい加減このURL共通化する

    expect(playlist.segments[1].initializationSegment.url, 'replaced_value.ts');
    expect(playlist.segments[1].url, 'segment{\$name_1}');
  });


  test('testInheritedVariableSubstitution', () async {
    var variableDefinitions = <String, String>{};
    variableDefinitions['imported_base'] = 'long_path';
    var masterPlaylist = HlsMasterPlaylist(
        baseUri: '',
        tags: [],
        variants: [],
        videos: [],
        audios: [],
        subtitles: [],
        closedCaptions: [],
        muxedAudioFormat: null,
        muxedCaptionFormats: [],
        hasIndependentSegments: false,
        variableDefinitions: variableDefinitions,
        sessionKeyDrmInitData: []);

    var hlsMediaPlaylist = await HlsPlaylistParser(masterPlaylist).parse(Uri.parse(PLAYLIST_URL), PLAYLIST_STRING_INHERITED_VS.split('\n'));//todo 引数そろえるべき
    var segments = (hlsMediaPlaylist as HlsMediaPlaylist).segments;
    for (var i = 1; i < 4; i++)
      expect(segments[i-1].url, 'long_path$i.ts');
  });
}
