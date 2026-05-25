import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../../features/checkout/data/models/order_model.dart';
import 'admin_order_event.dart';
import 'admin_order_state.dart';

class AdminOrderBloc extends Bloc<AdminOrderEvent, AdminOrderState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  AdminOrderBloc() : super(AdminOrderInitial()) {
    on<LoadAdminOrders>(_onLoad);
  }

  void _onLoad(LoadAdminOrders event, Emitter<AdminOrderState> emit) async {
    emit(AdminOrderLoading());
    try {
      final snapshot = await _firestore
          .collection('orders')
          .orderBy('date', descending: true)
          .get();
      final orders = snapshot.docs
          .map((doc) => OrderModel.fromJson(doc.data()!))
          .toList();
      emit(AdminOrdersLoaded(orders));
    } catch (e) {
      emit(AdminOrderError(e.toString()));
    }
  }
}