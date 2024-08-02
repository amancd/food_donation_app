import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:foodapp/NGO%20Dashboard/ngo_requests.dart';

class PendingRequestsScreen extends StatefulWidget {
  const PendingRequestsScreen({super.key});

  @override
  _PendingRequestsScreenState createState() => _PendingRequestsScreenState();
}

class _PendingRequestsScreenState extends State<PendingRequestsScreen> {
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

      // Check if the document exists
      if (snapshot.exists) {
        // Access the name field from the document data
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
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("request_pickup")
          .where('accepted', isEqualTo: 'Pending')
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


  void _acceptRequest(String requestId) async {
      String? ngoName = await getName();

      await FirebaseFirestore.instance
          .collection("request_pickup")
          .doc(requestId)
          .update({
        'accepted': 'Accepted',
        'ngo': ngoName,
      });

      // Refresh the list of pending requests
      fetchPendingRequests();

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request accepted successfully!'),
        ),
      );

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Requests()),
      );
  }

  void _cancelRequest(String requestId) async {
      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request cancelled successfully!'),
        ),
      );

      // Pop off the screen
      Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('Pending Requests'),
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
          final pickupid = requestData['pickupid']; // Assuming there's a field called 'requestId' in the data
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
                  color: Color(0xffff6e40)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: $accepted',
                          style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'NGO Name: $ngo',
                          style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        if (imageUrl != null) Image.network(imageUrl, height: 100),
                        const SizedBox(height: 10),
                        Text('Name: $name', style: TextStyle(color: Colors.white),),
                        Text('Phone: $phone', style: TextStyle(color: Colors.white),),
                        Text('Amount: $amount', style: TextStyle(color: Colors.white),),
                        Text('Quality: $quality', style: TextStyle(color: Colors.white),),
                        Text('Location: $location', style: TextStyle(color: Colors.white),),
                        Text('Items: $items', style: TextStyle(color: Colors.white),),
                        Text('Suggestions: $suggestions', style: TextStyle(color: Colors.white),),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (accepted == 'Pending')
                        ElevatedButton(
                          onPressed: () => _acceptRequest(pickupid),
                          child: const Text('Accept'),
                        ),
                      const SizedBox(width: 12,),
                      ElevatedButton(
                        onPressed: () => _cancelRequest(pickupid),
                        child: const Text('Cancel'),
                      ),
                    ],
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
