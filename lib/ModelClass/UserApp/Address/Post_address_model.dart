import 'package:sentinix_ecommerce/Bloc/Response/errorResponse.dart';

/// success : true
/// data : {"status":true,"message":"User address created successfully","newAddress":{"isDeleted":false,"createdAt":"2025-07-03T09:54:14.355Z","modifiedAt":"2025-07-03T09:54:14.355Z","id":3,"userId":16,"latitude":12984.2,"longtitude":34986.4,"maplocation":"Tirunelveli","flatAddress":"8/22","floorNumber":"6/45","apartmentName":"Rainbow colony","streetName":"Main Road","areaName":"pcm","pinCode":627806,"addressType":"Home"}}

class PostAddressModel {
  PostAddressModel({
    bool? success,
    Data? data,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _data = data;
  }

  PostAddressModel.fromJson(dynamic json) {
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
  PostAddressModel copyWith({
    bool? success,
    Data? data,
  }) =>
      PostAddressModel(
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
/// message : "User address created successfully"
/// newAddress : {"isDeleted":false,"createdAt":"2025-07-03T09:54:14.355Z","modifiedAt":"2025-07-03T09:54:14.355Z","id":3,"userId":16,"latitude":12984.2,"longtitude":34986.4,"maplocation":"Tirunelveli","flatAddress":"8/22","floorNumber":"6/45","apartmentName":"Rainbow colony","streetName":"Main Road","areaName":"pcm","pinCode":627806,"addressType":"Home"}

class Data {
  Data({
    bool? status,
    String? message,
    NewAddress? newAddress,
  }) {
    _status = status;
    _message = message;
    _newAddress = newAddress;
  }

  Data.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _newAddress = json['newAddress'] != null
        ? NewAddress.fromJson(json['newAddress'])
        : null;
  }
  bool? _status;
  String? _message;
  NewAddress? _newAddress;
  Data copyWith({
    bool? status,
    String? message,
    NewAddress? newAddress,
  }) =>
      Data(
        status: status ?? _status,
        message: message ?? _message,
        newAddress: newAddress ?? _newAddress,
      );
  bool? get status => _status;
  String? get message => _message;
  NewAddress? get newAddress => _newAddress;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_newAddress != null) {
      map['newAddress'] = _newAddress?.toJson();
    }
    return map;
  }
}

/// isDeleted : false
/// createdAt : "2025-07-03T09:54:14.355Z"
/// modifiedAt : "2025-07-03T09:54:14.355Z"
/// id : 3
/// userId : 16
/// latitude : 12984.2
/// longtitude : 34986.4
/// maplocation : "Tirunelveli"
/// flatAddress : "8/22"
/// floorNumber : "6/45"
/// apartmentName : "Rainbow colony"
/// streetName : "Main Road"
/// areaName : "pcm"
/// pinCode : 627806
/// addressType : "Home"

class NewAddress {
  NewAddress({
    bool? isDeleted,
    String? createdAt,
    String? modifiedAt,
    num? id,
    num? userId,
    num? latitude,
    num? longtitude,
    String? maplocation,
    String? flatAddress,
    String? floorNumber,
    String? apartmentName,
    String? streetName,
    String? areaName,
    num? pinCode,
    String? addressType,
  }) {
    _isDeleted = isDeleted;
    _createdAt = createdAt;
    _modifiedAt = modifiedAt;
    _id = id;
    _userId = userId;
    _latitude = latitude;
    _longtitude = longtitude;
    _maplocation = maplocation;
    _flatAddress = flatAddress;
    _floorNumber = floorNumber;
    _apartmentName = apartmentName;
    _streetName = streetName;
    _areaName = areaName;
    _pinCode = pinCode;
    _addressType = addressType;
  }

  NewAddress.fromJson(dynamic json) {
    _isDeleted = json['isDeleted'];
    _createdAt = json['createdAt'];
    _modifiedAt = json['modifiedAt'];
    _id = json['id'];
    _userId = json['userId'];
    _latitude = json['latitude'];
    _longtitude = json['longtitude'];
    _maplocation = json['maplocation'];
    _flatAddress = json['flatAddress'];
    _floorNumber = json['floorNumber'];
    _apartmentName = json['apartmentName'];
    _streetName = json['streetName'];
    _areaName = json['areaName'];
    _pinCode = json['pinCode'];
    _addressType = json['addressType'];
  }
  bool? _isDeleted;
  String? _createdAt;
  String? _modifiedAt;
  num? _id;
  num? _userId;
  num? _latitude;
  num? _longtitude;
  String? _maplocation;
  String? _flatAddress;
  String? _floorNumber;
  String? _apartmentName;
  String? _streetName;
  String? _areaName;
  num? _pinCode;
  String? _addressType;
  NewAddress copyWith({
    bool? isDeleted,
    String? createdAt,
    String? modifiedAt,
    num? id,
    num? userId,
    num? latitude,
    num? longtitude,
    String? maplocation,
    String? flatAddress,
    String? floorNumber,
    String? apartmentName,
    String? streetName,
    String? areaName,
    num? pinCode,
    String? addressType,
  }) =>
      NewAddress(
        isDeleted: isDeleted ?? _isDeleted,
        createdAt: createdAt ?? _createdAt,
        modifiedAt: modifiedAt ?? _modifiedAt,
        id: id ?? _id,
        userId: userId ?? _userId,
        latitude: latitude ?? _latitude,
        longtitude: longtitude ?? _longtitude,
        maplocation: maplocation ?? _maplocation,
        flatAddress: flatAddress ?? _flatAddress,
        floorNumber: floorNumber ?? _floorNumber,
        apartmentName: apartmentName ?? _apartmentName,
        streetName: streetName ?? _streetName,
        areaName: areaName ?? _areaName,
        pinCode: pinCode ?? _pinCode,
        addressType: addressType ?? _addressType,
      );
  bool? get isDeleted => _isDeleted;
  String? get createdAt => _createdAt;
  String? get modifiedAt => _modifiedAt;
  num? get id => _id;
  num? get userId => _userId;
  num? get latitude => _latitude;
  num? get longtitude => _longtitude;
  String? get maplocation => _maplocation;
  String? get flatAddress => _flatAddress;
  String? get floorNumber => _floorNumber;
  String? get apartmentName => _apartmentName;
  String? get streetName => _streetName;
  String? get areaName => _areaName;
  num? get pinCode => _pinCode;
  String? get addressType => _addressType;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isDeleted'] = _isDeleted;
    map['createdAt'] = _createdAt;
    map['modifiedAt'] = _modifiedAt;
    map['id'] = _id;
    map['userId'] = _userId;
    map['latitude'] = _latitude;
    map['longtitude'] = _longtitude;
    map['maplocation'] = _maplocation;
    map['flatAddress'] = _flatAddress;
    map['floorNumber'] = _floorNumber;
    map['apartmentName'] = _apartmentName;
    map['streetName'] = _streetName;
    map['areaName'] = _areaName;
    map['pinCode'] = _pinCode;
    map['addressType'] = _addressType;
    return map;
  }
}
