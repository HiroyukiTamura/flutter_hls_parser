import 'package:flutter_hls_parser_example/util.dart';

import 'drm_init_data.dart';
import 'package:meta/meta.dart';

class Segment {
  Segment({
    @required this.url,
    this.initializationSegment,
    this.durationUs = 0,
    this.title = '',
    this.relativeDiscontinuitySequence = -1,
    this.relativeStartTimeUs = Util.TIME_UNSET,
    this.drmInitData,
    @required this.fullSegmentEncryptionKeyUri,
    @required this.encryptionIV,
    @required this.byterangeOffset,
    @required this.byterangeLength,
    this.hasGapTag = false,
  });

  final String url;
  final Segment initializationSegment;
  final int durationUs;
  final String title;
  final int relativeDiscontinuitySequence;
  final int relativeStartTimeUs;
  final DrmInitData drmInitData;
  final String fullSegmentEncryptionKeyUri;
  final String encryptionIV;
  final int byterangeOffset;
  final int byterangeLength;
  final bool hasGapTag;
}
