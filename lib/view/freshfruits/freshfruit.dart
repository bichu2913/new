import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sunrule/controller/firebase.dart';
import 'package:sunrule/view/freshfruits/methods.dart';

class Freshfruits extends StatefulWidget {
  const Freshfruits({super.key});

  @override
  _FreshfruitsState createState() => _FreshfruitsState();
}

class _FreshfruitsState extends State<Freshfruits> {
  String selectedNavItem = 'Fresh Fruits';
  String content = 'This is the Home Page Content';

  void onNavItemTap(String title) {
    setState(() {
      selectedNavItem = title;
      switch (title) {
        case 'Fresh Fruits':
          content = 'This is the Home Page Content';
          
          break;
        case '     Fresh \n Vegetables':
          content = 'This is the About Page Content';
          break;
        case '  Cuts & \n sprouts':
          content = 'This is the Services Page Content';
          break;
        case 'Leafy':
          content = 'This is the Contact Page Content';
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseService firebaseService = FirebaseService();
    return Scaffold(
      
      appBar: AppBar(
        title: const Center(child: Text("Fruits & Vegetables",style: TextStyle(color: Colors.black),)),
        actions:  [IconButton(onPressed: () {
          
        }, icon:const Icon(Icons.search),
        color: Colors.black,),],
      backgroundColor:  const Color.fromARGB(255, 255, 255, 255),
      ),
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 80, // Width of the sidebar
            color: const Color.fromARGB(255, 255, 255, 255),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10,),
                  NavBarItem(
                    title: 'Fresh Fruits',
                    imageAsset: 'assets/logo1.png',
                    onTap: onNavItemTap,
                    selectedNavItem: selectedNavItem,
                  ),
                  NavBarItem(
                    title: '     Fresh \n Vegetables',
                    imageAsset: 'assets/logo2.png',
                    onTap: onNavItemTap,
                    selectedNavItem: selectedNavItem,
                  ),
                  NavBarItem(
                    title: '  Cuts & \n sprouts',
                    imageAsset: 'assets/logo3.png',
                    onTap: onNavItemTap,
                    selectedNavItem: selectedNavItem,
                  ),
                  NavBarItem( 
                    title: 'Leafy',
                    imageAsset: 'assets/logo4.png',
                    onTap: onNavItemTap,
                    selectedNavItem: selectedNavItem,
                  ),
                   NavBarItem( 
                    title: ' Exotics &  \n premium',
                    imageAsset: 'assets/logo5.png',
                    onTap: onNavItemTap,
                    selectedNavItem: selectedNavItem,
                  ),
                   NavBarItem( 
                    title: '  Organic &  \n hydroponics',
                    imageAsset: 'assets/logo6.png',
                    onTap: onNavItemTap,
                    selectedNavItem: selectedNavItem,
                  ),
                   NavBarItem( 
                    title: ' Flowers &  \n   leaves',
                    imageAsset: 'assets/logo7.png', 
                    onTap: onNavItemTap,
                    selectedNavItem: selectedNavItem,
                  ),
                    NavBarItem( 
                    title: ' Dried Fruits',
                    imageAsset: 'assets/logo8.png', 
                    onTap: onNavItemTap,
                    selectedNavItem: selectedNavItem,
                  ),
                   NavBarItem( 
                    title: ' Gardening',
                    imageAsset: 'assets/logo9.png', 
                    onTap: onNavItemTap,
                    selectedNavItem: selectedNavItem,
                  ),
                   
                ],
              ),
            ),
          ),
         
          // Main Content
          Expanded(
            child: Container(
              color: const Color.fromARGB(0, 243, 240, 240),
              padding: const EdgeInsets.all(20),
              child: Center(
  child: (() {
    switch (selectedNavItem) {
      case 'Fresh Fruits':
      case 'Leafy':
      case ' Flowers &  \n   leaves':

        return FutureBuilder<List<DocumentSnapshot>>(
          future: firebaseService.getfreshfruits(),
          builder: (context, snapshot) {
           return builder(snapshot);
          }
        );
      case '     Fresh \n Vegetables':
      case ' Exotics &  \n premium':
      case ' Dried Fruits':
        return FutureBuilder<List<DocumentSnapshot>>(
          future: firebaseService.getfreshvegetables(),
          builder: (context, snapshot) {
          return builder(snapshot);
          },
        );
      case '  Cuts & \n sprouts':
      case '  Organic &  \n hydroponics':
      case ' Gardening':
        return FutureBuilder<List<DocumentSnapshot>>(
          future: firebaseService.getfreshcuts() ,
          builder: (context, snapshot) {
             return builder(snapshot);
          },
        );
     
      default:
        return Text(
          content,
          style: const TextStyle(fontSize: 24),
        );
    }
  })(),
),

            ),
            
            
          ),
          

           
           
        ],
      ),
      
    );
  }

  Widget builder(AsyncSnapshot<List<DocumentSnapshot<Object?>>> snapshot) {
     if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No data available');
              } else {
                return GridCategoryTile(
     snapshotData: snapshot.data!,
     onTap: (productSnapshot) {
       // Do something when tapping on the product snapshot.
     },
                );
              }
  }
}

class NavBarItem extends StatelessWidget {
  final String title;
  final String imageAsset;
  final Function(String) onTap;
  final String selectedNavItem;

  NavBarItem({super.key, 
    required this.title,
    required this.imageAsset,
    required this.onTap,
    required this.selectedNavItem,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(title);
      },
      child: Column(
        children: [
          Stack(
            children: [
              ClipOval(
                clipper: CustomHalfOvalClipper(),
                child: Container(
                  width: 40,
                  height: 40,
                  color: title == selectedNavItem ? const Color.fromARGB(155, 176, 36, 219) : Colors.transparent,
                ), // Use the custom clipper to make the half oval shape
              ),
              Center(
                child: Image.asset(
                  imageAsset,
                  width: 70,
                  height: 50,
              
                ), 
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: title == selectedNavItem ? const Color.fromARGB(155, 176, 36, 219) : const Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Custom clipper to create half left-side oval shape
class CustomHalfOvalClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(-size.width * 3, 0, size.width * 4, size.height);
  }
  
  @override
  bool shouldReclip(CustomHalfOvalClipper oldClipper) {
    return false;
  }  
}
