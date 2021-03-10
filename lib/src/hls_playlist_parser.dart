import 'package:collection/collection.dart' show IterableExtension;
import 'dart:async';
import 'dart:typed_data';
import 'drm_init_data.dart';
import 'exception.dart';
import 'dart:convert';
import 'util.dart';
import 'playlist.dart';
import 'mime_types.dart';
import 'scheme_data.dart';
import 'format.dart';
import 'variant.dart';
import 'variant_info.dart';
import 'hls_track_metadata_entry.dart';
import 'metadata.dart';
import 'rendition.dart';
import 'hls_master_playlist.dart';
import 'hls_media_playlist.dart';
import 'segment.dart';

class HlsPlaylistParser {
  HlsPlaylistParser(this.masterPlaylist);

  factory HlsPlaylistParser.create({HlsMasterPlaylist? masterPlaylist}) {
    masterPlaylist ??= HlsMasterPlaylist();
    return HlsPlaylistParser(masterPlaylist);
  }

  static const String PLAYLIST_HEADER = '#EXTM3U';
  static const String TAG_PREFIX = '#EXT';
  static const String TAG_VERSION = '#EXT-X-VERSION';
  static const String TAG_PLAYLIST_TYPE = '#EXT-X-PLAYLIST-TYPE';
  static const String TAG_DEFINE = '#EXT-X-DEFINE';
  static const String TAG_STREAM_INF = '#EXT-X-STREAM-INF';
  static const String TAG_MEDIA = '#EXT-X-MEDIA';
  static const String TAG_TARGET_DURATION = '#EXT-X-TARGETDURATION';
  static const String TAG_DISCONTINUITY = '#EXT-X-DISCONTINUITY';
  static const String TAG_DISCONTINUITY_SEQUENCE =
      '#EXT-X-DISCONTINUITY-SEQUENCE';
  static const String TAG_PROGRAM_DATE_TIME = '#EXT-X-PROGRAM-DATE-TIME';
  static const String TAG_INIT_SEGMENT = '#EXT-X-MAP';
  static const String TAG_INDEPENDENT_SEGMENTS = '#EXT-X-INDEPENDENT-SEGMENTS';
  static const String TAG_MEDIA_DURATION = '#EXTINF';
  static const String TAG_MEDIA_SEQUENCE = '#EXT-X-MEDIA-SEQUENCE';
  static const String TAG_START = '#EXT-X-START';
  static const String TAG_ENDLIST = '#EXT-X-ENDLIST';
  static const String TAG_KEY = '#EXT-X-KEY';
  static const String TAG_SESSION_KEY = '#EXT-X-SESSION-KEY';
  static const String TAG_BYTERANGE = '#EXT-X-BYTERANGE';
  static const String TAG_GAP = '#EXT-X-GAP';
  static const String TYPE_AUDIO = 'AUDIO';
  static const String TYPE_VIDEO = 'VIDEO';
  static const String TYPE_SUBTITLES = 'SUBTITLES';
  static const String TYPE_CLOSED_CAPTIONS = 'CLOSED-CAPTIONS';
  static const String METHOD_NONE = 'NONE';
  static const String METHOD_AES_128 = 'AES-128';
  static const String METHOD_SAMPLE_AES = 'SAMPLE-AES';
  static const String METHOD_SAMPLE_AES_CENC = 'SAMPLE-AES-CENC';
  static const String METHOD_SAMPLE_AES_CTR = 'SAMPLE-AES-CTR';
  static const String KEYFORMAT_PLAYREADY = 'com.microsoft.playready';
  static const String KEYFORMAT_IDENTITY = 'identity';
  static const String KEYFORMAT_WIDEVINE_PSSH_BINARY =
      'urn:uuid:edef8ba9-79d6-4ace-a3c8-27dcd51d21ed';
  static const String KEYFORMAT_WIDEVINE_PSSH_JSON = 'com.widevine';
  static const String BOOLEAN_TRUE = 'YES';
  static const String BOOLEAN_FALSE = 'NO';
  static const String ATTR_CLOSED_CAPTIONS_NONE = 'CLOSED-CAPTIONS=NONE';
  static const String REGEXP_AVERAGE_BANDWIDTH = r'AVERAGE-BANDWIDTH=(\d+)\b';
  static const String REGEXP_VIDEO = 'VIDEO="(.+?)"';
  static const String REGEXP_AUDIO = 'AUDIO="(.+?)"';
  static const String REGEXP_SUBTITLES = 'SUBTITLES="(.+?)"';
  static const String REGEXP_CLOSED_CAPTIONS = 'CLOSED-CAPTIONS="(.+?)"';
  static const String REGEXP_BANDWIDTH = r'[^-]BANDWIDTH=(\d+)\b';
  static const String REGEXP_CHANNELS = 'CHANNELS="(.+?)"';
  static const String REGEXP_CODECS = 'CODECS="(.+?)"';
  static const String REGEXP_RESOLUTION = r'RESOLUTION=(\d+x\d+)';
  static const String REGEXP_FRAME_RATE = r'FRAME-RATE=([\d\.]+)\b';
  static const String REGEXP_TARGET_DURATION = '$TAG_TARGET_DURATION:(\\d+)\\b';
  static const String REGEXP_VERSION = '$TAG_VERSION:(\\d+)\\b';
  static const String REGEXP_PLAYLIST_TYPE = '$TAG_PLAYLIST_TYPE:(.+)\\b';
  static const String REGEXP_MEDIA_SEQUENCE = '$TAG_MEDIA_SEQUENCE:(\\d+)\\b';
  static const String REGEXP_MEDIA_DURATION =
      '$TAG_MEDIA_DURATION:([\\d\\.]+)\\b';
  static const String REGEXP_MEDIA_TITLE =
      '$TAG_MEDIA_DURATION:[\\d\\.]+\\b,(.+)';
  static const String REGEXP_TIME_OFFSET = r'TIME-OFFSET=(-?[\d\.]+)\b';
  static const String REGEXP_BYTERANGE = '$TAG_BYTERANGE:(\\d+(?:@\\d+)?)\\b';
  static const String REGEXP_ATTR_BYTERANGE = r'BYTERANGE="(\d+(?:@\d+)?)\b"';
  static const String REGEXP_METHOD =
      'METHOD=($METHOD_NONE|$METHOD_AES_128|$METHOD_SAMPLE_AES|$METHOD_SAMPLE_AES_CENC|$METHOD_SAMPLE_AES_CTR)\\s*(?:,|\$)';
  static const String REGEXP_KEYFORMAT = 'KEYFORMAT="(.+?)"';
  static const String REGEXP_KEYFORMATVERSIONS = 'KEYFORMATVERSIONS="(.+?)"';
  static const String REGEXP_URI = 'URI="(.+?)"';
  static const String REGEXP_IV = 'IV=([^,.*]+)';
  static const String REGEXP_TYPE =
      'TYPE=($TYPE_AUDIO|$TYPE_VIDEO|$TYPE_SUBTITLES|$TYPE_CLOSED_CAPTIONS)';
  static const String REGEXP_LANGUAGE = 'LANGUAGE="(.+?)"';
  static const String REGEXP_NAME = 'NAME="(.+?)"';
  static const String REGEXP_GROUP_ID = 'GROUP-ID="(.+?)"';
  static const String REGEXP_CHARACTERISTICS = 'CHARACTERISTICS="(.+?)"';
  static const String REGEXP_INSTREAM_ID = r'INSTREAM-ID="((?:CC|SERVICE)\d+)"';
  static final String REGEXP_AUTOSELECT =
      _compileBooleanAttrPattern('AUTOSELECT');

