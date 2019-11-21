import 'dart:convert';
import 'package:meta/meta.dart';
import 'dart:typed_data';

class SchemeData {
  SchemeData({
    @required this.uuid,
    this.licenseServerUrl,
    @required this.mimeType,
    this.data,
    this.requiresSecureDecryption,
  });

  final String uuid;
  final String licenseServerUrl;
  final String mimeType;
  final Uint8List data;
  final bool requiresSecureDecryption;
}
