import 'package:cloud_firestore/cloud_firestore.dart';

class PedidoBocadillo {
  String uid;
  int cantidad;
  String nota;

  PedidoBocadillo({required this.uid, required this.cantidad, required this.nota});

  // Convert JSON to a BocadilloPedido object
  factory PedidoBocadillo.fromJson(Map<String, dynamic> json) {
    return PedidoBocadillo(
      uid: json['uid'],
      cantidad: json['cantidad'],
      nota: json['nota'],
    );
  }

  // Convert BocadilloPedido object to JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'cantidad': cantidad,
      'nota': nota,
    };
  }

}
