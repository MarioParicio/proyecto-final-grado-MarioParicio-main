import 'package:cloud_firestore/cloud_firestore.dart';

class PedidoBocadillo {
  String? uid;
  String bocadilloName;
  int cantidad;
  String nota;

  PedidoBocadillo({ this.uid, required this.bocadilloName, required this.cantidad, required this.nota});

  // Convert JSON to a BocadilloPedido object
  factory PedidoBocadillo.fromJson(Map<String, dynamic> json) {
    return PedidoBocadillo(
      uid: json['uid'],
      bocadilloName: json['bocadilloName'],
      cantidad: json['cantidad'],
      nota: json['nota'],
    );
  }

  // Convert BocadilloPedido object to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'bocadilloName': bocadilloName,
      'cantidad': cantidad,
      'nota': nota,
    };
  }

}
