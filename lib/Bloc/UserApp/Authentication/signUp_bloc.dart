import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Api/apiProvider.dart';

abstract class UserSignUpEvent {}

class UserRegister extends UserSignUpEvent {
  String name;
  String phone;
  String email;
  String altPhone;
  String dob;
  UserRegister(
    this.name,
    this.phone,
    this.email,
    this.altPhone,
    this.dob,
  );
}

class UserSignUpBloc extends Bloc<UserSignUpEvent, dynamic> {
  UserSignUpBloc() : super(dynamic) {
    on<UserRegister>((event, emit) async {
      await ApiProvider()
          .signUpUserAPI(
        event.name,
        event.phone,
        event.email,
        event.altPhone,
        event.dob,
      )
          .then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
  }
}
