import 'package:e_com_app/core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_wishlist.dart';
import '../../domain/usecases/add_to_wishlist.dart';
import '../../domain/usecases/remove_from_wishlist.dart';
import '../../domain/usecases/check_wishlist.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlist getWishlist;
  final AddToWishlist addToWishlist;
  final RemoveFromWishlist removeFromWishlist;
  final CheckWishlist checkWishlist;

  WishlistBloc({
    required this.getWishlist,
    required this.addToWishlist,
    required this.removeFromWishlist,
    required this.checkWishlist,
  }) : super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<ToggleWishlist>(_onToggleWishlist);
    on<CheckWishlistStatus>(_onCheckWishlistStatus);
  }

  void _onLoadWishlist(LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    final result = await getWishlist(NoParams());
    result.fold(
      (failure) => emit(WishlistError(failure.message)),
      (items) => emit(WishlistLoaded(items)),
    );
  }

  void _onToggleWishlist(ToggleWishlist event, Emitter<WishlistState> emit) async {
    // Check current status
    final status = await checkWishlist(CheckWishlistParams(event.productId));
    status.fold(
      (failure) => emit(WishlistError(failure.message)),
      (isInWishlist) async {
        if (isInWishlist) {
          await removeFromWishlist(RemoveFromWishlistParams(event.productId));
        } else {
          await addToWishlist(AddToWishlistParams(
              event.productId, event.productName, event.price, event.imageUrl));
        }
        add(LoadWishlist()); // reload list
      },
    );
  }

  void _onCheckWishlistStatus(CheckWishlistStatus event, Emitter<WishlistState> emit) async {
    final result = await checkWishlist(CheckWishlistParams(event.productId));
    result.fold(
      (failure) => emit(WishlistError(failure.message)),
      (isInWishlist) => emit(WishlistItemStatus(isInWishlist)),
    );
  }
}