import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllUsersPage extends StatefulWidget {
  const AllUsersPage({super.key});

  @override
  _AllUsersPageState createState() => _AllUsersPageState();
}

class _AllUsersPageState extends State<AllUsersPage> {
  late List<DocumentSnapshot> _users = [];

  @override
  void initState() {
    super.initState();
    fetchUsersData();
  }

  Future<void> fetchUsersData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("party-venue")
          .get();

      setState(() {
        _users = querySnapshot.docs;
      });
    } catch (error) {
      print('Error fetching users: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Users'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Total Users: ${_users.length}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: _users.isEmpty
                ? const Center(
              child: Text("No Users Found"),
            )
                : ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                final data = user.data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4.0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${data['name'] ?? 'Name not available'}"),
                          Text("Email: ${data['email'] ?? 'Email not available'}"),
                          Text("Phone: ${data['phoneNumber'] ?? 'Phone number not available'}"),
                          Text("Address: ${data['address'] ?? 'Address not available'}"),
                          Text("User id: ${data['uid'] ?? 'User id not available'}"),
                          // You can display more user information here if needed
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
