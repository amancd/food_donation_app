import 'package:flutter/material.dart';

class About extends StatelessWidget {
  About({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xffff6e40),
        title: const Text("About", style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(21), gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
              ),
              child: const Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("At Food Bridge, we are dedicated to bridging the gap between surplus food resources and those in need. Our platform serves as a vital link, connecting Non-Governmental Organizations (NGOs) with function halls to ensure that excess food from events is redirected to communities facing food insecurity.", style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Our mission at Food Bridge is simple yet impactful: to alleviate hunger and reduce food waste by facilitating the efficient redistribution of surplus food resources. By fostering partnerships between NGOs and function halls, we strive to create a more equitable and sustainable food system.", style: TextStyle(fontSize: 15, color: Colors.white)),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}