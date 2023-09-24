part of 'favourite_cubit.dart';

sealed class FavouriteState extends Equatable {
  const FavouriteState();

  @override
  List<Object> get props => [];
}

final class FavouriteInitial extends FavouriteState {}

final class FavouriteLoading extends FavouriteState {}

final class FavouriteSuccess extends FavouriteState {
  final List<Product> products;

  const FavouriteSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

final class FavouriteProducts extends FavouriteState {
  final int numberOfProducts;

  const FavouriteProducts({required this.numberOfProducts});

  @override
  List<Object> get props => [numberOfProducts];
}
final class FavouriteAdded extends FavouriteState {}

final class FavouriteRemoved extends FavouriteState {}

final class FavouriteError extends FavouriteState {
  final String message;

  const FavouriteError({required this.message});

  @override
  List<Object> get props => [message];
}
