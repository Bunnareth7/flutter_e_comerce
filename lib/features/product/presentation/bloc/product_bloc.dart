import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/get_product_by_id.dart';
import 'product_event.dart';
import 'product_state.dart';

import '../../../../core/usecases/usecase.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final GetProductById getProductById;

  ProductBloc({
    required this.getProducts,
    required this.getProductById,
  }) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadProductById>(_onLoadProductById);
    on<LoadProductsByCategory>(_onLoadProductsByCategory);
    on<RefreshProducts>(_onRefreshProducts);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getProducts(NoParams());
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }

  void _onLoadProductById(LoadProductById event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getProductById(GetProductByIdParams(event.id));
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }

  void _onLoadProductsByCategory(LoadProductsByCategory event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    final result = await getProducts(NoParams());
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) {
        final filtered = products.where((p) => p.category == event.category).toList();
        emit(ProductsLoaded(filtered));
      },
    );
  }

  void _onRefreshProducts(RefreshProducts event, Emitter<ProductState> emit) async {
    final result = await getProducts(NoParams());
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(ProductsLoaded(products)),
    );
  }
}