  static final String REGEXP_DEFAULT = _compileBooleanAttrPattern('DEFAULT');

  static final String REGEXP_FORCED = _compileBooleanAttrPattern('FORCED');
  static const String REGEXP_VALUE = 'VALUE="(.+?)"';
  static const String REGEXP_IMPORT = 'IMPORT="(.+?)"';
  static const String REGEXP_VARIABLE_REFERENCE = r'\{\$([a-zA-Z0-9\-_]+)\}';

  final HlsMasterPlaylist masterPlaylist;

  Future<HlsPlaylist> parseString(Uri uri, String inputString) async {
    var lines = const LineSplitter().convert(inputString);
    return parse(uri, lines);
  }

  Future<HlsPlaylist> parse(Uri uri, List<String> inputLineList) async {
    var lineList =
        inputLineList.where((line) => line.trim().isNotEmpty).toList();

    if (!_checkPlaylistHeader(lineList[0]))
      throw UnrecognizedInputFormatException(
          'Input does not start with the #EXTM3U header.', uri);

    var extraLines = lineList.getRange(1, lineList.length).toList();

    bool? isMasterPlayList;
    for (final line in extraLines) {
      if (line.startsWith(TAG_STREAM_INF)) {
        isMasterPlayList = true;
        break;
      } else if (line.startsWith(TAG_TARGET_DURATION) ||
          line.startsWith(TAG_MEDIA_SEQUENCE) ||
          line.startsWith(TAG_MEDIA_DURATION) ||
          line.startsWith(TAG_KEY) ||
          line.startsWith(TAG_BYTERANGE) ||
          line == TAG_DISCONTINUITY ||
          line == TAG_DISCONTINUITY_SEQUENCE ||
          line == TAG_ENDLIST) {
        isMasterPlayList = false;
      }
    }
    if (isMasterPlayList == null)
      throw const FormatException("extraLines doesn't have valid tag");

    return isMasterPlayList
        ? _parseMasterPlaylist(extraLines.iterator, uri.toString())
        : _parseMediaPlaylist(masterPlaylist, extraLines, uri.toString());
  }

  static String _compileBooleanAttrPattern(String attribute) =>
      '$attribute=($BOOLEAN_FALSE|$BOOLEAN_TRUE)';

