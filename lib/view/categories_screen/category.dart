import 'package:flutter/material.dart';

import 'methods.dart';

class Allcategory extends StatelessWidget {
  const Allcategory({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> assetImageUrls = [
 'assets/kitchen.png','assets/pet.png','assets/gift.png','assets/makeup.png','assets/baby.png','assets/organic.png','assets/party.png', 'assets/fitness.png'
];
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("All Categories")),
      actions: const [Icon(Icons.search),],
      backgroundColor: const Color.fromARGB(255, 61, 18, 99),
      ),
      body:  SingleChildScrollView(
        child: Column(
          
          children: [
            const SectionTitle(title: 'Explore New Categories'),
            GridCategoryTile2(assetImageUrls: assetImageUrls,),
            const SectionTitle(title: 'Explore By Categories'),
            const Third()
          ],
        ),
      ),
    );
  }
} 