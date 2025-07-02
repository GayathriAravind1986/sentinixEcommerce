import 'package:sentinix_ecommerce/Bloc/Response/errorResponse.dart';

/// success : true
/// data : {"status":true,"message":"OTP generated and Send Successfully & otp is :943466","otp":"943466"}

class PostLoginModel {
  PostLoginModel({
    bool? success,
    Data? data,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _data = data;
  }

  PostLoginModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    if (json['errors'] != null && json['errors'] is Map<String, dynamic>) {
      errorResponse = ErrorResponse.fromJson(json['errors']);
    } else {
      errorResponse = null;
    }
  }
  bool? _success;
  Data? _data;
  ErrorResponse? errorResponse;
  PostLoginModel copyWith({
    bool? success,
    Data? data,
  }) =>
      PostLoginModel(
        success: success ?? _success,
        data: data ?? _data,
      );
  bool? get success => _success;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    if (errorResponse != null) {
      map['errors'] = errorResponse!.toJson();
    }
    return map;
  }
}

/// status : true
/// message : "OTP generated and Send Successfully & otp is :943466"
/// otp : "943466"

class Data {
  Data({
    bool? status,
    String? message,
    String? otp,
  }) {
    _status = status;
    _message = message;
    _otp = otp;
  }

  Data.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _otp = json['otp'];
  }
  bool? _status;
  String? _message;
  String? _otp;
  Data copyWith({
    bool? status,
    String? message,
    String? otp,
  }) =>
      Data(
        status: status ?? _status,
        message: message ?? _message,
        otp: otp ?? _otp,
      );
  bool? get status => _status;
  String? get message => _message;
  String? get otp => _otp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['otp'] = _otp;
    return map;
  }
}
