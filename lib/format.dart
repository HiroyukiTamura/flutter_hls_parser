import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:flutter/cupertino.dart';

import 'drm_init_data.dart';
import 'color_info.dart';
import 'metadata.dart';
import 'util.dart';

class Format {
  Format({
    @required this.id,
    @required this.label,
    @required this.selectionFlags,
    @required this.roleFlags,
    @required this.bitrate,
    @required this.codecs,
    @required this.metadata,
    @required this.containerMimeType,
    @required this.sampleMimeType,
    @required this.maxInputSize,
    @required this.initializationData,
    @required this.drmInitData,
    @required this.subsampleOffsetUs,
    @required this.width,
    @required this.height,
    @required this.frameRate,
    @required this.rotationDegrees,
    @required this.pixelWidthHeightRatio,
    @required this.projectionData,
    @required this.stereoMode,
    @required this.colorInfo,
    @required this.channelCount,
    @required this.sampleRate,
    @required this.pcmEncoding,
    @required this.encoderDelay,
    @required this.encoderPadding,
    @required this.language,
    @required this.accessibilityChannel,
  });

  factory Format.create({
    String id,
    String label,
    int selectionFlags = 0,
    int roleFlags = 0,
    int bitrate,
    String codecs,
    Metadata metadata,
    String containerMimeType,
    String sampleMimeType,
    int maxInputSize = NO_VALUE,
    List<Uint8List> initializationData = const [],// ignore: always_specify_types
    DrmInitData drmInitData,
    int subsampleOffsetUs = _OFFSET_SAMPLE_RELATIVE,
    int width,
    int height,
    double frameRate,
    int rotationDegrees = NO_VALUE,
    double pixelWidthHeightRatio = NO_VALUE_D,
    Uint8List projectionData,
    int stereoMode,
    ColorInfo colorInfo,
    int channelCount,
    int sampleRate,
    int pcmEncoding,
    int encoderDelay = NO_VALUE,
    int encoderPadding = NO_VALUE,
    String language,
    int accessibilityChannel,
  }) {
    if (rotationDegrees == NO_VALUE) rotationDegrees = 0;
    if (pixelWidthHeightRatio == NO_VALUE) pixelWidthHeightRatio = 0;
    if (encoderDelay == NO_VALUE) encoderDelay = 0;
    if (encoderPadding == NO_VALUE) encoderPadding = 0;
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

  factory Format.createVideoContainerFormat({
    String id,
    String label,
    String containerMimeType,
    String sampleMimeType,
    @required String codecs,
    @required int bitrate,
    @required int width,
    @required int height,
    @required double frameRate,
    List<Uint8List> initializationData,
    int selectionFlags = 0,
    int roleFlags
  }) =>
      Format.create(
        id: id,
        label: label,
        selectionFlags: selectionFlags,
        bitrate: bitrate,
        codecs: codecs,
        containerMimeType: containerMimeType,
        sampleMimeType: sampleMimeType,
        initializationData: initializationData,
        width: width,
        height: height,
        frameRate: frameRate,
        roleFlags: roleFlags,
      );

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

  static const int NO_VALUE = -1;
  static const double NO_VALUE_D = -1;
  static const int _OFFSET_SAMPLE_RELATIVE = NO_VALUE; //todo 要検討

  Format copyWithMetadata(Metadata metadata) => Format(
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
      accessibilityChannel: accessibilityChannel,);
}
