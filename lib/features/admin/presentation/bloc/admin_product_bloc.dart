import 'package:e_com_app/core/usecases/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/admin_get_products.dart';
import '../../domain/usecases/admin_add_product.dart';
import '../../domain/usecases/admin_update_product.dart';
import '../../domain/usecases/admin_delete_product.dart';
import 'admin_product_event.dart';
import 'admin_product_state.dart';

class AdminProductBloc extends Bloc<AdminProductEvent, AdminProductState> {
  final AdminGetProducts getProducts;
  final AdminAddProduct addProduct;
  final AdminUpdateProduct updateProduct;
  final AdminDeleteProduct deleteProduct;

  AdminProductBloc({
    required this.getProducts,
    required this.addProduct,
    required this.updateProduct,
    required this.deleteProduct,
  }) : super(AdminProductInitial()) {
    on<LoadAdminProducts>(_onLoad);
    on<AddAdminProduct>(_onAdd);
    on<UpdateAdminProduct>(_onUpdate);
    on<DeleteAdminProduct>(_onDelete);
  }

  void _onLoad(LoadAdminProducts event, Emitter<AdminProductState> emit) async {
    emit(AdminProductLoading());
    final result = await getProducts(NoParams());
    result.fold(
      (failure) => emit(AdminProductError(failure.message)),
      (products) => emit(AdminProductsLoaded(products)),
    );
  }

  void _onAdd(AddAdminProduct event, Emitter<AdminProductState> emit) async {
    final result = await addProduct(AdminAddProductParams(event.product));
    result.fold(
      (failure) => emit(AdminProductError(failure.message)),
      (_) {
        emit(AdminProductSuccess());
        add(LoadAdminProducts());
      },
    );
  }

  void _onUpdate(UpdateAdminProduct event, Emitter<AdminProductState> emit) async {
    final result = await updateProduct(AdminUpdateProductParams(event.product));
    result.fold(
      (failure) => emit(AdminProductError(failure.message)),
      (_) {
        emit(AdminProductSuccess());
        add(LoadAdminProducts());
      },
    );
  }

  void _onDelete(DeleteAdminProduct event, Emitter<AdminProductState> emit) async {
    final result = await deleteProduct(AdminDeleteProductParams(event.productId));
    result.fold(
      (failure) => emit(AdminProductError(failure.message)),
      (_) {
        emit(AdminProductSuccess());
        add(LoadAdminProducts());
      },
    );
  }
}