part of 'product_cubit.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductSuccess extends ProductState {
  final List<Product> products;

  const ProductSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

final class ProductFetched extends ProductState {
  final Product product;

  const ProductFetched({required this.product});

  @override
  List<Object> get props => [product];
}

final class ProductCreated extends ProductState {}

final class ProductDeleted extends ProductState {}

final class ProductUpdated extends ProductState {}

final class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}