  static bool _checkPlaylistHeader(String string) {
    var codeUnits = LibUtil.excludeWhiteSpace(string).codeUnits;

    if (codeUnits[0] == 0xEF) {
      if (LibUtil.startsWith(codeUnits, [0xEF, 0xBB, 0xBF])) return false;
      codeUnits =
          codeUnits.getRange(5, codeUnits.length - 1).toList(); //不要な文字が含まれている
    }

    if (!LibUtil.startsWith(codeUnits, PLAYLIST_HEADER.runes.toList()))
      return false;

    return true;
  }

  HlsMasterPlaylist _parseMasterPlaylist(
      Iterator<String> extraLines, String baseUri) {
    var tags = <String>[];
    var mediaTags = <String>[];
    var sessionKeyDrmInitData = <DrmInitData>[];
    var variants = <Variant>[];
    var videos = <Rendition>[];
    var audios = <Rendition>[];
    var subtitles = <Rendition>[];
    var closedCaptions = <Rendition>[];
    var urlToVariantInfos = <Uri, List<VariantInfo>>{};
    Format? muxedAudioFormat;
    var noClosedCaptions = false;
    var hasIndependentSegmentsTag = false;
    var muxedCaptionFormats = <Format>[];
    var variableDefinitions = <String, String>{};

    while (extraLines.moveNext()) {
      var line = extraLines.current;

      if (line.startsWith(TAG_DEFINE)) {
        var key = _parseStringAttr(
          source: line,
          pattern: REGEXP_NAME,
          variableDefinitions: variableDefinitions,
        );
        var val = _parseStringAttr(
          source: line,
          pattern: REGEXP_VALUE,
          variableDefinitions: variableDefinitions,
        );
        if (key == null)
          throw ParserException("Couldn't match $REGEXP_NAME in $line");
        if (val == null)
          throw ParserException("Couldn't match $REGEXP_VALUE in $line");
        variableDefinitions[key] = val;
      } else if (line == TAG_INDEPENDENT_SEGMENTS) {
        hasIndependentSegmentsTag = true;
      } else if (line.startsWith(TAG_MEDIA)) {
        mediaTags.add(line);
      } else if (line.startsWith(TAG_SESSION_KEY)) {
        var keyFormat = _parseStringAttr(
          source: line,
          pattern: REGEXP_KEYFORMAT,
          defaultValue: KEYFORMAT_IDENTITY,
          variableDefinitions: variableDefinitions,
        );
        var schemeData = _parseDrmSchemeData(
          line: line,
          keyFormat: keyFormat,
          variableDefinitions: variableDefinitions,
        );

        if (schemeData != null) {
          var method = _parseStringAttr(
            source: line,
            pattern: REGEXP_METHOD,
            variableDefinitions: variableDefinitions,
          );
          if (method == null)
            throw ParserException(
                'failed to parse session key. key: $TAG_SESSION_KEY value: $line');
          var scheme = _parseEncryptionScheme(method);
          var drmInitData = DrmInitData(
            schemeType: scheme,
            schemeData: [schemeData],
          );
          sessionKeyDrmInitData.add(drmInitData);
        }
      } else if (line.startsWith(TAG_STREAM_INF)) {
        noClosedCaptions |= line.contains(ATTR_CLOSED_CAPTIONS_NONE); //todo 再検討
        var bitrate = int.parse(
            _parseStringAttr(source: line, pattern: REGEXP_BANDWIDTH)!);
        var averageBandwidthString = _parseStringAttr(
            source: line,
            pattern: REGEXP_AVERAGE_BANDWIDTH,
            variableDefinitions: variableDefinitions);
        if (averageBandwidthString != null)
          // If available, the average bandwidth attribute is used as the variant's bitrate.
          bitrate = int.parse(averageBandwidthString);
        var codecs = _parseStringAttr(
            source: line,
            pattern: REGEXP_CODECS,
            variableDefinitions: variableDefinitions);
        var resolutionString = _parseStringAttr(
            source: line,
            pattern: REGEXP_RESOLUTION,
            variableDefinitions: variableDefinitions);
        int? width;
        int? height;
        if (resolutionString != null) {
          var widthAndHeight = resolutionString.split('x');
          width = int.parse(widthAndHeight[0]);
          height = int.parse(widthAndHeight[1]);
          if (width <= 0 || height <= 0) {
            // Resolution string is invalid.
            width = null;
            height = null;
          }
        }

        double? frameRate;
        var frameRateString = _parseStringAttr(
          source: line,
          pattern: REGEXP_FRAME_RATE,
          variableDefinitions: variableDefinitions,
        );
        if (frameRateString != null) frameRate = double.parse(frameRateString);

        var videoGroupId = _parseStringAttr(
          source: line,
          pattern: REGEXP_VIDEO,
          variableDefinitions: variableDefinitions,
        );
        var audioGroupId = _parseStringAttr(
          source: line,
          pattern: REGEXP_AUDIO,
          variableDefinitions: variableDefinitions,
        );
        var subtitlesGroupId = _parseStringAttr(
          source: line,
          pattern: REGEXP_SUBTITLES,
          variableDefinitions: variableDefinitions,
        );
        var closedCaptionsGroupId = _parseStringAttr(
          source: line,
          pattern: REGEXP_CLOSED_CAPTIONS,
          variableDefinitions: variableDefinitions,
        );

        extraLines.moveNext();

        var referenceUri = _parseStringAttr(
          source: extraLines.current,
          variableDefinitions: variableDefinitions,
        );
        if (referenceUri == null)
          throw ParserException('failed to parse this line; $line');
        var uri = Uri.parse(baseUri).resolve(referenceUri);

        var format = Format.createVideoContainerFormat(
          id: variants.length.toString(),
          containerMimeType: MimeTypes.APPLICATION_M3U8,
          codecs: codecs,
          bitrate: bitrate,
          width: width,
          height: height,
          frameRate: frameRate,
        );

        variants.add(Variant(
          url: uri,
          format: format,
          videoGroupId: videoGroupId,
          audioGroupId: audioGroupId,
          subtitleGroupId: subtitlesGroupId,
          captionGroupId: closedCaptionsGroupId,
        ));

        var variantInfosForUrl = urlToVariantInfos[uri];
        if (variantInfosForUrl == null) {
          variantInfosForUrl = [];
          urlToVariantInfos[uri] = variantInfosForUrl;
        }

        variantInfosForUrl.add(VariantInfo(
          bitrate: bitrate,
          videoGroupId: videoGroupId,
          audioGroupId: audioGroupId,
          subtitleGroupId: subtitlesGroupId,
          captionGroupId: closedCaptionsGroupId,
        ));
      }
    }

    // TODO: Don't deduplicate variants by URL.
    var deduplicatedVariants = <Variant>[];
    var urlsInDeduplicatedVariants = <Uri>{};
    variants.forEach((variant) {
      if (urlsInDeduplicatedVariants.add(variant.url)) {
        assert(variant.format.metadata == null);
        var hlsMetadataEntry = HlsTrackMetadataEntry(
          variantInfos: urlToVariantInfos[variant.url],
        );
        var metadata = Metadata([hlsMetadataEntry]);
        deduplicatedVariants.add(
            variant.copyWithFormat(variant.format.copyWithMetadata(metadata)));
      }
    });

    mediaTags.forEach((line) {
      var groupId = _parseStringAttr(
        source: line,
        pattern: REGEXP_GROUP_ID,
        variableDefinitions: variableDefinitions,
      );
      var name = _parseStringAttr(
        source: line,
        pattern: REGEXP_NAME,
        variableDefinitions: variableDefinitions,
      );
      var referenceUri = _parseStringAttr(
        source: line,
        pattern: REGEXP_URI,
        variableDefinitions: variableDefinitions,
      );

      var uri = Uri.tryParse(baseUri);
      if (referenceUri != null) uri = uri?.resolve(referenceUri);

      var language = _parseStringAttr(
        source: line,
        pattern: REGEXP_LANGUAGE,
        variableDefinitions: variableDefinitions,
      );
      var selectionFlags = _parseSelectionFlags(line);
      var roleFlags = _parseRoleFlags(line, variableDefinitions);
      var formatId = '$groupId:$name';
      Format format;
      var entry = HlsTrackMetadataEntry(
        groupId: groupId,
        name: name,
      );
      var metadata = Metadata([entry]);

      switch (_parseStringAttr(
        source: line,
        pattern: REGEXP_TYPE,
        variableDefinitions: variableDefinitions,
      )) {
        case TYPE_VIDEO:
          {
            var variant =
                variants.firstWhereOrNull((it) => it.videoGroupId == groupId);
            String? codecs;
            int? width;
            int? height;
            double? frameRate;
            if (variant != null) {
              var variantFormat = variant.format;
              codecs = LibUtil.getCodecsOfType(
                  variantFormat.codecs, Util.TRACK_TYPE_VIDEO);
              width = variantFormat.width;
              height = variantFormat.height;
              frameRate = variantFormat.frameRate;
            }
            var sampleMimeType = MimeTypes.getMediaMimeType(codecs);

            format = Format.createVideoContainerFormat(
              id: formatId,
              label: name,
              containerMimeType: MimeTypes.APPLICATION_M3U8,
              sampleMimeType: sampleMimeType,
              codecs: codecs,
              width: width,
              height: height,
              frameRate: frameRate,
              selectionFlags: selectionFlags,
              roleFlags: roleFlags,
            ).copyWithMetadata(metadata);

            videos.add(Rendition(
              url: uri,
              format: format,
              groupId: groupId,
              name: name,
            ));
            break;
          }
        case TYPE_AUDIO:
          {
            var variant = _getVariantWithAudioGroup(variants, groupId);
            var codecs = variant != null
                ? LibUtil.getCodecsOfType(
                    variant.format.codecs, Util.TRACK_TYPE_AUDIO)
                : null;
            var channelCount =
                _parseChannelsAttribute(line, variableDefinitions);
            var sampleMimeType =
                codecs != null ? MimeTypes.getMediaMimeType(codecs) : null;
            var format = Format(
              id: formatId,
              label: name,
              containerMimeType: MimeTypes.APPLICATION_M3U8,
              sampleMimeType: sampleMimeType,
              codecs: codecs,
              channelCount: channelCount,
              selectionFlags: selectionFlags,
              roleFlags: roleFlags,
              language: language,
            );

            if (uri == null)
              muxedAudioFormat = format;
            else
              audios.add(Rendition(
                url: uri,
                format: format.copyWithMetadata(metadata),
                groupId: groupId,
                name: name,
              ));
            break;
          }
        case TYPE_SUBTITLES:
          {
            var format = Format(
                    id: formatId,
                    label: name,
                    containerMimeType: MimeTypes.APPLICATION_M3U8,
                    sampleMimeType: MimeTypes.TEXT_VTT,
                    selectionFlags: selectionFlags,
                    roleFlags: roleFlags,
                    language: language)
                .copyWithMetadata(metadata);
            subtitles.add(Rendition(
              url: uri,
              format: format,
              groupId: groupId,
              name: name,
            ));
            break;
          }
        case TYPE_CLOSED_CAPTIONS:
          {
            var instreamId = _parseStringAttr(
              source: line,
              pattern: REGEXP_INSTREAM_ID,
              variableDefinitions: variableDefinitions,
            );
            if (instreamId == null)
              throw ParserException(
                  'failed to parse session key. key: $TYPE_CLOSED_CAPTIONS value: $line');
            String mimeType;
            int accessibilityChannel;
            if (instreamId.startsWith('CC')) {
              mimeType = MimeTypes.APPLICATION_CEA608;
              accessibilityChannel = int.parse(instreamId.substring(2));
            } else
            /* starts with SERVICE */ {
              mimeType = MimeTypes.APPLICATION_CEA708;
              accessibilityChannel = int.parse(instreamId.substring(7));
            }
            muxedCaptionFormats.add(Format(
              id: formatId,
              label: name,
              sampleMimeType: mimeType,
              selectionFlags: selectionFlags,
              roleFlags: roleFlags,
              language: language,
              accessibilityChannel: accessibilityChannel,
            ));
            break;
          }
        default:
          break;
      }
    });

    if (noClosedCaptions) muxedCaptionFormats = [];

    return HlsMasterPlaylist(
      baseUri: baseUri,
      tags: tags,
      variants: deduplicatedVariants,
      videos: videos,
      audios: audios,
      subtitles: subtitles,
      closedCaptions: closedCaptions,
      muxedAudioFormat: muxedAudioFormat,
      muxedCaptionFormats: muxedCaptionFormats,
      hasIndependentSegments: hasIndependentSegmentsTag,
      variableDefinitions: variableDefinitions,
      sessionKeyDrmInitData: sessionKeyDrmInitData,
    );
  }

