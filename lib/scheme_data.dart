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

  /// The uuid of the DRM scheme, or null if the data is universal (i.e. applies to all schemes).
  final String uuid;

  /// The URL of the server to which license requests should be made. May be null if unknown.
  final String licenseServerUrl;

  /// The mimeType of [data].
  final String mimeType;

  /// The initialization data. May be null for scheme support checks only.
  final Uint8List data;

  /// Whether secure decryption is required.
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
