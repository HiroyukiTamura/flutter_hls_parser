import '../flutter_hls_parser.dart';
import 'drm_init_data.dart';
import 'variant.dart';
import 'rendition.dart';
import 'playlist.dart';
import 'extension.dart';

class HlsMasterPlaylist extends HlsPlaylist {
  HlsMasterPlaylist({
    String? baseUri,
    List<String> tags = const [],
    this.variants = const [],
    this.videos = const [],
    this.audios = const [],
    this.subtitles = const [],
    this.closedCaptions = const [],
    this.muxedAudioFormat,
    this.muxedCaptionFormats = const [],
    bool hasIndependentSegments = false,
    this.variableDefinitions = const {},
    this.sessionKeyDrmInitData = const [],
  })  : mediaPlaylistUrls = _getMediaPlaylistUrls(
            variants, [videos, audios, subtitles, closedCaptions]),
        super(
            baseUri: baseUri,
            tags: tags,
            hasIndependentSegments: hasIndependentSegments);

  /// All of the media playlist URLs referenced by the playlist.
  final List<Uri?> mediaPlaylistUrls;

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
  final Format? muxedAudioFormat;

  ///The format of the closed captions declared by the playlist. May be empty if the playlist
  ///explicitly declares no captions are available, or null if the playlist does not declare any
  ///captions information.
  final List<Format> muxedCaptionFormats;

  /// Contains variable definitions, as defined by the #EXT-X-DEFINE tag.
  final Map<String, String> variableDefinitions;

  /// DRM initialization data derived from #EXT-X-SESSION-KEY tags.
  final List<DrmInitData> sessionKeyDrmInitData;

  static List<Uri?> _getMediaPlaylistUrls(
          List<Variant> variants, List<List<Rendition>> renditionList) =>
      [
        ...variants.map((it) => it.url),
        ...renditionList.expand((it) => it).map((it) => it.url)
      ].distinct();
}
