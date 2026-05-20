abstract class ProductEvent {}

class LoadProducts extends ProductEvent {}

class LoadProductById extends ProductEvent {
  final String id;
  LoadProductById(this.id);
}

class LoadProductsByCategory extends ProductEvent {
  final String category;
  LoadProductsByCategory(this.category);
}

class RefreshProducts extends ProductEvent {}