import 'package:meta/meta.dart';

abstract class HlsPlaylist {
  HlsPlaylist({
    @required this.baseUri,
    @required this.tags,
    @required this.hasIndependentSegments,
  });

  final String baseUri;
  final List<String> tags;
  final bool hasIndependentSegments;
}
