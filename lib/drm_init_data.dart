import 'scheme_data.dart';

class DrmInitData {
  DrmInitData({this.schemeType, this.schemeData = const []});

  List<SchemeData> schemeData;
  String schemeType;
}