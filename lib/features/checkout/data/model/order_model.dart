import '../../domain/entities/order.dart';
import '../../../cart/data/models/cart_item_model.dart';

class OrderModel extends Order {
  OrderModel({
    required String id,
    required List<CartItemModel> items,
    required double total,
    required DateTime date,
    String status = 'confirmed',
  }) : super(id: id, items: items, total: total, date: date, status: status);

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      items: (json['items'] as List).map((e) => CartItemModel.fromJson(e)).toList(),
      total: (json['total'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      status: json['status'] ?? 'confirmed',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((e) => (e as CartItemModel).toJson()).toList(),
      'total': total,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}