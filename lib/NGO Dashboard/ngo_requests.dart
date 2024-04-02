import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Requests extends StatefulWidget {
  const Requests({super.key});

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late List<Map<String, dynamic>> _pendingRequests = [];

  @override
  void initState() {
    super.initState();
    fetchPendingRequests();
  }

  Future<String?> getName() async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user!.uid;
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('ngo-details')
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?; // Explicit cast
        if (data != null) {
          String? name = data['NGO Name'] as String?;
          return name;
        } else {
          return null;
        }
      } else {
        return null;
      }
  }

  Future<void> fetchPendingRequests() async {
    String? ngoName = await getName();
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("request_pickup")
          .where('ngo', isEqualTo: ngoName)
          .get();

      List<Map<String, dynamic>> pendingRequestsList = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        pendingRequestsList.add(requestData);
      }

      setState(() {
        _pendingRequests = pendingRequestsList;
      });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Accepted Requests'),
      ),
      body: _pendingRequests.isEmpty
          ? const Center(
        child: Text("No Pending Requests Found"),
      )
          : ListView.builder(
        itemCount: _pendingRequests.length,
        itemBuilder: (context, index) {
          final requestData = _pendingRequests[index];
          final name = requestData['name'];
          final phone = requestData['phone'];
          final amount = requestData['amount'];
          final quality = requestData['quality'];
          final location = requestData['location'];
          final items = requestData['items'];
          final suggestions = requestData['suggestions'];
          final imageUrl = requestData['imageUrl'];
          final accepted = requestData['accepted'];
          final ngo = requestData['ngo'];

          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: LinearGradient(
                  colors: [Colors.cyan.shade500, Colors.cyan.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imageUrl != null) Center(child: Image.network(imageUrl, height: 100)),
                        const SizedBox(height: 10),
                        Text(
                          'Status: $accepted',
                          style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'NGO Name: $ngo',
                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 10),
                        Text('Name: $name'),
                        Text('Phone: $phone'),
                        Text('Amount: $amount'),
                        Text('Quality: $quality'),
                        Text('Location: $location'),
                        Text('Items: $items'),
                        Text('Suggestions: $suggestions'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
