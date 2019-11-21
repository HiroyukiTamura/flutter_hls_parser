import 'variant_info.dart';

class HlsTrackMetadataEntry {
  HlsTrackMetadataEntry(this.groupId, this.name, this.variantInfos);

  final String groupId;
  final String name;
  final List<VariantInfo> variantInfos;
}