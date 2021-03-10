import 'package:test/test.dart';
import 'package:flutter_hls_parser/src/mime_types.dart';

/// test for [MimeTypes]
class MimeTypesTest {
  /// test for [MimeTypes.getMediaMimeType(codec)]
  // ignore: non_constant_identifier_names
  static void testGetMediaMimeType_fromValidCodecs_returnsCorrectMimeType() {
    expect(MimeTypes.getMediaMimeType('avc1'), MimeTypes.VIDEO_H264);
    expect(MimeTypes.getMediaMimeType('avc1.42E01E'), MimeTypes.VIDEO_H264);

    expect(MimeTypes.getMediaMimeType('avc1.42E01F'), MimeTypes.VIDEO_H264);
    expect(MimeTypes.getMediaMimeType('avc1.4D401F'), MimeTypes.VIDEO_H264);
    expect(MimeTypes.getMediaMimeType('avc1.4D4028'), MimeTypes.VIDEO_H264);
    expect(MimeTypes.getMediaMimeType('avc1.640028'), MimeTypes.VIDEO_H264);
    expect(MimeTypes.getMediaMimeType('avc1.640029'), MimeTypes.VIDEO_H264);
    expect(MimeTypes.getMediaMimeType('avc3'), MimeTypes.VIDEO_H264);
    expect(MimeTypes.getMediaMimeType('hev1'), MimeTypes.VIDEO_H265);
    expect(MimeTypes.getMediaMimeType('hvc1'), MimeTypes.VIDEO_H265);
    expect(MimeTypes.getMediaMimeType('vp08'), MimeTypes.VIDEO_VP8);
    expect(MimeTypes.getMediaMimeType('vp8'), MimeTypes.VIDEO_VP8);
    expect(MimeTypes.getMediaMimeType('vp09'), MimeTypes.VIDEO_VP9);
    expect(MimeTypes.getMediaMimeType('vp9'), MimeTypes.VIDEO_VP9);

    expect(MimeTypes.getMediaMimeType('ac-3'), MimeTypes.AUDIO_AC3);
    expect(MimeTypes.getMediaMimeType('dac3'), MimeTypes.AUDIO_AC3);
    expect(MimeTypes.getMediaMimeType('dec3'), MimeTypes.AUDIO_E_AC3);
    expect(MimeTypes.getMediaMimeType('ec-3'), MimeTypes.AUDIO_E_AC3);
    expect(MimeTypes.getMediaMimeType('ec+3'), MimeTypes.AUDIO_E_AC3_JOC);
    expect(MimeTypes.getMediaMimeType('dtsc'), MimeTypes.AUDIO_DTS);
    expect(MimeTypes.getMediaMimeType('dtse'), MimeTypes.AUDIO_DTS);
    expect(MimeTypes.getMediaMimeType('dtsh'), MimeTypes.AUDIO_DTS_HD);
    expect(MimeTypes.getMediaMimeType('dtsl'), MimeTypes.AUDIO_DTS_HD);
    expect(MimeTypes.getMediaMimeType('opus'), MimeTypes.AUDIO_OPUS);
    expect(MimeTypes.getMediaMimeType('vorbis'), MimeTypes.AUDIO_VORBIS);
    expect(MimeTypes.getMediaMimeType('mp4a'), MimeTypes.AUDIO_AAC);
    expect(MimeTypes.getMediaMimeType('mp4a.40.02'), MimeTypes.AUDIO_AAC);
    expect(MimeTypes.getMediaMimeType('mp4a.40.05'), MimeTypes.AUDIO_AAC);
    expect(MimeTypes.getMediaMimeType('mp4a.40.2'), MimeTypes.AUDIO_AAC);
    expect(MimeTypes.getMediaMimeType('mp4a.40.5'), MimeTypes.AUDIO_AAC);
    expect(MimeTypes.getMediaMimeType('mp4a.40.29'), MimeTypes.AUDIO_AAC);
    expect(MimeTypes.getMediaMimeType('mp4a.66'), MimeTypes.AUDIO_AAC);
    expect(MimeTypes.getMediaMimeType('mp4a.67'), MimeTypes.AUDIO_AAC);
    expect(MimeTypes.getMediaMimeType('mp4a.68'), MimeTypes.AUDIO_AAC);
    expect(MimeTypes.getMediaMimeType('mp4a.69'), MimeTypes.AUDIO_MPEG);
    expect(MimeTypes.getMediaMimeType('mp4a.6B'), MimeTypes.AUDIO_MPEG);
    expect(MimeTypes.getMediaMimeType('mp4a.a5'), MimeTypes.AUDIO_AC3);
    expect(MimeTypes.getMediaMimeType('mp4a.A5'), MimeTypes.AUDIO_AC3);
    expect(MimeTypes.getMediaMimeType('mp4a.a6'), MimeTypes.AUDIO_E_AC3);
    expect(MimeTypes.getMediaMimeType('mp4a.A6'), MimeTypes.AUDIO_E_AC3);
    expect(MimeTypes.getMediaMimeType('mp4a.A9'), MimeTypes.AUDIO_DTS);
    expect(MimeTypes.getMediaMimeType('mp4a.AC'), MimeTypes.AUDIO_DTS);
    expect(MimeTypes.getMediaMimeType('mp4a.AA'), MimeTypes.AUDIO_DTS_HD);
    expect(MimeTypes.getMediaMimeType('mp4a.AB'), MimeTypes.AUDIO_DTS_HD);
    expect(MimeTypes.getMediaMimeType('mp4a.AD'), MimeTypes.AUDIO_OPUS);
  }

