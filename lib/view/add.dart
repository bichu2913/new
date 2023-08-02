import 'dart:io';
import "package:firebase_storage/firebase_storage.dart";
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);

  @override
  AddProductScreenState createState() => AddProductScreenState();
}

class AddProductScreenState extends State<AddProductScreen> {
  String _selectedCategory = '';
  final List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];

  List<String> _getCategories() {
    return ['Fresh Fruits', 'Fresh Vegetables', 'Cuts & Sprouts', 'Leafy'];
  }

  Future<void> _selectImages() async {
  List<XFile>? pickedImages;

  try {
    final ImagePicker picker = ImagePicker();
    pickedImages = await picker.pickMultiImage();
  } catch (e) {
    // Handle error
    print('Error selecting images: $e');
    return;
  }

  // ignore: unnecessary_null_comparison
  if (pickedImages == null) return;

  List<File> selectedImages = pickedImages.map((image) => File(image.path)).toList();

  setState(() {
    _selectedImages.addAll(selectedImages);
  });
}

 
  Future<void> _uploadImagesToFirebase() async {
    List<String> uploadedUrls = [];

    for (File imageFile in _selectedImages) {
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('images');
      String imageName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference referenceImageToUpload = referenceDirImages.child(imageName);

      // Upload the file
      await referenceImageToUpload.putFile(imageFile);

      // Get the download URL
      String imageUrl = await referenceImageToUpload.getDownloadURL();
      uploadedUrls.add(imageUrl);
    }

    setState(() {
      _uploadedImageUrls = uploadedUrls;
    });
  }

  Future<void> _saveProduct() async {
    // Get a reference to the Firestore collection
    CollectionReference productsCollection = FirebaseFirestore.instance.collection('fruits_and_vegetables');

    // Create a new product document
    DocumentReference newProductRef = productsCollection.doc();

    // Prepare the product data to be saved
    Map<String, dynamic> productData = {
      'category': _selectedCategory,
      'name': _nameController.text,
      'price': double.parse(_priceController.text),
      'description': _descriptionController.text,
      'images': _uploadedImageUrls,
      'stock': int.parse(_stockController.text),
    };

    // Save the product data to Firestore
    await newProductRef.set(productData);

    // Show a snackbar message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product added successfully'),
      ),
    );

    // Navigate back to the previous screen
    Navigator.pop(context);
  }

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _stockController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Column(
                children: _getCategories()
                    .map((category) => Row(
                          children: [
                            Radio<String>(
                              value: category,
                              groupValue: _selectedCategory,
                              onChanged: (value) {
                                setState(() {
                                  _selectedCategory = value!;
                                });
                              },
                            ),
                            Text(category),
                          ],
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Product Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Stock',
                ),
              ),
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (File imageFile in _selectedImages)
                    Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                ],
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectImages,
                child: const Text('Select Images'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _uploadImagesToFirebase();
                  await _saveProduct();
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
