import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../../../../features/checkout/data/models/order_model.dart';
import '../../../cart/data/models/cart_item_model.dart';

abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> saveOrder(OrderModel order);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final Database database;
  OrderLocalDataSourceImpl({required this.database});

  @override
  Future<List<OrderModel>> getOrders() async {
    final List<Map<String, dynamic>> maps = await database.query('orders', orderBy: 'date DESC');
    return maps.map((map) => OrderModel(
      id: map['id'],
      items: (json.decode(map['items']) as List)
          .map((e) => CartItemModel.fromJson(e))
          .toList(),
      total: (map['total'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      status: map['status'] ?? 'confirmed',
    )).toList();
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    await database.insert('orders', {
      'id': order.id,
      'items': json.encode(order.items.map((e) => (e as CartItemModel).toJson()).toList()),
      'total': order.total,
      'date': order.date.toIso8601String(),
      'status': order.status,
    });
  }
}