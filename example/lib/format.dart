import 'dart:typed_data';
import 'drm_init_data.dart';
import 'color_info.dart';
import 'metadata.dart';
import 'util.dart' as util;

class Format {
  Format({
    this.id,
    this.label,
    this.selectionFlags,
    this.roleFlags,
    this.bitrate,
    this.codecs,
    this.metadata,
    this.containerMimeType,
    this.sampleMimeType,
    this.maxInputSize,
    this.initializationData,
    this.drmInitData,
    this.subsampleOffsetUs,
    this.width,
    this.height,
    this.frameRate,
    this.rotationDegrees,
    this.pixelWidthHeightRatio,
    this.projectionData,
    this.stereoMode,
    this.colorInfo,
    this.channelCount,
    this.sampleRate,
    this.pcmEncoding,
    this.encoderDelay,
    this.encoderPadding,
    this.language,
    this.accessibilityChannel,
  });

  factory Format.create({
    String id,
    String label,
    int selectionFlags,
    int roleFlags,
    int bitrate,
    String codecs,
    Metadata metadata,
    String containerMimeType,
    String sampleMimeType,
    int maxInputSize,
    List<Uint8List> initializationData,
    DrmInitData drmInitData,
    int subsampleOffsetUs,
    int width,
    int height,
    double frameRate,
    int rotationDegrees,
    double pixelWidthHeightRatio,
    Uint8List projectionData,
    int stereoMode,
    ColorInfo colorInfo,
    int channelCount,
    int sampleRate,
    int pcmEncoding,
    int encoderDelay,
    int encoderPadding,
    String language,
    int accessibilityChannel,
  }) {
    initializationData ??= []; // ignore: always_specify_types
    if (rotationDegrees == util.Format.NO_VALUE)
      rotationDegrees = 0;
    if (pixelWidthHeightRatio == util.Format.NO_VALUE)
      pixelWidthHeightRatio = 0;
    if (encoderDelay == util.Format.NO_VALUE)
      encoderDelay = 0;
    if (encoderPadding == util.Format.NO_VALUE)
      encoderPadding = 0;
    language = language.toLowerCase(); //todo再検討
    return Format(
        id: id,
        label: label,
        selectionFlags: selectionFlags,
        roleFlags: roleFlags,
        bitrate: bitrate,
        codecs: codecs,
        metadata: metadata,
        containerMimeType: containerMimeType,
        sampleMimeType: sampleMimeType,
        maxInputSize: maxInputSize,
        initializationData: initializationData,
        drmInitData: drmInitData,
        subsampleOffsetUs: subsampleOffsetUs,
        width: width,
        height: height,
        frameRate: frameRate,
        rotationDegrees: rotationDegrees,
        pixelWidthHeightRatio: pixelWidthHeightRatio,
        projectionData: projectionData,
        stereoMode: stereoMode,
        colorInfo: colorInfo,
        channelCount: channelCount,
        sampleRate: sampleRate,
        pcmEncoding: pcmEncoding,
        encoderDelay: encoderDelay,
        encoderPadding: encoderPadding,
        language: language,
        accessibilityChannel: accessibilityChannel);
  }

  String id;
  String label;
  int selectionFlags;
  int roleFlags;
  int bitrate;
  String codecs;
  Metadata metadata;
  String containerMimeType;
  String sampleMimeType;
  int maxInputSize;
  List<Uint8List> initializationData;
  DrmInitData drmInitData;
  int subsampleOffsetUs;
  int width;
  int height;
  double frameRate;
  int rotationDegrees;
  double pixelWidthHeightRatio;
  Uint8List projectionData;
  int stereoMode;
  ColorInfo colorInfo;

  // Audio specific.
  int channelCount;
  int sampleRate;
  int pcmEncoding;
  int encoderDelay;
  int encoderPadding;

  // Audio and text specific.
  String language;
  int accessibilityChannel;
}
