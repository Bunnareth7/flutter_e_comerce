import '../../../../features/product/domain/entities/product.dart';

abstract class AdminProductEvent {}

class LoadAdminProducts extends AdminProductEvent {}

class AddAdminProduct extends AdminProductEvent {
  final Product product;
  AddAdminProduct(this.product);
}

class UpdateAdminProduct extends AdminProductEvent {
  final Product product;
  UpdateAdminProduct(this.product);
}

class DeleteAdminProduct extends AdminProductEvent {
  final String productId;
  DeleteAdminProduct(this.productId);
}