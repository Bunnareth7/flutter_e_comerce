import 'dart:convert';
import 'package:e_com_app/features/checkout/data/model/order_model.dart';
import 'package:sqflite/sqflite.dart';
import '../models/order_model.dart';
import '../../domain/entities/order.dart';
import '../models/order_model.dart';


abstract class OrderLocalDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> saveOrder(OrderModel order);
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final Database database;
  OrderLocalDataSourceImpl({required this.database});

  @override
  Future<List<OrderModel>> getOrders() async {
    final maps = await database.query('orders', orderBy: 'date DESC');
    return maps.map((e) => OrderModel.fromJson(e)).toList();
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    await database.insert('orders', order.toJson());
  }
}