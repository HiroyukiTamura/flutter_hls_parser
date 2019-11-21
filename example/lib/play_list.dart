abstract class HlsPlaylist {
  HlsPlaylist({this.baseUri, this.tags, this.hasIndependentSegments});

  final String baseUri;
  final List<String> tags;
  final bool hasIndependentSegments;
}