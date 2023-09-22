import 'dart:convert';


List<UserModel> userFromJson(String str) =>
    List<UserModel>.from(json.decode(str).map((x) => UserModel.fromJson(x)));

class UserModel {
  String? name;
  String? email;
  String? phone;
  String? location;
  String? lon;
  String? lat;
  String? userID;
  String? imageUrl;


  UserModel(this.name, this.email, this.phone, this.location, this.lon,
      this.lat, this.userID,  this.imageUrl);

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'location': location,
        'lon': lon,
        'lat': lat,
        'userID': userID,
        'imageUrl': imageUrl ,
      };

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['username']! as String;
    email = json['email']! as String;
    phone = json['phone']! as String;
    location = json['location']! as String;
    lon = json['lon']! as String;
    lat = json['lat']! as String;
    userID = json['userID']! as String;
    imageUrl = json['imageUrl'] ?? "https://www.pngitem.com/pimgs/m/30-307416_profile-icon-png-image-free-download-searchpng-employee.png" as String;

  }
}
//how to intergrate bank payment in flutter?
