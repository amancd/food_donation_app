import 'package:flutter/material.dart';
import 'package:foodapp/Admin%20Dashboard/admin_login.dart';
import 'package:foodapp/NGO%20Dashboard/ngo_login.dart';
import 'package:foodapp/Provider%20Dashboard/provider_login.dart';
import 'package:foodapp/Provider%20Dashboard/provider_signup.dart';
import 'package:foodapp/widgets/custom_buttons.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 35),
            child: Column(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NGOLogin(),
                                ),
                              );
                            },
                            child: const Text(
                              "NGO Login",
                              style: TextStyle(
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      "assets/image1.png",
                      height: 300,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Let's get started",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Never a better time than now to start.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30,),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminLogin(),
                      ),
                    );
                  },
                  child: const Text("Admin Login"),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: CustomButton(
                    onPressed: () async {
                      Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                      );
                      },
                    text: "Sign In",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}