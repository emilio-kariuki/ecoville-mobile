// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  String id;
  String name;
  String location;
  String type;
  double lon;
  double lat;
  String description;
  String image;
  String userId;

  Product({
    required this.id,
    required this.name,
    required this.location,
    required this.type,
    required this.lon,
    required this.lat,
    required this.description,
    required this.image,
    required this.userId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        name: json["name"],
        location: json["location"],
        type: json["type"],
        lon: json["lon"],
        lat: json["lat"],
        description: json["description"],
        image: json["image"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "location": location,
        "type": type,
        "lon": lon,
        "lat": lat,
        "description": description,
        "image": image,
        "userId": userId,
      };
}
