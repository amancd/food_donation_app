import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AllRequests extends StatefulWidget {
  const AllRequests({super.key});

  @override
  _AllRequestsState createState() => _AllRequestsState();
}

class _AllRequestsState extends State<AllRequests> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  late List<Map<String, dynamic>> _requests = [];

  @override
  void initState() {
    super.initState();
    fetchRequestsData();
  }

  Future<void> fetchRequestsData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("request_pickup")
          .get(); // Fetch all requests

      List<Map<String, dynamic>> requestDataList = [];

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> requestData = doc.data() as Map<String, dynamic>;
        requestDataList.add(requestData);
      }

      setState(() {
        _requests = requestDataList;
      });
    } catch (error) {
      print('Error fetching requests: $error');
    }
  }

  Future<void> _deleteRequest(String pickupId) async {
    try {
      await FirebaseFirestore.instance
          .collection("request_pickup")
          .doc(pickupId)
          .delete();

      // Refresh the list of requests after deletion
      fetchRequestsData();

      // Show confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Request deleted successfully!'),
        ),
      );
    } catch (error) {
      print('Error deleting request: $error');
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred while deleting the request.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: const Text('All Requests'),
      ),
      body: _requests.isEmpty
          ? const Center(
        child: Text("No Requests Found"),
      )
          : ListView.builder(
        itemCount: _requests.length,
        itemBuilder: (context, index) {
          final requestData = _requests[index];
          final name = requestData['name'];
          final phone = requestData['phone'];
          final uid = requestData['userid'];
          final amount = requestData['amount'];
          final quality = requestData['quality'];
          final location = requestData['location'];
          final items = requestData['items'];
          final suggestions = requestData['suggestions'];
          final imageUrl = requestData['imageUrl'];
          final accepted = requestData['accepted'];
          final ngo = requestData['ngo'];
          final pickupId = requestData['pickupid'];

          bool isPending = accepted == 'Pending';

          return Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(
                vertical: 8.0, horizontal: 16.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: LinearGradient(
                  colors: [Colors.lightBlue, Colors.purple.shade500],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: $accepted',
                        style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    Text('NGO Name: $ngo',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 10,
                    ),
                    if (imageUrl != null)
                      Image.network(imageUrl, height: 100),
                    const SizedBox(
                      height: 10,
                    ),
                    Text('Name: $name', style: const TextStyle(color: Colors.white),),
                    Text('Phone: $phone', style: const TextStyle(color: Colors.white),),
                    Text('Amount: $amount', style: const TextStyle(color: Colors.white),),
                    Text('Quality: $quality', style: const TextStyle(color: Colors.white),),
                    Text('Location: $location', style: const TextStyle(color: Colors.white),),
                    Text('Items: $items', style: const TextStyle(color: Colors.white),),
                    Text('Suggestions: $suggestions', style: const TextStyle(color: Colors.white),),
                    Text('User id: $uid', style: const TextStyle(color: Colors.white),),
                    Text('Pickup id: $pickupId', style: const TextStyle(color: Colors.white),),
                  ],
                ),
                trailing: isPending
                    ? IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.white,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Confirm Deletion'),
                          content: const Text(
                              'Are you sure you want to delete this request?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteRequest(pickupId);
                                Navigator.of(context).pop();
                              },
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                )
                    : const SizedBox(), // Placeholder if not pending
              ),
            ),
          );
        },
      ),
    );
  }
}
