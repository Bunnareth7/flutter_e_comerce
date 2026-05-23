import 'package:e_com_app/features/address/domain/entities/address.dart';

import '../../domain/entities/address.dart';

abstract class AddressEvent {}

class LoadAddresses extends AddressEvent {}

class AddAddress extends AddressEvent {
  final Address address;
  AddAddress(this.address);
}

class UpdateAddress extends AddressEvent {
  final Address address;
  UpdateAddress(this.address);
}

class DeleteAddress extends AddressEvent {
  final String id;
  DeleteAddress(this.id);
}

class SetDefaultAddress extends AddressEvent {
  final String id;
  SetDefaultAddress(this.id);
}