import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RequestPickupForm extends StatefulWidget {
  const RequestPickupForm({Key? key});

  @override
  _RequestPickupFormState createState() => _RequestPickupFormState();
}

class _RequestPickupFormState extends State<RequestPickupForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _qualityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _itemsController = TextEditingController();
  final TextEditingController _suggestionsController = TextEditingController();
  File? _image;

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<UserData?> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('party-venue')
        .doc(userId)
        .get();

    if (snapshot.exists) {
      Map<String, dynamic>? data =
          snapshot.data() as Map<String, dynamic>?; // Explicit cast
      if (data != null) {
        String? phoneNumber = data['phoneNumber'] as String?;
        String? name = data['name'] as String?;
        return UserData(phoneNumber: phoneNumber, name: name);
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  // Method to handle form submission
  void _submitForm() async {
    UserData? userData = await getUserData();
    if (_formKey.currentState!.validate()) {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user!.uid;

      try {
        // Generate a unique pickupid
        final pickupid =
            FirebaseFirestore.instance.collection('request_pickup').doc().id;

        // Upload image to Firebase Storage
        String? imageUrl;
        if (_image != null) {
          final storageRef = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('images')
              .child(pickupid);
          final uploadTask = storageRef.putFile(_image!);
          final snapshot = await uploadTask.whenComplete(() {});
          imageUrl = await snapshot.ref.getDownloadURL();
        }

        // Save form data including image URL, pickupid, and userid
        await FirebaseFirestore.instance
            .collection('request_pickup')
            .doc(pickupid)
            .set({
          'userid': userId, // User ID
          'pickupid': pickupid, // Unique pickup ID
          'amount': _amountController.text,
          'quality': _qualityController.text,
          'location': _locationController.text,
          'items': _itemsController.text,
          'suggestions': _suggestionsController.text,
          'timestamp': FieldValue.serverTimestamp(),
          'imageUrl': imageUrl, // Add image URL to Firestore
          'accepted': 'Pending', // Initial value for accepted status
          'phone': userData!.phoneNumber,
          'name': userData.name,
          'ngo': '', // Initial value for ngo
        });

        // Show confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request submitted successfully!'),
          ),
        );

        // Clear form fields and image
        _amountController.clear();
        _qualityController.clear();
        _locationController.clear();
        _itemsController.clear();
        _suggestionsController.clear();
        setState(() {
          _image = null;
        });
      } catch (error) {
        print('Error submitting request: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request Pickup'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                "assets/pickup.jpg",
                height: 150,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount of Food',
                  prefixIcon: Icon(Icons.food_bank),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the amount of food';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _qualityController,
                decoration: const InputDecoration(
                  labelText: 'Quality of Food',
                  prefixIcon: Icon(Icons.star),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the quality of food';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _itemsController,
                decoration: const InputDecoration(
                  labelText: 'Items',
                  prefixIcon: Icon(Icons.shopping_basket),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the items';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _suggestionsController,
                decoration: const InputDecoration(
                  labelText: 'Suggestions (Optional)',
                  prefixIcon: Icon(Icons.comment),
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16.0),
              if (_image != null)
                Image.file(
                  _image!,
                  height: 150,
                ),
              ElevatedButton.icon(
                onPressed: _uploadImage,
                icon: const Icon(Icons.image),
                label: const Text('Upload Image'),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserData {
  final String? phoneNumber;
  final String? name;

  UserData({this.phoneNumber, this.name});
}
