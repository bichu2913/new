import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sunrule/controller/firebase.dart';
import 'package:sunrule/model/cart_model.dart';



class CartController {
  final CartManager cartManager = CartManager();
  late CartModel _cartModel;

  final _cartModelController = StreamController<CartModel>.broadcast();
  Stream<CartModel> get cartModelStream => _cartModelController.stream;

  // Rest of the code in the CartController class


  CartModel get cartModel => _cartModel;

  Future<void> initializeCartData() async {
    List<DocumentSnapshot> cartProducts = await cartManager.getCartData();
    List<int> quantities = await getQuantitiesForProducts(cartProducts);
    _cartModel = CartModel(cartProducts: cartProducts, quantities: quantities);
   _cartModelController.add(_cartModel);  
  }

  Future<List<int>> getQuantitiesForProducts(List<DocumentSnapshot> cartProducts) async {
    List<int> updatedQuantities = [];
    for (int i = 0; i < cartProducts.length; i++) {
      DocumentSnapshot productSnapshot = cartProducts[i];
      String productId = productSnapshot.id;
      int quantity = await cartManager.getQuantity(productId);
      updatedQuantities.add(quantity);
    }
    return updatedQuantities;
  }
  Future<void> updateCartData() async {
    List<DocumentSnapshot> cartProducts = await cartManager.getCartData();
    List<int> quantities = await getQuantitiesForProducts(cartProducts);
    _cartModel = CartModel(cartProducts: cartProducts, quantities: quantities);
    _cartModelController.add(_cartModel);
  }

Future<void> updateQuantityInDatabase(String productId, int quantity) async {
    await cartManager.updateQuantity(productId, quantity);
    updateCartData(); // Update the cart data after quantity is updated
  }

   Future<void> deleteProductFromCart(DocumentSnapshot productSnapshot) async {
    await cartManager.deleteItemFromCart(productSnapshot);
    updateCartData(); // Update the cart data after product is deleted
  }
}
class CartManager {
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
  final FirebaseService firebaseService = FirebaseService();

 Future<void> toggleCartStatus(DocumentSnapshot<Object?> productSnapshot, bool isInCart) async {
  try {
   
    String? userId = 'bichuamz@gmail.com';
    DocumentSnapshot<Object?> userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;
        String productId = productSnapshot.id;

        int index = cart.indexWhere((item) => item['productId'] == productId);
        if (index != -1) {
          cart[index]['quantity'] += 1;
        } else {
          cart.add({'productId': productId, 'quantity': 1});
        }
      } else {
        List<Map<String, dynamic>> cart = [{'productId': productSnapshot.id, 'quantity': 1}];
        userData = {'cart': cart};
      }

      await usersCollection.doc(userId).set(userData, SetOptions(merge: true));
    }
  } catch (e) {
    print('Error toggling cart status: $e');
  }
}
Future<void> deleteItemFromCart(DocumentSnapshot<Object?> productSnapshot) async {
  try {
    String? userId = 'bichuamz@gmail.com';
    DocumentSnapshot<Object?> userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;
        String productId = productSnapshot.id;

        int index = cart.indexWhere((item) => item['productId'] == productId);
        if (index != -1) {
          cart.removeAt(index);
          await usersCollection.doc(userId).update({'cart': cart});

          // Product successfully removed from cart
          print('Product removed from cart');
        }
      }
    }
  } catch (e) {
    print('Error deleting item from cart: $e');
  }
}
Future<int> getQuantity(String productId) async {
    try {
      String? userId = 'bichuamz@gmail.com';
      DocumentSnapshot<Object?> userSnapshot = await usersCollection.doc(userId).get();

      if (userSnapshot.exists) {
        Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('cart')) {
          List<dynamic> cart = userData['cart'] as List<dynamic>;

          int index = cart.indexWhere((item) => item['productId'] == productId);
          if (index != -1) {
            return cart[index]['quantity'] as int? ?? 0;
          }
        }
      }
    } catch (e) {
      print('Error getting quantity: $e');
    }

    return 0; 
  }
  

Future<void> updateQuantity(String productId, int quantity) async {
  try {
    String? userId = 'bichuamz@gmail.com';
    DocumentSnapshot<Object?> userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;

        List<dynamic> updatedCart = cart.map((item) {
          if (item['productId'] == productId) {
            item['quantity'] = quantity;
          }
          return item;
        }).toList();

        await usersCollection.doc(userId).set({'cart': updatedCart}, SetOptions(merge: true));
      }
    }
  } catch (e) {
    print('Error updating quantity: $e');
  }
}





 void printCartLength(List<dynamic> cart) {
  print('Cart Length: ${cart.length}');
}

Future<List<DocumentSnapshot>> getCartData() async {
  try {
    String? userId = 'bichuamz@gmail.com';

    DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;

        printCartLength(cart); // Call the function to print the cart length

        List<DocumentSnapshot> products = await firebaseService.getAllfruitsvegetables();

        print('All Products Length: ${products.length}');

        List<DocumentSnapshot> cartProducts = [];

        for (var cartItem in cart) {
          String productId = cartItem['productId'];

          for (var product in products) {
            if (productId == product.id) {
              cartProducts.add(product);
              break; // Break the inner loop if a match is found
            }
          }
        }

        print('Filtered Products Length: ${cartProducts.length}');

        return cartProducts;
      }
    }

    return [];
  } catch (e) {
    print('Error retrieving cart data: $e');
    return [];
  }
}
Future<int> getCartLength() async {
  try {
    String? userId = 'bichuamz@gmail.com';

    DocumentSnapshot userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;

        return cart.length;
      }
    }

    return 0;
  } catch (e) {
    print('Error retrieving cart data: $e');
    return 0;
  }
}



Future<bool> isProductInCart(DocumentSnapshot<Object?> productSnapshot) async {
  try {
    String? userId = 'bichuamz@gmail.com';
    DocumentSnapshot<Object?> userSnapshot = await usersCollection.doc(userId).get();

    if (userSnapshot.exists) {
      Map<String, dynamic>? userData = userSnapshot.data() as Map<String, dynamic>?;

      if (userData != null && userData.containsKey('cart')) {
        List<dynamic> cart = userData['cart'] as List<dynamic>;
        String productId = productSnapshot.id;
        if(cart.isEmpty){
          return false;
        }

        bool isInCart = cart.any((item) => item['productId'] == productId);
        return isInCart;
      }
    }
  } catch (e) {
    print('Error checking if product is in cart: $e');
  }

  return false;
}  
}
