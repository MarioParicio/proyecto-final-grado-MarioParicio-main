import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_proyecto_segunda_evaluacion/model/pedido.dart';
import 'package:flutter_proyecto_segunda_evaluacion/model/pedido_bocadillo.dart';

final String ORDER_COLLECTION_NAME = "orders";

class PedidoService {
  // Fetch all orders
  static Future<List<Pedido>> fetchOrders() async {
    final orders = <Pedido>[];

    try {
      final snapshot = await FirebaseFirestore.instance.collection(ORDER_COLLECTION_NAME).get();
      snapshot.docs.forEach((doc) {
        var orderData = doc.data();
        orderData['idOrder'] = doc.id;
        orders.add(Pedido.fromJson(orderData));
      });
    } catch (e) {
      print(e);
    }

    return orders;
  }

  // Add an order
  static Future<void> addOrder(
    String idClient,
    
    String nombre,
    String email,
    List<PedidoBocadillo> bocadillos_order,
    DateTime dateOrder,
    bool paid,
    String estado,
    double total,
  ) async {
    Pedido order = Pedido(

      idClient: idClient,
      nameClient: nombre,
      email: email,
      bocadillos_order: bocadillos_order,
      dateOrder: dateOrder,
      paid: paid,
      estado: estado,
      total: total,
    );
    FirebaseFirestore.instance.collection(ORDER_COLLECTION_NAME).add(order.toJson());
  }

  // Update an order
  static Future<void> updateOrder(
    String idOrder,
    String idClient,
    String nombre,
    String email,
    List<PedidoBocadillo> bocadillos_order,
    DateTime dateOrder,
    bool paid,
    String estado,
    double total,
  ) {
    CollectionReference orders = FirebaseFirestore.instance.collection(ORDER_COLLECTION_NAME);
    return orders
        .doc(idOrder)
        .update({
          'idClient': idClient,
          'nameClient': nombre,
          'email': email,
          'bocadillos_order': bocadillos_order.map((bocadillo) => bocadillo.toJson()).toList(),
          'dateOrder': dateOrder.toIso8601String(),
          'paid': paid,
          'estado': estado,
          'total': total,
        })
        .then((value) => print("Order updated successfully"))
        .catchError((error) => print("Error updating order: $error"));
  }

  // Delete an order
  static void deleteOrder(String idOrder) {
    FirebaseFirestore.instance.collection(ORDER_COLLECTION_NAME).doc(idOrder).delete();
  }
}
