import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentinix_ecommerce/Api/apiProvider.dart';

abstract class AddAddressEvent {}

class AddAddress extends AddAddressEvent {
  String latitude;
  String longitude;
  String mapLocation;
  String flatAddress;
  String floorNumber;
  String apartmentName;
  String streetName;
  String areaName;
  String pinCode;
  String addressType;
  AddAddress(
    this.latitude,
    this.longitude,
    this.mapLocation,
    this.flatAddress,
    this.floorNumber,
    this.apartmentName,
    this.streetName,
    this.areaName,
    this.pinCode,
    this.addressType,
  );
}

class FetchAddress extends AddAddressEvent {}

class AddAddressBloc extends Bloc<AddAddressEvent, dynamic> {
  AddAddressBloc() : super(dynamic) {
    on<AddAddress>((event, emit) async {
      await ApiProvider()
          .addressAddAPI(
        event.latitude,
        event.longitude,
        event.mapLocation,
        event.flatAddress,
        event.floorNumber,
        event.apartmentName,
        event.streetName,
        event.areaName,
        event.pinCode,
        event.addressType,
      )
          .then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
    on<FetchAddress>((event, emit) async {
      await ApiProvider().addressFetchAPI().then((value) {
        emit(value);
      }).catchError((error) {
        emit(error);
      });
    });
  }
}
