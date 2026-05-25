import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

abstract class CheckoutRemoteDataSource {
  Future<OrderModel> placeOrder(OrderModel order);
}

class CheckoutRemoteDataSourceFirestore implements CheckoutRemoteDataSource {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<OrderModel> placeOrder(OrderModel order) async {
    await _firestore.collection('orders').doc(order.id).set(order.toJson());
    return order;
  }
}