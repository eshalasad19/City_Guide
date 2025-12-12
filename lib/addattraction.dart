import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddAttractionPage extends StatefulWidget {
  const AddAttractionPage({super.key});

  @override
  State<AddAttractionPage> createState() => _AddAttractionPageState();
}

class _AddAttractionPageState extends State<AddAttractionPage> {
  final nameController = TextEditingController();
  final imageController = TextEditingController();
  final descriptionController = TextEditingController();

  String? selectedCity;
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Attraction"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 CITY DROPDOWN
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('cities').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  
                  List<DropdownMenuItem<String>> cityItems = snapshot.data!.docs.map(
                    (doc) {
                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text(doc['city_name']),
                      );
                    },
                  ).toList();

                  return DropdownButtonFormField(
                    items: cityItems,
                    value: selectedCity,
                    onChanged: (value) {
                      setState(() {
                        selectedCity = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Select City",
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              /// 🔥 CATEGORY DROPDOWN
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('categories').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  
                  List<DropdownMenuItem<String>> categoryItems = snapshot.data!.docs.map(
                    (doc) {
                      return DropdownMenuItem(
                        value: doc.id,
                        child: Text(doc['name']),
                      );
                    },
                  ).toList();

                  return DropdownButtonFormField(
                    items: categoryItems,
                    value: selectedCategory,
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "Select Category",
                      border: OutlineInputBorder(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              /// NAME
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Attraction Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// IMAGE URL
              TextField(
                controller: imageController,
                decoration: const InputDecoration(
                  labelText: "Image URL",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              /// DESCRIPTION
              TextField(
                controller: descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 25),

              /// SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: addAttraction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Add Attraction",
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Function to Add Attraction
  Future<void> addAttraction() async {
    if (selectedCity == null || selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select city & category")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('attractions').add({
      "name": nameController.text,
      "image": imageController.text,
      "description": descriptionController.text,
      "cityId": selectedCity,
      "categoryId": selectedCategory,
      "createdAt": Timestamp.now(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Attraction Added Successfully!")),
    );

    nameController.clear();
    imageController.clear();
    descriptionController.clear();
  }
}
