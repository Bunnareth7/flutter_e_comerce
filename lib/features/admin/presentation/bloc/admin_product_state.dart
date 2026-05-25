import '../../../../features/product/domain/entities/product.dart';

abstract class AdminProductState {}

class AdminProductInitial extends AdminProductState {}

class AdminProductLoading extends AdminProductState {}

class AdminProductsLoaded extends AdminProductState {
  final List<Product> products;
  AdminProductsLoaded(this.products);
}

class AdminProductError extends AdminProductState {
  final String message;
  AdminProductError(this.message);
}

class AdminProductSuccess extends AdminProductState {}