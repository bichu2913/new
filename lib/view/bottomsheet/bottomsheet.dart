import 'package:flutter/material.dart';

class CartBottomSheet extends StatelessWidget {
  final int totalItems;
  final double totalPrice;
    CartBottomSheet({Key? key, required this.totalItems, required this.totalPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Cart Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text('Total Items: $totalItems'),
          const SizedBox(height: 8),
          Text('Total Price: ₹ $totalPrice'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // Perform the action when the button is pressed (e.g., checkout)
              Navigator.of(context).pop(); // Close the bottom sheet
            },
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }
}

void showCartBottomSheet(BuildContext context, int totalItems, double totalPrice) {
  showModalBottomSheet(
    context: context,
    
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    builder: (context) {
      return CartBottomSheet(totalItems: totalItems, totalPrice: totalPrice);
    },
  );
}