  static String? _parseStringAttr({
    required String source,
    String? pattern,
    String? defaultValue,
    Map<String, String?>? variableDefinitions,
  }) {
    var value = pattern == null
        ? source
        : (RegExp(pattern).firstMatch(source)?.group(1) ?? defaultValue);

    if (value == null) return null;

    return value.replaceAllMapped(RegExp(REGEXP_VARIABLE_REFERENCE), (match) {
      final matched = match.group(1);
      return matched == null
          ? value.substring(match.start, match.end)
          : (variableDefinitions ?? {})[matched] ??=
              value.substring(match.start, match.end);
    });
  }

  static SchemeData? _parseDrmSchemeData({
    required String line,
    String? keyFormat,
    Map<String, String?>? variableDefinitions,
  }) {
    var keyFormatVersions = _parseStringAttr(
      source: line,
      pattern: REGEXP_KEYFORMATVERSIONS,
      defaultValue: '1',
      variableDefinitions: variableDefinitions,
    );

    if (KEYFORMAT_WIDEVINE_PSSH_BINARY == keyFormat) {
      var uriString = _parseStringAttr(
        source: line,
        pattern: REGEXP_URI,
        variableDefinitions: variableDefinitions,
      );
      if (uriString == null)
        throw ParserException('failed to parse this line: $line');
      var data = _getBase64FromUri(uriString);
      return SchemeData(
//          uuid: '', //todo 保留
        mimeType: MimeTypes.VIDEO_MP4,
        data: data,
      );
    } else if (KEYFORMAT_WIDEVINE_PSSH_JSON == keyFormat) {
      return SchemeData(
//          uuid: '', //todo 保留
        mimeType: MimeTypes.HLS,
        data: const Utf8Encoder().convert(line),
      );
    } else if (KEYFORMAT_PLAYREADY == keyFormat && '1' == keyFormatVersions) {
      var uriString = _parseStringAttr(
        source: line,
        pattern: REGEXP_URI,
        variableDefinitions: variableDefinitions,
      );
      var data = _getBase64FromUri(uriString);
//      Uint8List psshData; //todo 保留
      return SchemeData(
        mimeType: MimeTypes.VIDEO_MP4,
        data: data,
      );
    }

    return null;
  }

