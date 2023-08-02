import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sunrule/controller/cart.dart';

class cart extends StatefulWidget {
  const cart({super.key});

  @override
  State<cart> createState() => _cartState();
}

class _cartState extends State<cart> {
  final CartManager cartManager = CartManager();
  late Future<List<DocumentSnapshot<Object?>>> _cartDataFuture;

  @override
  void initState() {
    super.initState();
    _cartDataFuture = cartManager.getCartData();
  }

  Future<void> _refreshCartData() async {
    setState(() {
      _cartDataFuture = cartManager.getCartData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(backgroundColor: const Color.fromARGB(255, 34, 11, 78),
        title: const Center(child: Text('Cart')),
        actions: [ElevatedButton(onPressed: () {
          
        },style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 34, 11, 78), // Change the background color here
    // You can also customize other button properties, such as text color, padding, shape, etc.
  ), child: const Text("ADD"))],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshCartData,
        child: FutureBuilder<List<DocumentSnapshot<Object?>>>(
          future: _cartDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }

            List<DocumentSnapshot<Object?>> cartProducts = snapshot.data ?? [];

            if (cartProducts.isEmpty) {
              return const Center(
                child: Text('No products in cart'),
              );
            }

            return CartProductList(cartProducts,
                refreshCartData: _refreshCartData);
          },
        ),
      ),
    );
  }
}

class CartProductList extends StatefulWidget {
  final List<DocumentSnapshot<Object?>> cartProducts;
  final VoidCallback refreshCartData;

  const CartProductList(this.cartProducts,
      {required this.refreshCartData, Key? key})
      : super(key: key);

  @override
  State<CartProductList> createState() => _CartProductListState();
}

class _CartProductListState extends State<CartProductList> {
  final CartManager cartManager = CartManager();
  List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    initializeQuantities();
  }

  Future<void> initializeQuantities() async {
    List<int> updatedQuantities = [];

    for (int i = 0; i < widget.cartProducts.length; i++) {
      DocumentSnapshot<Object?> productSnapshot = widget.cartProducts[i];
      String productId = productSnapshot.id;
      int quantity = await cartManager.getQuantity(productId);
      updatedQuantities.add(quantity);
    }

    setState(() {
      quantities = updatedQuantities;
    });
  }

  double getTotalPrice() {
    double totalPrice = 0;
    for (int i = 0; i < widget.cartProducts.length; i++) {
      DocumentSnapshot<Object?> productSnapshot = widget.cartProducts[i];
      Map<String, dynamic>? data =
          productSnapshot.data() as Map<String, dynamic>?;

      if (data != null) {
        double price = (data['price'] as num?)?.toDouble() ?? 0.0;
        int quantity = quantities[i];
        totalPrice += price * quantity;
      }
    }
    return totalPrice;
  }

  @override
  Widget build(BuildContext context) {
     if (quantities.isEmpty) {
      
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        const SizedBox(height: 10,) , 
        Container(padding: const EdgeInsets.symmetric(vertical: 10), 
                  height: 80,  
                   width: MediaQuery.of(context).size.width* 0.97,  
                  decoration: BoxDecoration(image: const DecorationImage(image:AssetImage('assets/delivery.png'),fit:BoxFit.cover),borderRadius: BorderRadius.circular(10.0)),),
                  const SizedBox(height: 10,) ,

        Expanded(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.97,   
            child: ListView.separated(  
              itemCount: widget.cartProducts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                DocumentSnapshot<Object?> productSnapshot =
                    widget.cartProducts[index];
                Map<String, dynamic>? data =
                    productSnapshot.data() as Map<String, dynamic>?;
          
                if (data == null) {
                  return const SizedBox.shrink();
                }
          
                String name = data['name'] as String? ?? '';
                String description = data['description'] as String? ?? '';
                double price = (data['price'] as num?)?.toDouble() ?? 0.0;
                List<dynamic>? imageUrls = data['images'] as List<dynamic>?;
          
                String imageUrl = imageUrls != null && imageUrls.isNotEmpty
                    ? imageUrls[0] as String? ?? ''
                    : '';
          
                int stock = (data['stock'] as int?) ?? 0;
                int quantity = quantities[index];
          
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 10), 
                  height: 100, 
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Dismissible(
                    key: Key(productSnapshot.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      _deleteProductFromCart(context, productSnapshot);
                    },
                    child: ListTile(
                      tileColor: Colors.white,
                      leading: 
                        
                          Image.network(
                            imageUrl,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                          
                          
                       
                     
                      title: Row(  
                        children: [
                          Expanded(
                            child: Text( 
                              name,
                              textAlign: TextAlign.center,
                            ),
                          ),
                           Container(decoration: BoxDecoration(border: Border.all(color: Colors.red), ), height: 29,      
                            // color: Colors.red.shade700,   
                             child: Row(
                                                 mainAxisSize: MainAxisSize.min,
                                                 children: [ 
                                                   IconButton(
                              icon: const Icon(Icons.remove, color: Colors.black,size: 10,), 
                              onPressed: () {
                                setState(() {
                                  if (quantity > 1) {
                                    quantity--;
                                    quantities[index] = quantity;
                                  }
                                  updateQuantityInDatabase(
                                      productSnapshot.id, quantity);
                                });
                              },
                                                   ),
                                                   Text( 
                              quantity.toString(),
                              style: const TextStyle(fontSize: 14,color: Colors.black),  
                                                   ),
                                                   IconButton(
                              icon: const Icon(Icons.add, color: Colors.black,size: 10,), 
                              onPressed: () {
                                setState(() {
                                  if (quantity < stock) {
                                    quantity++;
                                    quantities[index] = quantity;
                                  }
                                  updateQuantityInDatabase(
                                      productSnapshot.id, quantity);
                                });
                              },
                                                   ),
                                                 ],
                                               ),
                           ) 
                        ],
                      ),
                      subtitle: Text(
                            description, 
                            textAlign: TextAlign.center,   
                          ),
                      trailing:Text( 
                        '\$${(price * quantity).toStringAsFixed(2)}',
                        textAlign: TextAlign.start, 
                      ), 
                      onTap: () {},
                    ),
                    
                  ),
                );
              },
            ),
          ),
        ),
        ListTile(
          title: const Text(
            'Total Price',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            '\$${getTotalPrice().toStringAsFixed(2)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Container(height: 100,  
        width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(image: DecorationImage(image:AssetImage('assets/save.png'))),    
        ),
        ElevatedButton(
          onPressed: () {
            // Place order logic here
          },
          style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.of(context).size.width * 0.90,50),
    backgroundColor: Colors.red, 
    
  ),
          child: const Text('ADD ADRESS TO PROCEED'),
        ),
      ],
    );
  }

  Future<void> _deleteProductFromCart(
      BuildContext context, DocumentSnapshot<Object?> productSnapshot) {
    return cartManager.deleteItemFromCart(productSnapshot).then((_) {
      setState(() {
        widget.cartProducts.removeWhere(
            (snapshot) => snapshot.reference == productSnapshot.reference);
        initializeQuantities();
      });
    });
  }

  Future<void> updateQuantityInDatabase(String productId, int quantity) {
    return cartManager.updateQuantity(productId, quantity);
  }
}
 