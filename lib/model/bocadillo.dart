import 'dart:convert';

class Bocadillo {
  Bocadillo({this.uid, required this.name, required this.description, required this.photoUrl});

  String? uid;
  String name;
  String description;
  String photoUrl;

  factory Bocadillo.fromJson(Map<String, dynamic> json) => Bocadillo(
        uid: json["uid"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
      };
}
