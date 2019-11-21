import 'format.dart';
import 'drm_init_data.dart';
import 'variant.dart';
import 'rendition.dart';
import 'play_list.dart';

class HlsMasterPlaylist extends HlsPlaylist {
  HlsMasterPlaylist({
    String baseUri,
    List<String> tags,
    this.variants,
    this.videos,
    this.audios,
    this.subtitles,
    this.closedCaptions,
    this.muxedAudioFormat,
    this.muxedCaptionFormats,
    bool hasIndependentSegments,
    this.variableDefinitions,
    this.sessionKeyDrmInitData,
  })  : mediaPlaylistUrls = getMediaPlaylistUrls(
            variants, videos, audios, subtitles, closedCaptions),
        super(
            baseUri: baseUri,
            tags: tags,
            hasIndependentSegments: hasIndependentSegments);

  /// All of the media playlist URLs referenced by the playlist.
  final List<Uri> mediaPlaylistUrls;

  /// The variants declared by the playlist.
  final List<Variant> variants;

  /// The video renditions declared by the playlist.
  final List<Rendition> videos;

  /// The audio renditions declared by the playlist.
  final List<Rendition> audios;

  /// The subtitle renditions declared by the playlist.
  final List<Rendition> subtitles;

  /// The closed caption renditions declared by the playlist.
  final List<Rendition> closedCaptions;

  ///The format of the audio muxed in the variants. May be null if the playlist does not declare any mixed audio.
  final Format muxedAudioFormat;

  ///The format of the closed captions declared by the playlist. May be empty if the playlist
  ///explicitly declares no captions are available, or null if the playlist does not declare any
  ///captions information.
  final List<Format> muxedCaptionFormats;

  /// Contains variable definitions, as defined by the #EXT-X-DEFINE tag.
  final Map<String, String> variableDefinitions;

  /// DRM initialization data derived from #EXT-X-SESSION-KEY tags.
  final List<DrmInitData> sessionKeyDrmInitData;

  static List<Uri> getMediaPlaylistUrls(
      List<Variant> variants,
      List<Rendition> videos,
      List<Rendition> audios,
      List<Rendition> subtitles,
      List<Rendition> closedCaptions) {
    List<Uri> mediaPlaylistUrls = []; // ignore: always_specify_types
    for (var variant in variants) {
      if (!mediaPlaylistUrls.contains(variant.url)) {
        mediaPlaylistUrls.add(variant.url);
      }
    }
    addMediaPlaylistUrls(videos, mediaPlaylistUrls);
    addMediaPlaylistUrls(audios, mediaPlaylistUrls);
    addMediaPlaylistUrls(subtitles, mediaPlaylistUrls);
    addMediaPlaylistUrls(closedCaptions, mediaPlaylistUrls);
    return mediaPlaylistUrls;
  }

  static void addMediaPlaylistUrls(List<Rendition> renditions, List<Uri> out) {
    for (var rendition in renditions)
      if (rendition.url != null && !out.contains(rendition.url))
        out.add(rendition.url);
  }
}