  static int _parseSelectionFlags(String line) {
    var flags = 0;
    if (parseOptionalBooleanAttribute(
      line: line,
      pattern: REGEXP_DEFAULT,
      defaultValue: false,
    )) flags |= Util.SELECTION_FLAG_DEFAULT;
    if (parseOptionalBooleanAttribute(
      line: line,
      pattern: REGEXP_FORCED,
      defaultValue: false,
    )) flags |= Util.SELECTION_FLAG_FORCED;
    if (parseOptionalBooleanAttribute(
      line: line,
      pattern: REGEXP_AUTOSELECT,
      defaultValue: false,
    )) flags |= Util.SELECTION_FLAG_AUTOSELECT;
    return flags;
  }

  static bool parseOptionalBooleanAttribute({
    required String line,
    required String pattern,
    required bool defaultValue,
  }) {
    var list = line.allMatches(pattern);
    return list.isEmpty ? defaultValue : list.first.pattern == BOOLEAN_TRUE;
  }

  static int _parseRoleFlags(
    String line,
    Map<String, String> variableDefinitions,
  ) {
    var concatenatedCharacteristics = _parseStringAttr(
      source: line,
      pattern: REGEXP_CHARACTERISTICS,
      variableDefinitions: variableDefinitions,
    );
    if (concatenatedCharacteristics?.isNotEmpty != true) return 0;
    var characteristics = concatenatedCharacteristics!.split(',');
    var roleFlags = 0;
    if (characteristics.contains('public.accessibility.describes-video'))
      roleFlags |= Util.ROLE_FLAG_DESCRIBES_VIDEO;

    if (characteristics
        .contains('public.accessibility.transcribes-spoken-dialog'))
      roleFlags |= Util.ROLE_FLAG_TRANSCRIBES_DIALOG;

    if (characteristics
        .contains('public.accessibility.describes-music-and-sound'))
      roleFlags |= Util.ROLE_FLAG_DESCRIBES_MUSIC_AND_SOUND;

    if (characteristics.contains('public.easy-to-read'))
      roleFlags |= Util.ROLE_FLAG_EASY_TO_READ;

    return roleFlags;
  }

