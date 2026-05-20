import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/cart_item.dart';
import '../repositories/cart_repository.dart';

class GetCart implements UseCase<List<CartItem>, NoParams> {
  final CartRepository repository;
  GetCart(this.repository);
  @override
  Future<Either<Failure, List<CartItem>>> call(NoParams params) => repository.getCartItems();
}