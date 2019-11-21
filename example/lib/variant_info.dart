class VariantInfo {

  VariantInfo({
    this.bitrate,
    this.videoGroupId,
    this.audioGroupId,
    this.subtitleGroupId,
    this.captionGroupId,
  });

  /// The bitrate as declared by the EXT-X-STREAM-INF tag. */
  final int bitrate;

  /// The VIDEO value as defined in the EXT-X-STREAM-INF tag, or null if the VIDEO attribute is not
  /// present.
  final String videoGroupId;

  /// The AUDIO value as defined in the EXT-X-STREAM-INF tag, or null if the AUDIO attribute is not
  /// present.
  final String audioGroupId;

  /// The SUBTITLES value as defined in the EXT-X-STREAM-INF tag, or null if the SUBTITLES
  /// attribute is not present.
  final String subtitleGroupId;

  /// The CLOSED-CAPTIONS value as defined in the EXT-X-STREAM-INF tag, or null if the
  /// CLOSED-CAPTIONS attribute is not present.
  final String captionGroupId;
}