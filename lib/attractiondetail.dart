import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAttractionDetail extends StatefulWidget {
  const AddAttractionDetail({super.key});

  @override
  State<AddAttractionDetail> createState() => _AddAttractionDetailState();
}

class _AddAttractionDetailState extends State<AddAttractionDetail> {
  String? selectedAttraction;

  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final mapController = TextEditingController();
  final openingHoursController = TextEditingController();
  final contactController = TextEditingController();
  final ratingController = TextEditingController();

  /// --------------------------------------------------
  /// SAVE DATA — BUT FIRST CHECK IF DETAIL ALREADY EXISTS
  /// --------------------------------------------------
  Future<void> saveAttractionDetail() async {
    if (selectedAttraction == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an attraction")),
      );
      return;
    }

    // 🔍 Check if attraction detail already exists
    var existing = await FirebaseFirestore.instance
        .collection("attraction_details")
        .where("attraction_id", isEqualTo: selectedAttraction)
        .get();

    if (existing.docs.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Detail already exists for this attraction"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // ➕ Add new detail if not exists
    await FirebaseFirestore.instance.collection("attraction_details").add({
      "attraction_id": selectedAttraction,
      "address": addressController.text.trim(),
      "website_url": websiteController.text.trim(),
      "map_coordinates": mapController.text.trim(),
      "opening_hours": openingHoursController.text.trim(),
      "contact_info": contactController.text.trim(),
      "average_rating": double.tryParse(ratingController.text.trim()) ?? 0.0,
      "created_at": DateTime.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Attraction detail added successfully"),
        backgroundColor: Colors.green,
      ),
    );

    // Clear fields optionally
    addressController.clear();
    websiteController.clear();
    mapController.clear();
    openingHoursController.clear();
    contactController.clear();
    ratingController.clear();
  }

  /// --------------------------------------------------
  /// UI BUILD
  /// --------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Attraction Detail"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TITLE
            Text("Select Attraction",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 8),

            /// ------------------------------------------
            /// ATTRACTION DROPDOWN (Firestore Dynamic)
            /// ------------------------------------------
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("attractions")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();

                var attractions = snapshot.data!.docs;

                return DropdownButtonFormField(
                  initialValue: selectedAttraction,
                  items: attractions.map((doc) {
                    return DropdownMenuItem(
                      value: doc.id,
                      child: Text(doc["name"]),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedAttraction = value.toString();
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Choose attraction",
                  ),
                );
              },
            ),

            SizedBox(height: 20),

            /// --------------------------------------------------
            /// ADDRESS
            /// --------------------------------------------------
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                labelText: "Address",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            /// WEBSITE
            TextField(
              controller: websiteController,
              decoration: InputDecoration(
                labelText: "Website URL",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            /// MAP COORDINATES
            TextField(
              controller: mapController,
              decoration: InputDecoration(
                labelText: "Map Coordinates (lat, long)",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            /// OPENING HOURS
            TextField(
              controller: openingHoursController,
              decoration: InputDecoration(
                labelText: "Opening Hours",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            /// CONTACT INFO
            TextField(
              controller: contactController,
              decoration: InputDecoration(
                labelText: "Contact Info",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 15),

            /// RATING
            TextField(
              controller: ratingController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Average Rating (0.00 - 10.00)",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 25),

            /// --------------------------------------------------
            /// SAVE BUTTON
            /// --------------------------------------------------
            ElevatedButton(
              onPressed: saveAttractionDetail,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Add Detail",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
