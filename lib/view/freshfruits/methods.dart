import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sunrule/controller/cart.dart';
import 'package:sunrule/view/bottomsheet/bottomsheet.dart';
import 'package:sunrule/view/cart/cart.dart';

class GridCategoryTile extends StatefulWidget {
  final List<DocumentSnapshot<Object?>> snapshotData;
  final Function(DocumentSnapshot) onTap;

  const GridCategoryTile({Key? key, required this.snapshotData, required this.onTap}) : super(key: key);

  @override
  State<GridCategoryTile> createState() => _GridCategoryTileState();
}

class _GridCategoryTileState extends State<GridCategoryTile> {
  late List<int> quantities = [];

  @override
  void initState() {
    super.initState();
    quantities = List<int>.filled(widget.snapshotData.length, 1);
    initializeQuantities();
    // Call this method to initialize the quantities list
  }

  Future<void> initializeQuantities() async {
    List<int> quantities = await CartController().getQuantitiesForProducts(widget.snapshotData);
    setState(() {
      this.quantities = quantities;
    });
  }

  double totalCartPrice() {
    double total = 0.0;
    for (int i = 0; i < widget.snapshotData.length; i++) {
      double price = (widget.snapshotData[i]['price'] as num?)?.toDouble() ?? 0.0;
      int quantity = quantities[i];
      total += price * quantity;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final double sWidth = MediaQuery.of(context).size.width;
    final double sHeight = MediaQuery.of(context).size.height;
      void navigateTocart() {
  Navigator.push(
    context,
    MaterialPageRoute(
     builder: (context) =>const cart()),
    
  );
}
   
    return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    
    Expanded(
      child: widget.snapshotData.isNotEmpty
          ? GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.76,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: widget.snapshotData.length,
              itemBuilder: (BuildContext context, int index) {
                if (widget.snapshotData.isEmpty) {
                  return const SizedBox();
                }
                final productSnapshot = widget.snapshotData[index];

                String name = productSnapshot['name'] as String? ?? '';
                double price = (productSnapshot['price'] as num?)?.toDouble() ?? 0.0;
                List<dynamic>? imageUrls = productSnapshot['images'] as List<dynamic>?;
                String description = productSnapshot['description'] as String? ?? '';

                String imageUrl = imageUrls != null && imageUrls.isNotEmpty ? imageUrls[0] as String? ?? '' : '';

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  width: 200,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          widget.onTap(productSnapshot);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              width: sWidth / 2.2,
                              height: sHeight * 0.2,
                              alignment: Alignment.center,
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Image.asset("assets/organic.png"),
                                imageUrl: imageUrl,
                                imageBuilder: (context, imageProvider) => Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          description,
                                          style: GoogleFonts.inter(
                                            textStyle: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(155, 155, 155, 1),
                                            ),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      (productSnapshot["stock"]) > 0
                                          ? const Text(
                                              "In stock  ",
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                            )
                                          : const Text(
                                              "out of stock  ",
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                                            )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "₹ $price",
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            FutureBuilder(
                              future: CartManager().isProductInCart(productSnapshot),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  bool isInCart = snapshot.data ?? false;

                                  return isInCart
                                      ? Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color.fromARGB(255, 236, 73, 239)),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove, color: Colors.black, size: 10),
                                                onPressed: () {
                                                  int quantity = quantities[index];
                                                  if (quantity > 1) {
                                                    quantity--;
                                                    quantities[index] = quantity;
                                                    CartController().updateQuantityInDatabase(productSnapshot.id, quantity);
                                                  }
                                                  refreshScreen();
                                                },
                                              ),
                                              Text(
                                                quantities[index].toString(),
                                                style: const TextStyle(fontSize: 10),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add, color: Colors.black, size: 10),
                                                onPressed: () {
                                                  int quantity = quantities[index];
                                                  quantity++;
                                                  quantities[index] = quantity;
                                                  CartController().updateQuantityInDatabase(productSnapshot.id, quantity);
                                                  refreshScreen();
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(color: const Color.fromARGB(255, 236, 73, 239)),
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          child: TextButton(
                                            onPressed: () async {
                                              await CartManager().toggleCartStatus(productSnapshot, true);
                                              refreshScreen();
                                              // ignore: use_build_context_synchronously 
                                              showCartBottomSheet(context, quantities[index], totalCartPrice());
                                            },
                                            child: const Text(
                                              "Add",
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        );
                                }
                              },
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          : SizedBox(
              height: sHeight / 1.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Image.asset("assets/party.png"),
                  ),
                ],
              ),
            )        ),
           
           Visibility(
            visible: widget.snapshotData.isNotEmpty, 
             child: InkWell(
                 onTap:() => navigateTocart(),
                 child:  Container(padding: const EdgeInsets.symmetric(vertical: 10), 
                    height: 60,  
                     width: MediaQuery.of(context).size.width* 0.95,  
                    decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(10.0)),
                    // Somewhere in your code:
           
           
            
                    child: ListTile(leading:Text('${quantities.length} Items | ${totalCartPrice().toStringAsFixed(2)}',style: const TextStyle(color: Colors.white)), 
                     
                    trailing: const Text("View Cart",),) ,),    
               ),
           ),
    ]

    ); 
       
}

  void refreshScreen() {
    setState(() {});
  }
}



