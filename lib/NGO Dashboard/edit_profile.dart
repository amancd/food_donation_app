import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodapp/Screens/WelcomeScreen.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController(); // New password controller

  late String currentUserUid;

  @override
  void initState() {
    super.initState();
    fetchCurrentUserUid();
    fetchPartyVenueDetails();
  }

  // Fetching current user UID
  void fetchCurrentUserUid() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      currentUserUid = user.uid;
    }
  }

  // Fetching party venue details
  void fetchPartyVenueDetails() async {
    try {
      DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
          .collection('ngo-details')
          .doc(currentUserUid)
          .get();

      if (docSnapshot.exists) {
        Map<String, dynamic>? data = docSnapshot.data() as Map<String, dynamic>?;
        setState(() {
          _nameController.text = data?['NGO Name'] ?? '';
          _addressController.text = data?['address'] ?? '';
          _emailController.text = data?['email'] ?? '';
          _phoneNumberController.text = data?['phoneNumber'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching party venue details: $e');
    }
  }

  // Logout function
  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // After logout, navigate to the login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        ),
      );
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  // Form validation function
  bool _validateForm() {
    if (_nameController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all the fields')));
      return false;
    }
    return true;
  }

  // Update party venue function
  void _updatePartyVenue() async {
    // Retrieve the phone number from the controller
    String newPhoneNumber = _phoneNumberController.text.trim();

    // Validate the phone number
    if (newPhoneNumber.length != 10 || int.tryParse(newPhoneNumber) == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid 10-digit phone number')));
      return;
    }

    // Proceed with updating the details
    String newName = _nameController.text.trim();
    String newAddress = _addressController.text.trim();
    String newEmail = _emailController.text.trim();

    try {
      await FirebaseFirestore.instance
          .collection('ngo-details')
          .doc(currentUserUid)
          .update({
        'NGO Name': newName,
        'address': newAddress,
        'email': newEmail,
        'phoneNumber': newPhoneNumber,
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Party venue details updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update party venue details')));
    }
  }


  // Update password function
  void _updatePassword() async {
    String newPassword = _newPasswordController.text.trim();

    try {
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Details', style: TextStyle(color: Colors.white),),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Color(0xffff6e40),
        actions: [
          IconButton(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/image3.png",
              height: 150,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'NGO Name',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                // Regular expression for a valid name: Only letters, may contain spaces
                RegExp nameRegExp = RegExp(r'^[a-zA-Z ]+$');
                if (!nameRegExp.hasMatch(value!)) {
                  return 'Enter a valid name';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              enabled: false, // Set enabled to false to disable the email text field
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a phone number';
                }
                // Regular expression for validating 10-digit phone numbers
                RegExp phoneRegExp = RegExp(r'^[0-9]{10}$');
                if (!phoneRegExp.hasMatch(value)) {
                  return 'Please enter a valid 10-digit phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      _updatePartyVenue();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan.shade700,
                      foregroundColor: Colors.white
                  ),
                  child: const Text('Update Details'),
                ),
                ElevatedButton(
                  onPressed: _updatePassword,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white
                  ),
                  child: const Text('Update Password'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

