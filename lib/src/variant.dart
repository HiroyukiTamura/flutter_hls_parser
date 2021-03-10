import 'format.dart';

class Variant {
  const Variant({
    required this.url,
    required this.format,
    required this.videoGroupId,
    required this.audioGroupId,
    required this.subtitleGroupId,
    required this.captionGroupId,
  });

  /// The variant's url.
  final Uri url;

  /// Format information associated with this variant.
  final Format format;

  /// The video rendition group referenced by this variant, or [Null].
  final String? videoGroupId;

  /// The audio rendition group referenced by this variant, or [Null].
  final String? audioGroupId;

  /// The subtitle rendition group referenced by this variant, or [Null].
  final String? subtitleGroupId;

  /// The caption rendition group referenced by this variant, or [Null].
  final String? captionGroupId;

  /// Returns a copy of this instance with the given [Format].
  Variant copyWithFormat(Format format) => Variant(
        url: url,
        format: format,
        videoGroupId: videoGroupId,
        audioGroupId: audioGroupId,
        subtitleGroupId: subtitleGroupId,
        captionGroupId: captionGroupId,
      );
}
