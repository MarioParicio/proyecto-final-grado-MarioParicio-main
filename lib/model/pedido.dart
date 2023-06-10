import 'pedido_bocadillo.dart';

class Pedido {

  String idClient;
  String email;
  List<PedidoBocadillo> bocadillos_order;
  DateTime dateOrder;
  bool paid;
  String estado; // "process" or "completed"
  String nameClient;
  double total;

  Pedido({

    required this.idClient,
    required this.email,
    required this.bocadillos_order,
    required this.dateOrder,
    required this.paid,
    required this.estado,
    required this.nameClient,
    required this.total,
  });

  // Convert JSON to an Order object
  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(

      idClient: json['idClient'],
      email: json['email'],
      bocadillos_order: List<PedidoBocadillo>.from(json['bocadillos_order'].map((x) => PedidoBocadillo.fromJson(x))),
      dateOrder: DateTime.parse(json['dateOrder']),
      paid: json['paid'],
      estado: json['estado'],
      nameClient: json['nameClient'],
      total: json['total'].toDouble(),
    );
  }

  // Convert Order object to JSON
  Map<String, dynamic> toJson() {
    return {

      'idClient': idClient,
      'email': email,
      'bocadillos_order': bocadillos_order.map((bocadillo) => bocadillo.toJson()).toList(),
      'dateOrder': dateOrder.toIso8601String(),
      'paid': paid,
      'estado': estado,
      'nameClient': nameClient,
      'total': total,
    };
  }
}
