import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/Provider%20Dashboard/provider_homepage.dart';
import 'package:foodapp/widgets/custom_buttons.dart';


class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  Future<void> _signUp() async {
    try {
      // Check if user with provided email already exists
      QuerySnapshot existingUsers = await FirebaseFirestore.instance
          .collection('party-venue')
          .where('email', isEqualTo: _emailController.text)
          .get();

      if (existingUsers.docs.isNotEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('User Already Registered'),
            content: const Text('The email address provided is already registered.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // User does not exist, proceed with sign up
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text);

      // Save additional user information to Firestore
      await FirebaseFirestore.instance
          .collection('party-venue')
          .doc(userCredential.user?.uid)
          .set({
        'name': _nameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'address': _addressController.text,
        'uid': userCredential.user?.uid,
        // Add more fields as needed
      });

      // Navigate to the provider home page after successful sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProviderHomePage()),
      );
    } catch (e) {
      // Handle sign up errors here
      print('Sign up failed: $e');
      // You can show a dialog or a snackbar to display the error to the user
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  "assets/image2.png",
                  height: 100,
                ),
                const SizedBox(height: 20),
                _buildTextFieldWithIcon(
                  controller: _nameController,
                  labelText: 'Full Name',
                  icon: Icons.person,
                ),
                const SizedBox(height: 12),
                _buildTextFieldWithIcon(
                  controller: _emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                ),
                const SizedBox(height: 12),
                _buildTextFieldWithIcon(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                _buildTextFieldWithIcon(
                  controller: _phoneNumberController,
                  labelText: 'Phone Number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 12),
                _buildTextFieldWithIcon(
                  controller: _addressController,
                  labelText: 'Address',
                  icon: Icons.location_on,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _signUp();
                      }
                    },
                    text: "Sign Up",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFieldWithIcon({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter $labelText';
        }
        if (labelText == 'Email' && !RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(value)) {
          return 'Please enter a valid email';
        }
        if (labelText == 'Phone Number' && !RegExp(r'^[0-9]{10}$').hasMatch(value)) {
          return 'Please enter a valid 10-digit phone number';
        }
        return null;
      },
    );
  }
}
