import 'package:flutter/material.dart';
import 'package:sunrule/view/add.dart';
import 'package:sunrule/view/freshfruits/freshfruit.dart';

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.centerLeft, // Adjust the alignment here
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}


class GridCategoryTile2 extends StatelessWidget {
  final List<String> assetImageUrls;

  const GridCategoryTile2({Key? key, required this.assetImageUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: MediaQuery.of(context).size.height / 4, // Set the desired height here
      child: ListView.builder( 
        scrollDirection: Axis.horizontal,    
        itemCount: assetImageUrls.length,
        itemBuilder: (context, index) {
          String imageUrl = assetImageUrls[index];

          return SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: InkWell(
              onTap:() {},
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                    width: MediaQuery.of(context).size.width / 3,
                    height: MediaQuery.of(context).size.height / 4.5,
                    alignment: Alignment.center, 
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Third extends StatelessWidget {
  const Third({super.key});

  // Function to create a reusable image container
  Widget _buildImageContainer(BuildContext context, String imagePath) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.2,
      height: MediaQuery.of(context).size.height / 7.5,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  } 
   Widget _buildImageContainer2(BuildContext context, String imagePath) {
    
    return Container(
      width: MediaQuery.of(context).size.width / 4.7,
      height: MediaQuery.of(context).size.height / 7.2,
      alignment: Alignment.center, 
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  } 

  @override 
  Widget build(BuildContext context) {
      void navigateTofresh() {
  Navigator.push(
    context,
    MaterialPageRoute(
     builder: (context) =>Freshfruits()),
    
  );
}
 void navigateToadd() {
  Navigator.push(
    context,
    MaterialPageRoute(
     builder: (context) =>const AddProductScreen()),
    
  );
}
    return Column( 
      children: [
        const SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Reuse the container function with different image paths
            InkWell(child: _buildImageContainer(context, 'assets/fruits.png'),
            onTap:() => navigateTofresh(),),
            _buildImageContainer(context, 'assets/dairy.png'),
          ],
        ),
        const SizedBox(height: 15,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Reuse the container function with different image paths
            _buildImageContainer2(context, 'assets/frozen.png'),
            _buildImageContainer2(context, 'assets/sweet.png'),
            _buildImageContainer2(context, 'assets/biscuit.png'), 
            _buildImageContainer2(context, 'assets/packagedfood.png'),
          ],
        ),
        
        const SizedBox(height: 15,), 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
           
           _buildImageContainer2(context, 'assets/atta.png'),
            _buildImageContainer2(context, 'assets/cold.png'),
            _buildImageContainer2(context, 'assets/munchies.png'), 
            _buildImageContainer2(context, 'assets/meat.png'),
          ],
        ),
        const SizedBox(height: 15,), 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            _buildImageContainer2(context, 'assets/masala.png'),
            _buildImageContainer2(context, 'assets/breakfast.png'),
            _buildImageContainer2(context, 'assets/bath.png'), 
            _buildImageContainer2(context, 'assets/cleaning.png'),
          ],
        ),
        
        const SizedBox(height: 15,), 
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            
            _buildImageContainer2(context, 'assets/electrical.png'),
            _buildImageContainer2(context, 'assets/health.png'),
            _buildImageContainer2(context, 'assets/homegrown.png'), 
            InkWell(child: _buildImageContainer2(context, 'assets/homeneeds.png'),
            onTap: () =>navigateToadd() ,),
          ],
        )
    
      ],
    );
  }
}


