import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({Key? key}) : super(key: key);

  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _deliveryDetailsController = TextEditingController();
  final TextEditingController _googleMapsLinkController = TextEditingController();

  String? _phoneNumber;
  Map<String, dynamic>? _requestData;

  Future<void> _fetchRequestData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("request_pickup")
          .where('phone', isEqualTo: _phoneNumber)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // If there are multiple documents with the same phone number,
        // let the user choose which one to update
        if (querySnapshot.docs.length > 1) {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Select Document to Update', style: TextStyle(fontSize: 18),),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var doc in querySnapshot.docs)
                      ListTile(
                        title: Text(doc['pickupid']),
                        onTap: () {
                          Navigator.of(context).pop(doc.data());
                        },
                      ),
                  ],
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


  Future<void> _updateDeliveryProcess() async {
    try {
      await FirebaseFirestore.instance.collection("delivery").doc(_requestData!['pickupid']).set({
        'pickupid': _requestData!['pickupid'],
        'name': _requestData!['name'],
        'phone': _requestData!['phone'],
        'timestamp': _requestData!['timestamp'],
        'delivery_details': _deliveryDetailsController.text,
        'google_maps_link': _googleMapsLinkController.text,
      });
      // Show success message or navigate to next screen
    } catch (error) {
      print('Error updating delivery process: $error');
      // Show error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Page'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16,),
            TextFormField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Enter Phone Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
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
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan.shade700,
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
                  Text('Pickup id: ${_requestData!['pickupid']}'),
                  Text('Name: ${_requestData!['name']}'),
                  Text('Amount: ${_requestData!['amount']}'),
                  Text('Quality: ${_requestData!['quality']}'),
                  Text('Location: ${_requestData!['location']}'),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _deliveryDetailsController,
                    decoration: const InputDecoration(labelText: 'Delivery Details'),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _googleMapsLinkController,
                    decoration: const InputDecoration(labelText: 'Google Maps Link'),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _updateDeliveryProcess();
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan.shade700,
                        foregroundColor: Colors.white
                    ),
                    child: const Text('Update Delivery Process'),
                  ),
                        ],
                      ),
                  ),
              ),
            if (_requestData == null)
              const Text('No request found for the provided phone number'),
          ],
        ),
      ),
    );
  }
}
