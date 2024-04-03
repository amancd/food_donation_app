import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodapp/NGO%20Dashboard/Navigation/ngo_nav.dart';
import 'package:foodapp/NGO%20Dashboard/edit_profile.dart';
import 'package:foodapp/Screens/WelcomeScreen.dart';

class NGOHomePage extends StatelessWidget {
  const NGOHomePage({Key? key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Ngonav(),
      appBar: AppBar(
        title: const Text("NGO Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EditPage()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Container(
              height: 120,
              width: 360,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.purple.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Text(
                  "Announcements",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 170,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "5K+ \nUsers",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Container(
                  height: 120,
                  width: 170,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "100K+\nRequests",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 170,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "1K+ \nNGOs",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
                const SizedBox(width: 20,),
                Container(
                  height: 120,
                  width: 170,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      "10K+\nFeed",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: Text("This is the homepage"),
            ),
          ),
        ],
      ),
    );
  }
}
