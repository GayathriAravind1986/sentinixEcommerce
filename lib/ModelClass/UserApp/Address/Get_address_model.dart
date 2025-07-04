import 'package:sentinix_ecommerce/Bloc/Response/errorResponse.dart';

/// success : true
/// data : {"status":true,"message":"Address fetched successfully","address":[{"id":3,"userId":16,"latitude":12984.2,"longtitude":34986.4,"maplocation":"Tirunelveli","flatAddress":"8/22","floorNumber":"6/45","apartmentName":"Rainbow colony","streetName":"Main Road","areaName":"pcm","pinCode":627806,"addressType":"Home","isDeleted":false,"createdAt":"2025-07-03T09:54:14.355Z","modifiedAt":"2025-07-03T09:54:14.355Z"},{"id":4,"userId":16,"latitude":12984.2,"longtitude":34986.4,"maplocation":"Tirunelveli","flatAddress":"8/22","floorNumber":"6/45","apartmentName":"Rainbow colony","streetName":"Main Road","areaName":"pcm","pinCode":627806,"addressType":"Home","isDeleted":false,"createdAt":"2025-07-04T05:44:18.480Z","modifiedAt":"2025-07-04T05:44:18.480Z"},{"id":6,"userId":16,"latitude":8.717887231337398,"longtitude":77.75955341756344,"maplocation":"PQ95+6QQ, Kamaraj Nagar, Tirunelveli","flatAddress":"234","floorNumber":"22","apartmentName":"","streetName":"","areaName":"Kamaraj Nagar","pinCode":627002,"addressType":"HOME","isDeleted":false,"createdAt":"2025-07-04T12:16:05.914Z","modifiedAt":"2025-07-04T12:16:05.914Z"}]}

class GetAddressModel {
  GetAddressModel({
    bool? success,
    Data? data,
    ErrorResponse? errorResponse,
  }) {
    _success = success;
    _data = data;
  }

  GetAddressModel.fromJson(dynamic json) {
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
  GetAddressModel copyWith({
    bool? success,
    Data? data,
  }) =>
      GetAddressModel(
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
/// message : "Address fetched successfully"
/// address : [{"id":3,"userId":16,"latitude":12984.2,"longtitude":34986.4,"maplocation":"Tirunelveli","flatAddress":"8/22","floorNumber":"6/45","apartmentName":"Rainbow colony","streetName":"Main Road","areaName":"pcm","pinCode":627806,"addressType":"Home","isDeleted":false,"createdAt":"2025-07-03T09:54:14.355Z","modifiedAt":"2025-07-03T09:54:14.355Z"},{"id":4,"userId":16,"latitude":12984.2,"longtitude":34986.4,"maplocation":"Tirunelveli","flatAddress":"8/22","floorNumber":"6/45","apartmentName":"Rainbow colony","streetName":"Main Road","areaName":"pcm","pinCode":627806,"addressType":"Home","isDeleted":false,"createdAt":"2025-07-04T05:44:18.480Z","modifiedAt":"2025-07-04T05:44:18.480Z"},{"id":6,"userId":16,"latitude":8.717887231337398,"longtitude":77.75955341756344,"maplocation":"PQ95+6QQ, Kamaraj Nagar, Tirunelveli","flatAddress":"234","floorNumber":"22","apartmentName":"","streetName":"","areaName":"Kamaraj Nagar","pinCode":627002,"addressType":"HOME","isDeleted":false,"createdAt":"2025-07-04T12:16:05.914Z","modifiedAt":"2025-07-04T12:16:05.914Z"}]

class Data {
  Data({
    bool? status,
    String? message,
    List<Address>? address,
  }) {
    _status = status;
    _message = message;
    _address = address;
  }

  Data.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['address'] != null) {
      _address = [];
      json['address'].forEach((v) {
        _address?.add(Address.fromJson(v));
      });
    }
  }
  bool? _status;
  String? _message;
  List<Address>? _address;
  Data copyWith({
    bool? status,
    String? message,
    List<Address>? address,
  }) =>
      Data(
        status: status ?? _status,
        message: message ?? _message,
        address: address ?? _address,
      );
  bool? get status => _status;
  String? get message => _message;
  List<Address>? get address => _address;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_address != null) {
      map['address'] = _address?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

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
/// isDeleted : false
/// createdAt : "2025-07-03T09:54:14.355Z"
/// modifiedAt : "2025-07-03T09:54:14.355Z"

class Address {
  Address({
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
    bool? isDeleted,
    String? createdAt,
    String? modifiedAt,
  }) {
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
    _isDeleted = isDeleted;
    _createdAt = createdAt;
    _modifiedAt = modifiedAt;
  }

  Address.fromJson(dynamic json) {
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
    _isDeleted = json['isDeleted'];
    _createdAt = json['createdAt'];
    _modifiedAt = json['modifiedAt'];
  }
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
  bool? _isDeleted;
  String? _createdAt;
  String? _modifiedAt;
  Address copyWith({
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
    bool? isDeleted,
    String? createdAt,
    String? modifiedAt,
  }) =>
      Address(
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
        isDeleted: isDeleted ?? _isDeleted,
        createdAt: createdAt ?? _createdAt,
        modifiedAt: modifiedAt ?? _modifiedAt,
      );
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
  bool? get isDeleted => _isDeleted;
  String? get createdAt => _createdAt;
  String? get modifiedAt => _modifiedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
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
    map['isDeleted'] = _isDeleted;
    map['createdAt'] = _createdAt;
    map['modifiedAt'] = _modifiedAt;
    return map;
  }
}
