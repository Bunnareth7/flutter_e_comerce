
import 'package:e_com_app/features/wishlist/domain/entities/wishlist_item.dart';
import '../../domain/entities/wishlist_item.dart';

abstract class WishlistState {}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistItem> items;
  WishlistLoaded(this.items);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}

class WishlistItemStatus extends WishlistState {
  final bool isInWishlist;
  WishlistItemStatus(this.isInWishlist);
}