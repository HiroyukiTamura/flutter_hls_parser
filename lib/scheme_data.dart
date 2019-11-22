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

  SchemeData copyWithData(Uint8List data) => SchemeData(
      uuid: uuid,
      licenseServerUrl: licenseServerUrl,
      mimeType: mimeType,
      data: data,
      requiresSecureDecryption: requiresSecureDecryption,
    );
}
