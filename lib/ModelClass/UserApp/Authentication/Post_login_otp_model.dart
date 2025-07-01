/// success : true
/// data : {"status":true,"message":"Login successful","token":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwibmFtZSI6IkFuYW55YSIsInBob25lIjoiOTg3NjU0MzIxMSIsImFsdGVybmF0aXZlX3Bob25lIjoiOTg3NjUwMDAwMCIsImRvYiI6IjIwMDAtMDEtMDEiLCJvdHAiOm51bGwsImVtYWlsIjoiYW5hbkBnbWFpbC5jb20iLCJyb2xsX2lkIjoxLCJpc0FjdGl2ZSI6dHJ1ZSwiaXNEZWxldGVkIjpmYWxzZSwiY3JlYXRlZEF0IjoiMjAyNS0wNy0wMVQxMjoyNzozMy40NzhaIiwibW9kaWZpZWRBdCI6IjIwMjUtMDctMDFUMTI6Mjc6MzMuNDc4WiIsImlhdCI6MTc1MTM3MzE4MywiZXhwIjoxNzUxNDE2MzgzfQ.i8W55lLavKHxBLDgsVt_FrWSkt-7CnZ2VPPwbT0UiYQ","user":{"id":6,"name":"Ananya","phone":"9876543211"}}

class PostLoginOtpModel {
  PostLoginOtpModel({
    bool? success,
    Data? data,
  }) {
    _success = success;
    _data = data;
  }

  PostLoginOtpModel.fromJson(dynamic json) {
    _success = json['success'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _success;
  Data? _data;
  PostLoginOtpModel copyWith({
    bool? success,
    Data? data,
  }) =>
      PostLoginOtpModel(
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
/// message : "Login successful"
/// token : "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6NiwibmFtZSI6IkFuYW55YSIsInBob25lIjoiOTg3NjU0MzIxMSIsImFsdGVybmF0aXZlX3Bob25lIjoiOTg3NjUwMDAwMCIsImRvYiI6IjIwMDAtMDEtMDEiLCJvdHAiOm51bGwsImVtYWlsIjoiYW5hbkBnbWFpbC5jb20iLCJyb2xsX2lkIjoxLCJpc0FjdGl2ZSI6dHJ1ZSwiaXNEZWxldGVkIjpmYWxzZSwiY3JlYXRlZEF0IjoiMjAyNS0wNy0wMVQxMjoyNzozMy40NzhaIiwibW9kaWZpZWRBdCI6IjIwMjUtMDctMDFUMTI6Mjc6MzMuNDc4WiIsImlhdCI6MTc1MTM3MzE4MywiZXhwIjoxNzUxNDE2MzgzfQ.i8W55lLavKHxBLDgsVt_FrWSkt-7CnZ2VPPwbT0UiYQ"
/// user : {"id":6,"name":"Ananya","phone":"9876543211"}

class Data {
  Data({
    bool? status,
    String? message,
    String? token,
    User? user,
  }) {
    _status = status;
    _message = message;
    _token = token;
    _user = user;
  }

  Data.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    _token = json['token'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
  }
  bool? _status;
  String? _message;
  String? _token;
  User? _user;
  Data copyWith({
    bool? status,
    String? message,
    String? token,
    User? user,
  }) =>
      Data(
        status: status ?? _status,
        message: message ?? _message,
        token: token ?? _token,
        user: user ?? _user,
      );
  bool? get status => _status;
  String? get message => _message;
  String? get token => _token;
  User? get user => _user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    map['token'] = _token;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    return map;
  }
}

/// id : 6
/// name : "Ananya"
/// phone : "9876543211"

class User {
  User({
    num? id,
    String? name,
    String? phone,
  }) {
    _id = id;
    _name = name;
    _phone = phone;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _phone = json['phone'];
  }
  num? _id;
  String? _name;
  String? _phone;
  User copyWith({
    num? id,
    String? name,
    String? phone,
  }) =>
      User(
        id: id ?? _id,
        name: name ?? _name,
        phone: phone ?? _phone,
      );
  num? get id => _id;
  String? get name => _name;
  String? get phone => _phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['phone'] = _phone;
    return map;
  }
}
