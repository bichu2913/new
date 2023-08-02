import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final List<DocumentSnapshot> cartProducts;
  final List<int> quantities;
 
  CartModel({
    required this.cartProducts,
    required this.quantities,
  });

  double getTotalPrice() {
    double totalPrice = 0;
    for (int i = 0; i < cartProducts.length && i < quantities.length; i++) {
      DocumentSnapshot productSnapshot = cartProducts[i];
      Map<String, dynamic>? data = productSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        double price = (data['price'] as num?)?.toDouble() ?? 0.0;
        int quantity = quantities[i];
        totalPrice += price * quantity;
      }
    }
    return totalPrice;
  }
}