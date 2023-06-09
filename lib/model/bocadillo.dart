import 'dart:convert';

class Bocadillo {
  Bocadillo({this.uid, required this.name, required this.description, required this.photoUrl, required this.price,  this.ingredients, required this.active});

  String? uid;
  String name;
  String description;
  String photoUrl;
  double price;
  bool active;
  List<String>? ingredients;

  factory Bocadillo.fromJson(Map<String, dynamic> json) => Bocadillo(
        uid: json["uid"],
        name: json["name"],
        description: json["description"],
        photoUrl: json["photoUrl"],
        price: json["price"] != null ? json["price"].toDouble() : null,
        ingredients: List<String>.from(json["ingredients"].map((x) => x)),
        active: json["active"],        
      );
  
  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "photoUrl": photoUrl,
        "price": price,
        "ingredients": List<dynamic>.from(ingredients!.map((x) => x)),
        "active": active,


        
        
      };
}
