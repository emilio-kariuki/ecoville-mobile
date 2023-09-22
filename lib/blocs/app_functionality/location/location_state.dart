part of 'location_cubit.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

final class LocationInitial extends LocationState {}

final class LocationLoading extends LocationState {}

final class LocationLoaded extends LocationState {
  final LatLng currentLocation;

  const LocationLoaded({required this.currentLocation});

  @override
  List<Object> get props => [currentLocation];
}

final class ProductLocationLoaded extends LocationState {
  final LocationModel location;

  const ProductLocationLoaded({required this.location});

  @override
  List<Object> get props => [location];
}

final class LocationError extends LocationState {
  final String message;

  const LocationError({required this.message});

  @override
  List<Object> get props => [message];
}