  /// change access modifier when you run test
  /// test for [MimeTypes.getMimeTypeFromMp4ObjectType(objectType)]
  // ignore: non_constant_identifier_names
  static void
      testGetMimeTypeFromMp4ObjectType_forValidObjectType_returnsCorrectMimeType() {
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x60), MimeTypes.VIDEO_MPEG2);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x61), MimeTypes.VIDEO_MPEG2);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x20), MimeTypes.VIDEO_MP4V);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x21), MimeTypes.VIDEO_H264);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x23), MimeTypes.VIDEO_H265);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x6B), MimeTypes.AUDIO_MPEG);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x40), MimeTypes.AUDIO_AAC);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x66), MimeTypes.AUDIO_AAC);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x67), MimeTypes.AUDIO_AAC);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x68), MimeTypes.AUDIO_AAC);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0xA5), MimeTypes.AUDIO_AC3);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0xA6), MimeTypes.AUDIO_E_AC3);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0xA9), MimeTypes.AUDIO_DTS);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0xAC), MimeTypes.AUDIO_DTS);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0xAA), MimeTypes.AUDIO_DTS_HD);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0xAB), MimeTypes.AUDIO_DTS_HD);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0xAD), MimeTypes.AUDIO_OPUS);
  }

  /// change access modifier when you run test
  /// test for [MimeTypes.getMimeTypeFromMp4ObjectType(objectType)]
  // ignore: non_constant_identifier_names
  static void
      testGetMimeTypeFromMp4ObjectType_forInvalidObjectType_returnsNull() {
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0), isNull);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x600), isNull);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(0x01), isNull);
//    expect(MimeTypes.getMimeTypeFromMp4ObjectType(-1), isNull);
  }
}

void main() {
  test('testMimeType', () {
    MimeTypesTest.testGetMediaMimeType_fromValidCodecs_returnsCorrectMimeType();
    MimeTypesTest
        .testGetMimeTypeFromMp4ObjectType_forValidObjectType_returnsCorrectMimeType();
    MimeTypesTest
        .testGetMimeTypeFromMp4ObjectType_forInvalidObjectType_returnsNull();
  });
}
