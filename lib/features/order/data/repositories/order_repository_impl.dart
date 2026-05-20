import 'package:dartz/dartz.dart';
import 'package:e_com_app/features/checkout/data/model/order_model.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_local_data_source.dart';
import '../models/order_model.dart';
import '../../../cart/data/models/cart_item_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;
  OrderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      final orders = await localDataSource.getOrders();
      return Right(orders);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveOrder(Order order) async {
    try {
      final model = OrderModel(
        id: order.id,
        items: order.items.map((e) => CartItemModel(
          productId: e.productId,
          productName: e.productName,
          price: e.price,
          imageUrl: e.imageUrl,
          quantity: e.quantity,
        )).toList(),
        total: order.total,
        date: order.date,
        status: order.status,
      );
      await localDataSource.saveOrder(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}