import 'package:flutter/rendering.dart';

import 'variant_info.dart';
import 'package:collection/collection.dart';

class HlsTrackMetadataEntry {
  HlsTrackMetadataEntry({this.groupId, this.name, this.variantInfos});

  final String groupId;
  final String name;
  final List<VariantInfo> variantInfos;

  @override
  bool operator ==(dynamic other) {
    if (other is HlsTrackMetadataEntry)
      return other.groupId == groupId && other.name == name && const ListEquality<VariantInfo>().equals(other.variantInfos, variantInfos);
    return false;
  }

  @override
  int get hashCode => hashValues(groupId, name, variantInfos);
}