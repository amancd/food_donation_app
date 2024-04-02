import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Tracking extends StatefulWidget {
  const Tracking({super.key});

  @override
  _TrackingState createState() => _TrackingState();
}

class _TrackingState extends State<Tracking> {
  final TextEditingController _phoneNumberController = TextEditingController();

  String? _phoneNumber;
  Map<String, dynamic>? _requestData;
  Map<String, dynamic>? _request;

  Future<void> _fetchRequestData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("request_pickup")
          .where('phone', isEqualTo: _phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If there are multiple documents with the same phone number,
        // let the user choose which one to view
        if (querySnapshot.docs.length > 1) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Select Document to View', style: TextStyle(fontSize: 18)),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: querySnapshot.docs.map((doc) {
                      return ListTile(
                        title: Text(doc['pickupid']),
                        onTap: () {
                          Navigator.of(context).pop(doc.data());
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
          ).then((selectedData) {
            if (selectedData != null) {
              setState(() {
                _requestData = selectedData as Map<String, dynamic>?;
              });
            }
          });
        } else {
          setState(() {
            _requestData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
          });
        }
      } else {
        // Request not found
        setState(() {
          _requestData = null;
        });
      }
    } catch (error) {
      print('Error fetching request data: $error');
    }
  }

  Future<void> _fetchData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("delivery")
        .where('pickupid', isEqualTo: _requestData!['pickupid'])
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        _request = querySnapshot.docs.first.data() as Map<String, dynamic>?;
      });
    } else {
      // Delivery details not found
      setState(() {
        _request = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracking'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16,),
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Enter Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
                // You can customize the appearance of the outline border further if needed
              ),
              onChanged: (value) {
                setState(() {
                  _phoneNumber = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _fetchRequestData();
                _fetchData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyan.shade600,
                foregroundColor: Colors.white
              ),
              child: const Text('Fetch Request Data'),
            ),
            const SizedBox(height: 20),
            if (_requestData != null)
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Pickup Details:", style: TextStyle(fontSize: 16)),
                      Text('Pickup id: ${_requestData!['pickupid']}'),
                      Text('Name: ${_requestData!['name']}'),
                      Text('Amount: ${_requestData!['amount']}'),
                      Text('Quality: ${_requestData!['quality']}'),
                      Text('Location: ${_requestData!['location']}'),
                      Text('Time: ${DateFormat('d MMMM yyyy hh:mm a').format((_requestData!['timestamp'] as Timestamp).toDate())}'),
                      const SizedBox(height: 16,),
                      if (_request != null) ...[
                        const Text("Delivery Details:", style: TextStyle(fontSize: 16)),
                        Text('Delivery details: ${_request!['delivery_details'] ?? 'Not available'}'),
                        Text('Google Maps Link: ${_request!['google_maps_link'] ?? 'Not available'}'),
                        Text('Time: ${_request!['timestamp'] != null ? DateFormat('d MMMM yyyy hh:mm a').format((_request!['timestamp'] as Timestamp).toDate()) : 'Not available'}'),
                      ] else
                        const Text('No delivery details found'),
                    ],
                  ),
                ),
              ),
            if (_requestData == null)
              const Text('No request found for the provided phone number', style: TextStyle(fontSize: 16, color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
