import 'package:dartz/dartz.dart' hide Order;
import '../../../../core/error/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../../../cart/domain/entities/cart_item.dart';
import '../datasources/checkout_remote_data_source_firestore.dart';
import '../models/order_model.dart';
import '../../../cart/data/models/cart_item_model.dart';

class CheckoutRepositoryImpl implements CheckoutRepository {
  final CheckoutRemoteDataSource remoteDataSource;
  CheckoutRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Order>> placeOrder(
    List<CartItem> items,
    double total, {
    String? shippingAddress,
    String? userEmail,
  }) async {
    try {
      final model = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        items: items.map((e) => CartItemModel(
          productId: e.productId,
          productName: e.productName,
          price: e.price,
          imageUrl: e.imageUrl,
          quantity: e.quantity,
        )).toList(),
        total: total,
        date: DateTime.now(),
        shippingAddress: shippingAddress,
        userEmail: userEmail,
      );
      final placed = await remoteDataSource.placeOrder(model);
      return Right(placed);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}