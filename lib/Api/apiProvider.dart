import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:sentinix_ecommerce/Bloc/Response/errorResponse.dart';
import 'package:sentinix_ecommerce/ModelClass/UserApp/Address/Post_address_model.dart';
import 'package:sentinix_ecommerce/ModelClass/UserApp/Authentication/Post_User_Register_Model.dart';
import 'package:sentinix_ecommerce/ModelClass/UserApp/Authentication/Post_login_model.dart';
import 'package:sentinix_ecommerce/ModelClass/UserApp/Authentication/Post_login_otp_model.dart';
import 'package:sentinix_ecommerce/Reusable/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// All API Integration in ApiProvider
class ApiProvider {
  late Dio _dio;

  /// dio use ApiProvider
  ApiProvider() {
    final options = BaseOptions(
        connectTimeout: const Duration(milliseconds: 150000),
        receiveTimeout: const Duration(milliseconds: 100000));
    _dio = Dio(options);
  }
  /* USER APP */
  /// Register page API Integration

  Future<PostUserRegisterModel> signUpUserAPI(
    String name,
    String phone,
    String email,
    String altPhone,
    String dob,
  ) async {
    try {
      final dataMap = {
        "name": name,
        "phone": phone,
        "email": email,
        "alternative_phone": altPhone,
        "dob": dob,
        "roll_id": 1,
      };

      debugPrint(json.encode(dataMap));
      var data = json.encode(dataMap);
      var dio = Dio();
      debugPrint("API baseUrl: ${Constants.userBaseUrl}");
      var response = await dio.request(
        '${Constants.userBaseUrl}user/register'.trim(),
        options: Options(method: 'POST'),
        data: data,
      );

      debugPrint("API statuscode: ${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          PostUserRegisterModel postUserRegisterModel =
              PostUserRegisterModel.fromJson(response.data);
          return postUserRegisterModel;
        } else {
          return PostUserRegisterModel()
            ..errorResponse = ErrorResponse(
              message: "Error: ${response.data['message'] ?? 'Unknown error'}",
            );
        }
      }
      return PostUserRegisterModel()
        ..errorResponse = ErrorResponse(message: "Unexpected error occurred.");
    } catch (error) {
      debugPrint("ErrorCatch: $error");
      return PostUserRegisterModel()..errorResponse = handleError(error);
    }
  }

  /// Login - phone API Integration
  Future<PostLoginModel> loginUserAPI(
    String phone,
  ) async {
    try {
      final dataMap = {
        "phone": phone,
      };

      debugPrint(json.encode(dataMap));
      var data = json.encode(dataMap);
      var dio = Dio();
      debugPrint("API baseUrl: ${Constants.userBaseUrl}");
      var response = await dio.request(
        '${Constants.userBaseUrl}user/register/request-otp'.trim(),
        options: Options(method: 'POST'),
        data: data,
      );

      debugPrint("API statuscode: ${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          debugPrint("API Response: ${json.encode(response.data)}");
          PostLoginModel postUserLoginModel =
              PostLoginModel.fromJson(response.data);
          return postUserLoginModel;
        }
      } else {
        return PostLoginModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
          );
      }
      return PostLoginModel()
        ..errorResponse = ErrorResponse(message: "Unexpected error occurred.");
    } catch (error) {
      debugPrint("ErrorCatch: $error");
      return PostLoginModel()..errorResponse = handleError(error);
    }
  }

  /// LoginWithOTP API Integration
  Future<PostLoginOtpModel> loginWithOtpUserAPI(
    String phone,
    String otp,
  ) async {
    try {
      final dataMap = {"phone": phone, "otp": otp};

      debugPrint(json.encode(dataMap));
      var data = json.encode(dataMap);
      var dio = Dio();
      debugPrint("API baseUrl: ${Constants.userBaseUrl}");
      var response = await dio.request(
        '${Constants.userBaseUrl}user/register/login-with-otp'.trim(),
        options: Options(method: 'POST'),
        data: data,
      );

      debugPrint("API statuscode: ${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          debugPrint("API Response: ${json.encode(response.data)}");
          PostLoginOtpModel postLoginOtpResponse =
              PostLoginOtpModel.fromJson(response.data);
          if (postLoginOtpResponse.data != null &&
              postLoginOtpResponse.data!.user != null) {
            SharedPreferences sharedPreferences =
                await SharedPreferences.getInstance();
            sharedPreferences.setString(
              "userId",
              postLoginOtpResponse.data!.user!.id.toString(),
            );
            sharedPreferences.setString(
              "roleId",
              postLoginOtpResponse.data!.user!.rollId.toString(),
            );
            sharedPreferences.setString(
              "token",
              postLoginOtpResponse.data!.token.toString(),
            );
            return postLoginOtpResponse;
          } else {
            return postLoginOtpResponse;
          }
        }
      } else {
        return PostLoginOtpModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
          );
      }
      return PostLoginOtpModel()
        ..errorResponse = ErrorResponse(message: "Unexpected error occurred.");
    } catch (error) {
      debugPrint("ErrorCatch: $error");
      return PostLoginOtpModel()..errorResponse = handleError(error);
    }
  }

  /// Address - Add API Integration
  Future<PostAddressModel> addressAddAPI(
    String latitude,
    String longitude,
    String mapLocation,
    String flatAddress,
    String floorNumber,
    String apartmentName,
    String streetName,
    String areaName,
    String pinCode,
    String addressType,
  ) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var userId = sharedPreferences.getString("userId");
    debugPrint("userIdAddress:$userId");
    try {
      final dataMap = {
        "latitude": latitude,
        "longtitude": longitude,
        "maplocation": mapLocation,
        "userId": userId,
        "flatAddress": flatAddress,
        "floorNumber": floorNumber,
        "apartmentName": apartmentName,
        "streetName": streetName,
        "areaName": areaName,
        "pinCode": pinCode,
        "addressType": addressType
      };

      debugPrint(json.encode(dataMap));
      var data = json.encode(dataMap);
      var dio = Dio();
      debugPrint("API baseUrl: ${Constants.userBaseUrl}");
      var response = await dio.request(
        '${Constants.userBaseUrl}settings/userAddress'.trim(),
        options: Options(method: 'POST'),
        data: data,
      );

      debugPrint("API statuscode: ${response.statusCode}");

      if (response.statusCode == 200 && response.data != null) {
        if (response.data['success'] == true) {
          debugPrint("API Response: ${json.encode(response.data)}");
          PostAddressModel postAddressResponse =
              PostAddressModel.fromJson(response.data);
          return postAddressResponse;
        }
      } else {
        return PostAddressModel()
          ..errorResponse = ErrorResponse(
            message: "Error: ${response.data['message'] ?? 'Unknown error'}",
          );
      }
      return PostAddressModel()
        ..errorResponse = ErrorResponse(message: "Unexpected error occurred.");
    } catch (error) {
      debugPrint("ErrorCatch: $error");
      return PostAddressModel()..errorResponse = handleError(error);
    }
  }

  /// handle Error Response
  ErrorResponse handleError(Object error) {
    ErrorResponse errorResponse = ErrorResponse();
    Errors errorDescription = Errors();

    if (error is DioException) {
      DioException dioException = error;

      switch (dioException.type) {
        case DioExceptionType.cancel:
          errorDescription.code = "0";
          errorDescription.message = "Request Cancelled";
          break;
        case DioExceptionType.connectionTimeout:
          errorDescription.code = "522";
          errorDescription.message = "Connection Timeout";
          break;
        case DioExceptionType.sendTimeout:
          errorDescription.code = "408";
          errorDescription.message = "Send Timeout";
          break;
        case DioExceptionType.receiveTimeout:
          errorDescription.code = "408";
          errorDescription.message = "Receive Timeout";
          break;
        case DioExceptionType.badResponse:
          if (error.response != null) {
            errorDescription.code = error.response!.statusCode!.toString();
            errorDescription.message = error.response!.statusCode == 500
                ? "Internet Server Error"
                : error.response!.data["errors"][0]["message"];
          } else {
            errorDescription.code = "500";
            errorDescription.message = "Internet Server Error";
          }
          break;
        case DioExceptionType.unknown:
          errorDescription.code = "500";
          errorDescription.message = "Internet Server Error";
          break;
        case DioExceptionType.badCertificate:
          errorDescription.code = "495";
          errorDescription.message = "Bad Request";
          break;
        case DioExceptionType.connectionError:
          errorDescription.code = "500";
          errorDescription.message = "Internet Server Error";
          break;
      }
    }
    errorResponse.errors = [];
    errorResponse.errors!.add(errorDescription);
    return errorResponse;
  }
}
