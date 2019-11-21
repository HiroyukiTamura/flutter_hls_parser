import 'package:flutter_hls_parser_example/scheme_data.dart';
import 'package:meta/meta.dart';

class DrmInitData {
  DrmInitData({this.schemeType, this.schemeData});

  List<SchemeData> schemeData;
  String schemeType;
}