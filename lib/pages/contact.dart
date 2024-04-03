import 'package:flutter/material.dart';
import 'package:foodapp/pages/about.dart';

class Contact extends StatelessWidget {
  Contact({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.cyan.shade700,
        title: const Text("Contact", style: TextStyle(color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => About()),
              );
            },
            icon: const Icon(Icons.info_outline, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), gradient: const LinearGradient(
                colors: [Colors.blue, Colors.green],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 15.0, right: 15.0, left: 15.0),
                          child: Text(
                            "Have questions or want to learn more about Food Bridge? Feel free to reach out to us atcontact foodbridge@gmail.com or give us a call at XXXXXXXXXX. We'd love to hear from you!",
                            style: TextStyle(fontSize: 15, color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],

                ),
              ),),
          )

        ],
      ),
    );
  }
}