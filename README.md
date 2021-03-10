# flutter_hls_parser

![Pub Version](https://img.shields.io/pub/v/flutter_hls_parser)
[![codecov](https://codecov.io/gh/HiroyukTamura/flutter_hls_parser/branch/master/graph/badge.svg?token=ExYmJJIAVX)](https://codecov.io/gh/HiroyukTamura/flutter_hls_parser)
[![FlutterTest](https://github.com/HiroyukTamura/flutter_hls_parser/actions/workflows/flutter-test.yml/badge.svg)](https://github.com/HiroyukTamura/flutter_hls_parser/actions/workflows/flutter-test.yml)

dart plugin for parse m3u8 file for HLS.  
both of master and media file are supported.

## Getting Started

```dart

Uri playlistUri;
List<String> lines;
try {
  playList = await HlsPlaylistParser.create().parseString(playlistUri, contentString);
} on ParserException catch (e) {
  print(e);
}

if (playlist is HlsMasterPlaylist) {
  // master m3u8 file
} else if (playlist is HlsMediaPlaylist) {
  // media m3u8 file
}
```

## Supported tags
```
EXTM3U
EXT-X-VERSION
EXT-X-PLAYLIST-TYPE
EXT-X-DEFINE
EXT-X-STREAM-INF
EXT-X-MEDIA
EXT-X-TARGETDURATION
EXT-X-DISCONTINUITY
EXT-X-DISCONTINUITY-SEQUENCE
EXT-X-PROGRAM-DATE-TIME
EXT-X-MAP
EXT-X-INDEPENDENT-SEGMENTS
EXTINF
EXT-X-MEDIA-SEQUENCE
EXT-X-START
EXT-X-ENDLIST
EXT-X-KEY
EXT-X-SESSION-KEY
EXT-X-BYTERANGE
EXT-X-GAP
```

## No Supported Tag
```
EXT-X-I-FRAMES-ONLY
EXT-X-I-FRAME-STREAM-INF
EXT-X-ALLOW-CACHE
EXT-X-SESSION-DATA
EXT-X-DATERANGE
EXT-X-BITRATE
EXT-X-SERVER-CONTROL
EXT-X-CUE-OUT:<duration>
EXT-X-CUE-IN
```

### Note
all bool param is nonnull, and others are often nullable if unknown.

### MasterPlaylist example
```dart
HlsMasterPlaylist playlist;

playlist.variants[0].format.bitrate;// => 1280000
Util.splitCodec(playlist.variants[0].format.codecs);// => ['mp4a.40.2']['avc1.66.30']
playlist.variants[0].format.width;// => 304(px)
playlist.subtitles[0].format.id;// => sub1:Eng
playlist.audios[0].format.sampleMimeType// => MimeTypes.AUDIO_AC3
```

### MediaPlaylist example
```dart
HlsMediaPlaylist playlist;

playlist.version;// => 3
playlist.hasEndTag;// => true
playlist.segments[0].durationUs;// => 7975000(microsec)
playlist.segments[0].encryptionIV;// => '0x1566B'
```
