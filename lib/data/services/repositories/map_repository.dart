import 'package:ecoville_bloc/data/models/location_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_webservice/places.dart';

class MapRepository {
  Future<LatLng> getCurrentPosition() async {
    try {
      await [
        Permission.location,
      ].request();
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<LocationModel> getProductLocation(
      {required BuildContext context,
      required GlobalKey<ScaffoldState> key}) async {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      GoogleMapsPlaces places =
          GoogleMapsPlaces(apiKey: "AIzaSyBkOlEK3rAUxsL0xGiD5XaP22QjbP9vZq8");
      Prediction? p = await PlacesAutocomplete.show(
          context: context,
          apiKey: "AIzaSyBkOlEK3rAUxsL0xGiD5XaP22QjbP9vZq8",
          onError: (PlacesAutocompleteResponse response) {
            debugPrint(response.errorMessage.toString());
          },
          mode: Mode.overlay,
          hint: "search location",
          language: 'en',
          strictbounds: false,
          types: [""],
          decoration: InputDecoration(
              hintText: 'Search',
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: Colors.white))),
          components: [
            Component(Component.country, "ke"),
            Component(Component.country, "uk")
          ]);
      displayPrediction(p!, key.currentState);
      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId!);

      return LocationModel(
        name: p.description as String,
        lon: detail.result.geometry!.location.lng,
        lat: detail.result.geometry!.location.lat,
      );
    } catch (e) {
      debugPrint(e.toString());
      throw Exception(e);
    }
  }

  Future<void> displayPrediction(
      Prediction p, ScaffoldState? currentState) async {
    GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: "AIzaSyBkOlEK3rAUxsL0xGiD5XaP22QjbP9vZq8",
        apiHeaders: await const GoogleApiHeaders().getHeaders());

    await places.getDetailsByPlaceId(p.placeId!);

    //   final lat = detail.result.geometry!.location.lat;
    //   final lng = detail.result.geometry!.location.lng;
    // }
  }
}
