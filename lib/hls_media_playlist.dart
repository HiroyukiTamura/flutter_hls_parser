import 'package:meta/meta.dart';
import 'segment.dart';
import 'drm_init_data.dart';
import 'playlist.dart';

class HlsMediaPlaylist extends HlsPlaylist {
  HlsMediaPlaylist({
    @required this.playlistType,
    @required this.startOffsetUs,
    @required this.startTimeUs,
    @required this.hasDiscontinuitySequence,
    @required this.discontinuitySequence,
    @required this.mediaSequence,
    @required this.version,
    @required this.targetDurationUs,
    @required this.hasEndTag,
    @required this.hasProgramDateTime,
    @required this.protectionSchemes,
    @required this.segments,
    @required this.durationUs,
    @required String baseUri,
    @required List<String> tags,
    @required bool hasIndependentSegments,
  }) : super(
          baseUri: baseUri,
          tags: tags,
          hasIndependentSegments: hasIndependentSegments,
        );

  factory HlsMediaPlaylist.create({
    @required int playlistType,
    @required int startOffsetUs,
    @required int startTimeUs,
    @required bool hasDiscontinuitySequence,
    @required int discontinuitySequence,
    @required int mediaSequence,
    @required int version,
    @required int targetDurationUs,
    @required bool hasEndTag,
    @required bool hasProgramDateTime,
    @required DrmInitData protectionSchemes,
    @required List<Segment> segments,
    @required String baseUri,
    @required List<String> tags,
    @required bool hasIndependentSegments,
  }) {
    int durationUs = segments.isNotEmpty
        ? segments.last.relativeStartTimeUs + segments.last.durationUs ?? 0
        : 0;

    if (startOffsetUs != null && startOffsetUs < 0)
      startOffsetUs = durationUs + startOffsetUs;

    return HlsMediaPlaylist(
      playlistType: playlistType,
      startOffsetUs: startOffsetUs,
      startTimeUs: startTimeUs,
      hasDiscontinuitySequence: hasDiscontinuitySequence,
      discontinuitySequence: discontinuitySequence,
      mediaSequence: mediaSequence,
      version: version,
      targetDurationUs: targetDurationUs,
      hasEndTag: hasEndTag,
      hasProgramDateTime: hasProgramDateTime,
      protectionSchemes: protectionSchemes,
      segments: segments,
      durationUs: durationUs,
      baseUri: baseUri,
      tags: tags,
      hasIndependentSegments: hasIndependentSegments,
    );
  }

  static const int PLAYLIST_TYPE_UNKNOWN = 0;
  static const int PLAYLIST_TYPE_VOD = 1;
  static const int PLAYLIST_TYPE_EVENT = 2;

  final int playlistType;
  final int startOffsetUs;
  final int startTimeUs;
  final bool hasDiscontinuitySequence;
  final int discontinuitySequence;
  final int mediaSequence;
  final int version;
  final int targetDurationUs;
  final bool hasEndTag;
  final bool hasProgramDateTime;
  final DrmInitData protectionSchemes;
  final List<Segment> segments;
  final int durationUs;
}
