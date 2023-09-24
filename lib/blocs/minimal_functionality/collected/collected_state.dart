part of 'collected_cubit.dart';

sealed class CollectedState extends Equatable {
  const CollectedState();

  @override
  List<Object> get props => [];
}

final class CollectedInitial extends CollectedState {}

final class CollectedLoading extends CollectedState {}

final class CollectedSuccess extends CollectedState {
  final List<Product> products;

  const CollectedSuccess({required this.products});

  @override
  List<Object> get props => [products];
}

final class CollectedProducts extends CollectedState {
  final int numberOfProducts;

  const CollectedProducts({required this.numberOfProducts});

  @override
  List<Object> get props => [numberOfProducts];
}

final class CollectedAdded extends CollectedState {}

final class CollectedRemoved extends CollectedState {}

final class CollectedError extends CollectedState {
  final String message;

  const CollectedError({required this.message});

  @override
  List<Object> get props => [message];
}
