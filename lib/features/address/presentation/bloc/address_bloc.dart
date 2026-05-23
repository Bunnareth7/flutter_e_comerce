import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';   // ← needed for NoParams
import '../../domain/usecases/get_addresses.dart';
import '../../domain/usecases/add_address.dart' as add_addr;
import '../../domain/usecases/update_address.dart' as upd_addr;
import '../../domain/usecases/delete_address.dart' as del_addr;
import '../../domain/usecases/set_default_address.dart' as set_def;
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetAddresses getAddresses;
  final add_addr.AddAddress addAddress;
  final upd_addr.UpdateAddress updateAddress;
  final del_addr.DeleteAddress deleteAddress;
  final set_def.SetDefaultAddress setDefaultAddress;

  AddressBloc({
    required this.getAddresses,
    required this.addAddress,
    required this.updateAddress,
    required this.deleteAddress,
    required this.setDefaultAddress,
  }) : super(AddressInitial()) {
    on<LoadAddresses>(_onLoadAddresses);
    on<AddAddress>(_onAddAddress);
    on<UpdateAddress>(_onUpdateAddress);
    on<DeleteAddress>(_onDeleteAddress);
    on<SetDefaultAddress>(_onSetDefaultAddress);
  }

  void _onLoadAddresses(LoadAddresses event, Emitter<AddressState> emit) async {
    emit(AddressLoading());
    final result = await getAddresses(NoParams());
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (addresses) => emit(AddressesLoaded(addresses)),
    );
  }

  void _onAddAddress(AddAddress event, Emitter<AddressState> emit) async {
    final result = await addAddress(add_addr.AddAddressParams(event.address));
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => add(LoadAddresses()),
    );
  }

  void _onUpdateAddress(UpdateAddress event, Emitter<AddressState> emit) async {
    final result = await updateAddress(upd_addr.UpdateAddressParams(event.address));
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => add(LoadAddresses()),
    );
  }

  void _onDeleteAddress(DeleteAddress event, Emitter<AddressState> emit) async {
    final result = await deleteAddress(del_addr.DeleteAddressParams(event.id));
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => add(LoadAddresses()),
    );
  }

  void _onSetDefaultAddress(SetDefaultAddress event, Emitter<AddressState> emit) async {
    final result = await setDefaultAddress(set_def.SetDefaultAddressParams(event.id));
    result.fold(
      (failure) => emit(AddressError(failure.message)),
      (_) => add(LoadAddresses()),
    );
  }
}