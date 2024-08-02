import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  Privacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xffff6e40),
        title: const Text("Privacy Policy", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 20.0, bottom: 15.0, right: 15.0, left: 15.0),
                      child: Text(
                        "Privacy Policy: Food Bridge is committed to protecting the privacy of its users. This policy outlines how we collect, use, and safeguard your personal information.",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 20.0, right: 15.0, left: 15.0),
                      child: Text(
                        "Data Usage: Your personal information may be used to improve our services, personalize your experience, and communicate with you. We do not sell or share your information with third parties without your consent.",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 20.0, right: 15.0, left: 15.0),
                      child: Text(
                        "Food Bridge operates on a collaborative model, where NGOs can easily access surplus food from function halls hosting events. Through our intuitive platform, NGOs can request donations of excess food, while function halls can seamlessly coordinate pickups and deliveries, ensuring that no edible food goes to waste.",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ], ),
    );
  }
}