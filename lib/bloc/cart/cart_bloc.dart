
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:sunrule/controller/cart.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<Quantities>((event, emit) async{
      final forQuantities =await FirebaseFirestore.instance.collection("users").doc("bichuamz@gmail.com").get();
      if (forQuantities.exists) {
        final allQuantity = forQuantities.data();
        log(allQuantity.toString());
      }else{
        return emit(CartState(quantities: 1, errormessage: ""));
      }
     final cartData = await CartManager().getCartData();
     final anData = [];
      // log(cartData.toString());
      for (var element in cartData) {
        anData.add(element.data());
      }
     // log(anData.toString());
      
     return emit(CartState(quantities: 1, errormessage: ""));
    });
  }
}
