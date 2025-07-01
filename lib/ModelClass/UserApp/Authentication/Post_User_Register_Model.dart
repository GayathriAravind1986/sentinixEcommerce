/// success : true
/// data : {"status":true,"message":"User created successfully","user":{"isActive":true,"isDeleted":false,"createdAt":"2025-07-01T12:27:33.478Z","modifiedAt":"2025-07-01T12:27:33.478Z","id":6,"name":"Ananya","phone":"9876543211","alternative_phone":"9876500000","dob":"2000-01-01","otp":null,"email":"anan@gmail.com","roll_id":1}}

class PostUserRegisterModel {
  PostUserRegisterModel({
    bool? success,
    Data? data,
  }) {
    _success = success;
    _data = data;
  }

  PostUserRegisterModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  Data? _data;
  PostUserRegisterModel copyWith({
    bool? success,
    Data? data,
  }) =>
      PostUserRegisterModel(
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
    return map;
  }
}

/// status : true
/// message : "User created successfully"
/// user : {"isActive":true,"isDeleted":false,"createdAt":"2025-07-01T12:27:33.478Z","modifiedAt":"2025-07-01T12:27:33.478Z","id":6,"name":"Ananya","phone":"9876543211","alternative_phone":"9876500000","dob":"2000-01-01","otp":null,"email":"anan@gmail.com","roll_id":1}

class Data {
  Data({
    bool? status,
    String? message,
    User? user,
  }) {
    _status = status;
    _message = message;
    _user = user;
  }

  Data.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  bool? _status;
  String? _message;
  User? _user;
  Data copyWith({
    bool? status,
    String? message,
    User? user,
  }) =>
      Data(
        status: status ?? _status,
        message: message ?? _message,
        user: user ?? _user,
      );
  bool? get status => _status;
  String? get message => _message;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }
}

/// isActive : true
/// isDeleted : false
/// createdAt : "2025-07-01T12:27:33.478Z"
/// modifiedAt : "2025-07-01T12:27:33.478Z"
/// id : 6
/// name : "Ananya"
/// phone : "9876543211"
/// alternative_phone : "9876500000"
/// dob : "2000-01-01"
/// otp : null
/// email : "anan@gmail.com"
/// roll_id : 1

class User {
  User({
    bool? isActive,
    bool? isDeleted,
    String? createdAt,
    String? modifiedAt,
    num? id,
    String? name,
    String? phone,
    String? alternativePhone,
    String? dob,
    dynamic otp,
    String? email,
    num? rollId,
  }) {
    _isActive = isActive;
    _isDeleted = isDeleted;
    _createdAt = createdAt;
    _modifiedAt = modifiedAt;
    _id = id;
    _name = name;
    _phone = phone;
    _alternativePhone = alternativePhone;
    _dob = dob;
    _otp = otp;
    _email = email;
    _rollId = rollId;
  }

  User.fromJson(dynamic json) {
    _isActive = json['isActive'];
    _isDeleted = json['isDeleted'];
    _createdAt = json['createdAt'];
    _modifiedAt = json['modifiedAt'];
    _id = json['id'];
    _name = json['name'];
    _phone = json['phone'];
    _alternativePhone = json['alternative_phone'];
    _dob = json['dob'];
    _otp = json['otp'];
    _email = json['email'];
    _rollId = json['roll_id'];
  }
  bool? _isActive;
  bool? _isDeleted;
  String? _createdAt;
  String? _modifiedAt;
  num? _id;
  String? _name;
  String? _phone;
  String? _alternativePhone;
  String? _dob;
  dynamic _otp;
  String? _email;
  num? _rollId;
  User copyWith({
    bool? isActive,
    bool? isDeleted,
    String? createdAt,
    String? modifiedAt,
    num? id,
    String? name,
    String? phone,
    String? alternativePhone,
    String? dob,
    dynamic otp,
    String? email,
    num? rollId,
  }) =>
      User(
        isActive: isActive ?? _isActive,
        isDeleted: isDeleted ?? _isDeleted,
        createdAt: createdAt ?? _createdAt,
        modifiedAt: modifiedAt ?? _modifiedAt,
        id: id ?? _id,
        name: name ?? _name,
        phone: phone ?? _phone,
        alternativePhone: alternativePhone ?? _alternativePhone,
        dob: dob ?? _dob,
        otp: otp ?? _otp,
        email: email ?? _email,
        rollId: rollId ?? _rollId,
      );
  bool? get isActive => _isActive;
  bool? get isDeleted => _isDeleted;
  String? get createdAt => _createdAt;
  String? get modifiedAt => _modifiedAt;
  num? get id => _id;
  String? get name => _name;
  String? get phone => _phone;
  String? get alternativePhone => _alternativePhone;
  String? get dob => _dob;
  dynamic get otp => _otp;
  String? get email => _email;
  num? get rollId => _rollId;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['isActive'] = _isActive;
    map['isDeleted'] = _isDeleted;
    map['createdAt'] = _createdAt;
    map['modifiedAt'] = _modifiedAt;
    map['id'] = _id;
    map['name'] = _name;
    map['phone'] = _phone;
    map['alternative_phone'] = _alternativePhone;
    map['dob'] = _dob;
    map['otp'] = _otp;
    map['email'] = _email;
    map['roll_id'] = _rollId;
    return map;
  }
}
