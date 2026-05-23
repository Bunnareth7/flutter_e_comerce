import 'package:e_com_app/features/address/domain/entities/address.dart';

import '../../domain/entities/address.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressesLoaded extends AddressState {
  final List<Address> addresses;
  AddressesLoaded(this.addresses);
}

class AddressError extends AddressState {
  final String message;
  AddressError(this.message);
}