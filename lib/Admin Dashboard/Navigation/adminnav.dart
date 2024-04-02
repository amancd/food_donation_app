import 'package:flutter/material.dart';
import 'package:foodapp/Admin%20Dashboard/admin_home.dart';
import 'package:foodapp/Admin%20Dashboard/all_requests.dart';
import 'package:foodapp/Admin%20Dashboard/all_users.dart';
import 'package:foodapp/Provider%20Dashboard/provider_tracking.dart';
import 'package:foodapp/allngo.dart';

class AdminNav extends StatelessWidget {
  const AdminNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
        width: 280,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ));
  }
}

Widget buildHeader(BuildContext context) {
  return Material(
    child: InkWell(
      child: Container(
        color: Colors.cyan.shade600,
        padding: EdgeInsets.only(
          top: 10 + MediaQuery.of(context).padding.top,
          bottom: 24,
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 5.0),
              ),
              child: const CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/logo.png"),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Admin Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(""),
            const Center(
              child: Text(
                "\"Food Donation App\"",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget buildMenuItems(BuildContext context) {
  return Container(
    color: Colors.white,
    padding: const EdgeInsets.all(20),
    child: Wrap(
      runSpacing: 5,
      children: [
        ListTile(
          leading: const Icon(Icons.home, color: Colors.black),
          title: const Text("Home", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AdminHomePage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.delivery_dining, color: Colors.black),
          title: const Text("All Requests",
              style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AllRequests()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.person, color: Colors.black),
          title: const Text("All Users", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AllUsersPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.local_hospital, color: Colors.black),
          title: const Text("NGO Directory", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AllNGOPage()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.location_on, color: Colors.black),
          title: const Text("Tracking", style: TextStyle(color: Colors.black)),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const Tracking()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.share, color: Colors.black),
          title: const Text("Share", style: TextStyle(color: Colors.black)),
          onTap: () {
            // shareAppLink();
          },
        ),
      ],
    ),
  );
}