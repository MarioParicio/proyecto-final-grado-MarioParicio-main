
import 'pedido_bocadillo.dart';

class Pedido {
  String idOrder;
  String idClient;
  String email;
  List<PedidoBocadillo> bocadillos_order;
  DateTime dateOrder;
  bool paid;

  Pedido({
    required this.idOrder,
    required this.idClient,
    required this.email,
    required this.bocadillos_order,
    required this.dateOrder,
    required this.paid,
  });

   // Convert JSON to an Order object
  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      idOrder: json['idOrder'],
      idClient: json['idClient'],
      email: json['email'], 
      bocadillos_order: List<PedidoBocadillo>.from(json['bocadillos_order'].map((x) => PedidoBocadillo.fromJson(x))),
      dateOrder: DateTime.parse(json['dateOrder']),
      paid: json['paid'],
    );
  }

  // Convert Order object to JSON
  Map<String, dynamic> toJson() {
    return {
      'idOrder': idOrder,
      'idClient': idClient,
      'email': email,
      'bocadillos_order': bocadillos_order.map((bocadillo) => bocadillo.toJson()).toList(),
      'dateOrder': dateOrder.toIso8601String(),
      'paid': paid,
    };
  }
}