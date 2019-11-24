import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'dart:typed_data';
import 'package:quiver/core.dart';

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

  SchemeData copyWithData(Uint8List data) =>
      SchemeData(
        uuid: uuid,
        licenseServerUrl: licenseServerUrl,
        mimeType: mimeType,
        data: data,
        requiresSecureDecryption: requiresSecureDecryption,
      );

  @override
  bool operator ==(dynamic other) {
    if (other is SchemeData) {
      return other.mimeType == mimeType &&
          other.licenseServerUrl == licenseServerUrl &&
          other.uuid == uuid &&
          other.requiresSecureDecryption == requiresSecureDecryption &&
          other.data == data;
    }

    return false;
  }

  @override
  int get hashCode => hashValues(uuid, licenseServerUrl, mimeType, data, requiresSecureDecryption);
}
