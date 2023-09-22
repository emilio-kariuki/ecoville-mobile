import 'package:bloc/bloc.dart';
import 'package:ecoville_bloc/data/models/location_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../data/services/repositories/map_repository.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  LocationCubit() : super(LocationInitial());

  void getCurrentLocation() async {
    try {
      emit(LocationLoading());
      final currentLocation = await MapRepository().getCurrentPosition();
      
      emit(LocationLoaded(currentLocation: currentLocation));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }

  void getProductLocation(
      {required BuildContext context,
      required GlobalKey<ScaffoldState> key}) async {
    try {
      emit(LocationLoading());
      final productLocation =
          await MapRepository().getProductLocation(context: context, key: key);
          debugPrint("name is ${productLocation.name}");
          debugPrint("lat is ${productLocation.lat}");
          debugPrint("lon is ${productLocation.lon}");
      emit(ProductLocationLoaded(location: productLocation));
    } catch (e) {
      emit(LocationError(message: e.toString()));
    }
  }
}