  static int? _parseChannelsAttribute(
    String line,
    Map<String, String> variableDefinitions,
  ) {
    var channelsString = _parseStringAttr(
      source: line,
      pattern: REGEXP_CHANNELS,
      variableDefinitions: variableDefinitions,
    );
    return channelsString != null
        ? int.parse(channelsString.split('/')[0])
        : null;
  }

  static Variant? _getVariantWithAudioGroup(
    List<Variant> variants,
    String? groupId,
  ) =>
      variants.firstWhereOrNull((it) => it.audioGroupId == groupId);

  static String _parseEncryptionScheme(String method) =>
      METHOD_SAMPLE_AES_CENC == method || METHOD_SAMPLE_AES_CTR == method
          ? CencType.CENC
          : CencType.CBCS;

  static Uint8List? _getBase64FromUri(String? uriString) {
    if (uriString == null) return null;
    var uriPre = uriString.substring(uriString.indexOf(',') + 1);
    return const Base64Decoder().convert(uriPre);
  }

  static HlsMediaPlaylist _parseMediaPlaylist(
    HlsMasterPlaylist masterPlaylist,
    List<String> extraLines,
    String baseUri,
  ) {
    var playlistType = HlsMediaPlaylist.PLAYLIST_TYPE_UNKNOWN;
    int? startOffsetUs;
    int? mediaSequence;
    int? version;
    int? targetDurationUs;
    var hasIndependentSegmentsTag = masterPlaylist.hasIndependentSegments;
    var hasEndTag = false;
    int? segmentByteRangeOffset;
    Segment? initializationSegment;
    var variableDefinitions = <String, String?>{};
    var segments = <Segment>[];
    var tags = <String>[];
    int? segmentByteRangeLength;
    var segmentMediaSequence = 0;
    int? segmentDurationUs;
    String? segmentTitle;
    var currentSchemeDatas = <String, SchemeData>{};
    DrmInitData? cachedDrmInitData;
    String? encryptionScheme;
    DrmInitData? playlistProtectionSchemes;
    var hasDiscontinuitySequence = false;
    var playlistDiscontinuitySequence = 0;
    int? relativeDiscontinuitySequence;
    int? playlistStartTimeUs;
    int? segmentStartTimeUs;
    var hasGapTag = false;

    String? fullSegmentEncryptionKeyUri;
    String? fullSegmentEncryptionIV;

    for (var line in extraLines) {
      if (line.startsWith(TAG_PREFIX)) {
        // We expose all tags through the playlist.
        tags.add(line);
      }

      if (line.startsWith(TAG_PLAYLIST_TYPE)) {
        var playlistTypeString = _parseStringAttr(
          source: line,
          pattern: REGEXP_PLAYLIST_TYPE,
          variableDefinitions: variableDefinitions,
        );
        switch (playlistTypeString) {
          case 'VOD':
            playlistType = HlsMediaPlaylist.PLAYLIST_TYPE_VOD;
            break;
          case 'EVENT':
            playlistType = HlsMediaPlaylist.PLAYLIST_TYPE_EVENT;
            break;
        }
      } else if (line.startsWith(TAG_START)) {
        var string = _parseStringAttr(
          source: line,
          pattern: REGEXP_TIME_OFFSET,
        );
        if (string == null)
          throw ParserException(
              'failed to parse session key. key: $TAG_START value: $line');
        startOffsetUs = (double.parse(string) * 1000000).toInt();
      } else if (line.startsWith(TAG_INIT_SEGMENT)) {
        var uri = _parseStringAttr(
          source: line,
          pattern: REGEXP_URI,
          variableDefinitions: variableDefinitions,
        );
        var byteRange = _parseStringAttr(
          source: line,
          pattern: REGEXP_ATTR_BYTERANGE,
          variableDefinitions: variableDefinitions,
        );
        if (byteRange != null) {
          var splitByteRange = byteRange.split('@');
          segmentByteRangeLength = int.parse(splitByteRange[0]);
          if (splitByteRange.length > 1)
            segmentByteRangeOffset = int.parse(splitByteRange[1]);
        }

        if (fullSegmentEncryptionKeyUri != null &&
            fullSegmentEncryptionIV == null)
          // See RFC 8216, Section 4.3.2.5.
          throw ParserException(
              'The encryption IV attribute must be present when an initialization segment is encrypted with METHOD=AES-128.');

        initializationSegment = Segment(
          url: uri,
          byterangeOffset: segmentByteRangeOffset,
          byterangeLength: segmentByteRangeLength,
          fullSegmentEncryptionKeyUri: fullSegmentEncryptionKeyUri,
          encryptionIV: fullSegmentEncryptionIV,
        );
        segmentByteRangeOffset = null;
        segmentByteRangeLength = null;
      } else if (line.startsWith(TAG_TARGET_DURATION)) {
        final string = _parseStringAttr(
          source: line,
          pattern: REGEXP_TARGET_DURATION,
        );
        if (string == null)
          throw ParserException(
              'failed to parse session key. key: $TAG_TARGET_DURATION value: $line');
        targetDurationUs = int.parse(string) * 100000;
      } else if (line.startsWith(TAG_MEDIA_SEQUENCE)) {
        final string = _parseStringAttr(
          source: line,
          pattern: REGEXP_MEDIA_SEQUENCE,
        );
        if (string == null)
          throw ParserException(
              'failed to parse session key. key: $TAG_MEDIA_SEQUENCE value: $line');
        mediaSequence = int.parse(string);
        segmentMediaSequence = mediaSequence;
      } else if (line.startsWith(TAG_VERSION)) {
        final string = _parseStringAttr(
          source: line,
          pattern: REGEXP_VERSION,
        );
        if (string == null)
          throw ParserException(
              'failed to parse session key. key: $TAG_VERSION value: $line');
        version = int.parse(string);
      } else if (line.startsWith(TAG_DEFINE)) {
        var importName = _parseStringAttr(
          source: line,
          pattern: REGEXP_IMPORT,
          variableDefinitions: variableDefinitions,
        );
        if (importName != null) {
          var value = masterPlaylist.variableDefinitions[importName];
          if (value != null) {
            variableDefinitions[importName] = value;
          } else {
            // The master playlist does not declare the imported variable. Ignore.
          }
        } else {
          var key = _parseStringAttr(
            source: line,
            pattern: REGEXP_NAME,
            variableDefinitions: variableDefinitions,
          );
          if (key != null) {
            variableDefinitions[key] = _parseStringAttr(
              source: line,
              pattern: REGEXP_VALUE,
              variableDefinitions: variableDefinitions,
            );
          }
        }
      } else if (line.startsWith(TAG_MEDIA_DURATION)) {
        var string = _parseStringAttr(
          source: line,
          pattern: REGEXP_MEDIA_DURATION,
        );
        if (string == null)
          throw ParserException(
              'failed to parse session key. key: $TAG_MEDIA_DURATION value: $line');
        segmentDurationUs = (double.parse(string) * 1000000).toInt();
        segmentTitle = _parseStringAttr(
          source: line,
          pattern: REGEXP_MEDIA_TITLE,
          defaultValue: '',
          variableDefinitions: variableDefinitions,
        );
      } else if (line.startsWith(TAG_KEY)) {
        var method = _parseStringAttr(
          source: line,
          pattern: REGEXP_METHOD,
          variableDefinitions: variableDefinitions,
        );
        var keyFormat = _parseStringAttr(
          source: line,
          pattern: REGEXP_KEYFORMAT,
          defaultValue: KEYFORMAT_IDENTITY,
          variableDefinitions: variableDefinitions,
        );
        fullSegmentEncryptionKeyUri = null;
        fullSegmentEncryptionIV = null;
        if (METHOD_NONE == method) {
          currentSchemeDatas.clear();
          cachedDrmInitData = null;
        } else
        /* !METHOD_NONE.equals(method) */ {
          fullSegmentEncryptionIV = _parseStringAttr(
            source: line,
            pattern: REGEXP_IV,
            variableDefinitions: variableDefinitions,
          );
          if (KEYFORMAT_IDENTITY == keyFormat) {
            if (METHOD_AES_128 == method) {
              // The segment is fully encrypted using an identity key.
              fullSegmentEncryptionKeyUri = _parseStringAttr(
                source: line,
                pattern: REGEXP_URI,
                variableDefinitions: variableDefinitions,
              );
            } else {
              // Do nothing. Samples are encrypted using an identity key, but this is not supported.
              // Hopefully, a traditional DRM alternative is also provided.
            }
          } else {
            encryptionScheme ??= _parseEncryptionScheme(method!);
            var schemeData = _parseDrmSchemeData(
              line: line,
              keyFormat: keyFormat,
              variableDefinitions: variableDefinitions,
            );
            if (schemeData != null) {
              cachedDrmInitData = null;
              currentSchemeDatas[keyFormat!] = schemeData;
            }
          }
        }
      } else if (line.startsWith(TAG_BYTERANGE)) {
        var byteRange = _parseStringAttr(
          source: line,
          pattern: REGEXP_BYTERANGE,
          variableDefinitions: variableDefinitions,
        );
        if (byteRange == null)
          throw ParserException(
              'failed to parse session key. key: $TAG_BYTERANGE value: $line');
        var splitByteRange = byteRange.split('@');
        segmentByteRangeLength = int.parse(splitByteRange[0]);
        if (splitByteRange.length > 1)
          segmentByteRangeOffset = int.parse(splitByteRange[1]);
      } else if (line.startsWith(TAG_DISCONTINUITY_SEQUENCE)) {
        hasDiscontinuitySequence = true;
        playlistDiscontinuitySequence =
            int.parse(line.substring(line.indexOf(':') + 1));
      } else if (line == TAG_DISCONTINUITY) {
        relativeDiscontinuitySequence ??= 0;
        relativeDiscontinuitySequence++;
      } else if (line.startsWith(TAG_PROGRAM_DATE_TIME)) {
        if (playlistStartTimeUs == null) {
          var programDatetimeUs =
              LibUtil.parseXsDateTime(line.substring(line.indexOf(':') + 1));
          playlistStartTimeUs = programDatetimeUs - (segmentStartTimeUs ?? 0);
        }
      } else if (line == TAG_GAP) {
        hasGapTag = true;
      } else if (line == TAG_INDEPENDENT_SEGMENTS) {
        hasIndependentSegmentsTag = true;
      } else if (line == TAG_ENDLIST) {
        hasEndTag = true;
      } else if (!line.startsWith('#')) {
        String? segmentEncryptionIV;
        if (fullSegmentEncryptionKeyUri == null)
          segmentEncryptionIV = null;
        else if (fullSegmentEncryptionIV != null)
          segmentEncryptionIV = fullSegmentEncryptionIV;
        else
          segmentEncryptionIV = segmentMediaSequence.toRadixString(16);

        segmentMediaSequence++;
        if (segmentByteRangeLength == null) segmentByteRangeOffset = null;

        if (cachedDrmInitData?.schemeData.isNotEmpty != true &&
            currentSchemeDatas.isNotEmpty) {
          var schemeDatas = currentSchemeDatas.values.toList();
          cachedDrmInitData = DrmInitData(
            schemeType: encryptionScheme,
            schemeData: schemeDatas,
          );
          playlistProtectionSchemes ??= DrmInitData(
            schemeType: encryptionScheme,
            schemeData: schemeDatas.map((it) => it.copyWithData(null)).toList(),
          );
        }

        var url = _parseStringAttr(
          source: line,
          variableDefinitions: variableDefinitions,
        );
        segments.add(Segment(
          url: url,
          initializationSegment: initializationSegment,
          title: segmentTitle,
          durationUs: segmentDurationUs,
          relativeDiscontinuitySequence: relativeDiscontinuitySequence,
          relativeStartTimeUs: segmentStartTimeUs,
          drmInitData: cachedDrmInitData,
          fullSegmentEncryptionKeyUri: fullSegmentEncryptionKeyUri,
          encryptionIV: segmentEncryptionIV,
          byterangeOffset: segmentByteRangeOffset,
          byterangeLength: segmentByteRangeLength,
          hasGapTag: hasGapTag,
        ));

        if (segmentDurationUs != null) {
          segmentStartTimeUs ??= 0;
          segmentStartTimeUs += segmentDurationUs;
        }
        segmentDurationUs = null;
        segmentTitle = null;
        if (segmentByteRangeLength != null) {
          segmentByteRangeOffset ??= 0;
          segmentByteRangeOffset += segmentByteRangeLength;
        }

        segmentByteRangeLength = null;
        hasGapTag = false;
      }
    }

    return HlsMediaPlaylist.create(
      playlistType: playlistType,
      baseUri: baseUri,
      tags: tags,
      startOffsetUs: startOffsetUs,
      startTimeUs: playlistStartTimeUs,
      hasDiscontinuitySequence: hasDiscontinuitySequence,
      discontinuitySequence: playlistDiscontinuitySequence,
      mediaSequence: mediaSequence,
      version: version,
      targetDurationUs: targetDurationUs,
      hasIndependentSegments: hasIndependentSegmentsTag,
      hasEndTag: hasEndTag,
      hasProgramDateTime: playlistStartTimeUs != null,
      protectionSchemes: playlistProtectionSchemes,
      segments: segments,
    );
  }
}
