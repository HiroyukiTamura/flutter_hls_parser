import 'dart:typed_data';
import 'package:meta/meta.dart';
import 'package:flutter/cupertino.dart';

import 'drm_init_data.dart';
import 'color_info.dart';
import 'metadata.dart';

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
    this.initializationData = const [],
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
    String language,
    this.accessibilityChannel,
  }): language = language?.toLowerCase();

  factory Format.createVideoContainerFormat({
    String id,
    String label,
    String containerMimeType,
    String sampleMimeType,
    @required String codecs,
    int bitrate,
    @required int width,
    @required int height,
    @required double frameRate,
    List<Uint8List> initializationData,
    int selectionFlags = 0,
    int roleFlags
  }) =>
      Format(
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
