part of 'cart_bloc.dart';

class CartState {
  final int quantities;
  final String errormessage;
  CartState({required this.quantities, required this.errormessage});
}

class CartInitial extends CartState {
  CartInitial():super(errormessage: "",quantities: 1);
}
