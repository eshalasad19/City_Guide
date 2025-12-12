import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'City Guide',
      home: const CityListPage(),
    );
  }
}

// ---------------- CITY LIST PAGE ----------------
class CityListPage extends StatelessWidget {
  const CityListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cities")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("cities").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No cities found"));
          }

          var cityList = snapshot.data!.docs;

          return ListView.builder(
            itemCount: cityList.length,
            itemBuilder: (context, index) {
              var city = cityList[index];
              return ListTile(
                leading: Image.network(city['image'], width: 80, fit: BoxFit.cover),
                title: Text(city['name']),
                subtitle: Text(
                  city['description'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CityDetailsPage(
                        city_name: city['name'],
                        city_description: city['description'],
                        city_image: city['image'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ---------------- CITY DETAILS PAGE ----------------
class CityDetailsPage extends StatelessWidget {
  final String city_name;
  final String city_description;
  final String city_image;

  const CityDetailsPage({
    super.key,
    required this.city_name,
    required this.city_description,
    required this.city_image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Top Image
          SizedBox(
            height: 330,
            width: double.infinity,
            child: Image.network(city_image, fit: BoxFit.cover),
          ),
          // Gradient overlay
          Container(
            height: 330,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // City Name
          Positioned(
            left: 20,
            bottom: 80,
            child: Text(
              city_name,
              style: const TextStyle(
                fontSize: 34,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 6)],
              ),
            ),
          ),
          // Back button
          Positioned(
            top: 40,
            left: 15,
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
          // Content Area
          Positioned(
            top: 300,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(26),
                  topRight: Radius.circular(26),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dynamic Categories
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("categories").snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Text("No Categories Found");
                        }
                        var categoryList = snapshot.data!.docs;
                        return SizedBox(
                          height: 110,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categoryList.length,
                            itemBuilder: (context, index) {
                              var cat = categoryList[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(14),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Icon(Icons.category, size: 28, color: Colors.blueAccent),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      cat['name'],
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    // About City
                    const Text("About City", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Text(city_description, style: const TextStyle(fontSize: 16, height: 1.4)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
