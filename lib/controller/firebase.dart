import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {   
  // Fetch products from the Women collection
  Future<List<DocumentSnapshot>> getAllfruitsvegetables() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('fruits_and_vegetables')
        .get();

    return snapshot.docs;
  }
  Future<List<DocumentSnapshot>> getfreshfruits() async {
   
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('fruits_and_vegetables')
          .where('category', isEqualTo: 'Fresh Fruits')
          .get();

      return snapshot.docs;
     
    }
    Future<List<DocumentSnapshot>> getfreshvegetables() async {
   
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('fruits_and_vegetables')
          .where('category', isEqualTo: 'Fresh Vegetables')
          .get();

      return snapshot.docs;
     
    }
    Future<List<DocumentSnapshot>> getfreshcuts() async {
   
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('fruits_and_vegetables')
          .where('category', isEqualTo: 'Cuts & Sprouts')
          .get();

      return snapshot.docs;
     
    }
}
