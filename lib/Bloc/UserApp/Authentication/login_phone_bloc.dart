import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Api/apiProvider.dart';

abstract class UserLoginEvent {}

class UserLogin extends UserLoginEvent {
  String phone;
  UserLogin(
    this.phone,
  );
}

class UserLoginWithOtp extends UserLoginEvent {
  String phone;
  String otp;
  UserLoginWithOtp(this.phone, this.otp);
}

class UserLoginBloc extends Bloc<UserLoginEvent, dynamic> {
  UserLoginBloc() : super(dynamic) {
    on<UserLogin>((event, emit) async {
      await ApiProvider().loginUserAPI(event.phone).then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<UserLoginWithOtp>((event, emit) async {
      await ApiProvider()
          .loginWithOtpUserAPI(event.phone, event.otp)
          .then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
  }
}
