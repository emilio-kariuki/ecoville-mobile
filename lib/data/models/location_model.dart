// To parse this JSON data, do
//
//     final locationModel = locationModelFromJson(jsonString);

import 'dart:convert';

LocationModel locationModelFromJson(String str) => LocationModel.fromJson(json.decode(str));

String locationModelToJson(LocationModel data) => json.encode(data.toJson());

class LocationModel {
    String name;
    double lon;
    double lat;

    LocationModel({
        required this.name,
        required this.lon,
        required this.lat,
    });

    factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        name: json["name"],
        lon: json["lon"],
        lat: json["lat"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "lon": lon,
        "lat": lat,
    };
}
