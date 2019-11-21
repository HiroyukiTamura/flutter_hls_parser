import 'dart:typed_data';
import 'drm_init_data.dart';

class Format {

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
//  this.id = id;
//  this.label = label;
//  this.selectionFlags = selectionFlags;
//  this.roleFlags = roleFlags;
//  this.bitrate = bitrate;
//  this.codecs = codecs;
//  this.metadata = metadata;
//  // Container specific.
//  this.containerMimeType = containerMimeType;
//  // Elementary stream specific.
//  this.sampleMimeType = sampleMimeType;
//  this.maxInputSize = maxInputSize;
//  this.initializationData =
//  initializationData == null ? Collections.emptyList() : initializationData;
//  this.drmInitData = drmInitData;
//  this.subsampleOffsetUs = subsampleOffsetUs;
//  // Video specific.
//  this.width = width;
//  this.height = height;
//  this.frameRate = frameRate;
//  this.rotationDegrees = rotationDegrees == Format.NO_VALUE ? 0 : rotationDegrees;
//  this.pixelWidthHeightRatio =
//  pixelWidthHeightRatio == Format.NO_VALUE ? 1 : pixelWidthHeightRatio;
//  this.projectionData = projectionData;
//  this.stereoMode = stereoMode;
//  this.colorInfo = colorInfo;
//  // Audio specific.
//  this.channelCount = channelCount;
//  this.sampleRate = sampleRate;
//  this.pcmEncoding = pcmEncoding;
//  this.encoderDelay = encoderDelay == Format.NO_VALUE ? 0 : encoderDelay;
//  this.encoderPadding = encoderPadding == Format.NO_VALUE ? 0 : encoderPadding;
//  // Audio and text specific.
//  this.language = Util.normalizeLanguageCode(language);
//  this.accessibilityChannel = accessibilityChannel;
}