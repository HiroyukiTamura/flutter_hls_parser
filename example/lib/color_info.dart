import 'dart:typed_data';
import 'package:meta/meta.dart';

class ColorInfo {
  ColorInfo({
    @required this.colorSpace,
    @required this.colorRange,
    @required this.colorTransfer,
    this.hdrStaticInfo,
  });

  final int colorSpace;
  final int colorRange;
  final int colorTransfer;
  final Uint8List hdrStaticInfo;
}
