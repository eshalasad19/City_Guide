import 'package:citiguide/UserProfile.dart';
import 'package:citiguide/adminlogin.dart';
import 'package:citiguide/citydetail.dart';
import 'package:citiguide/firebase_options.dart';
import 'package:citiguide/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const Home(),
    ),
  );
}

class Home extends StatelessWidget {
  const Home({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const MyHomePage(title: 'City Guide Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int currentNavIndex = 0;
  int _carouselIndex = 0;
  String searchQuery = "";

  List<String> categories = [
    "Restaurants",
    "Hotels",
    "Parks",
    "Events",
    "Museums",
  ];

  List<String> featuredImages = [
    "https://images.unsplash.com/photo-1600891964599-f61ba0e24092?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1557682250-805d5f41a1c4?auto=format&fit=crop&w=800&q=60",
    "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=60",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // ---------------- APPBAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 4,
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Search attractions...",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value.trim().toLowerCase();
                    });
                  },
                  onSubmitted: (value) {
                    if (value.isEmpty) return;
                    _navigateToCityDetail(value);
                  },
                ),
              ),
            ],
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.blueAccent),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1603415526960-f7e0328e77d5?auto=format&fit=crop&w=200&q=60"),
            ),
          ),
        ],
      ),

      // ---------------- DRAWER ----------------
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueAccent),
              child: Text(
                'City Guide Menu',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Favorites'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Map'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text('Signup'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (s) => Signup()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('Admin Login'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (s) => AdminLoginApp()));
              },
            ),
             ListTile(
              leading: const Icon(Icons.admin_panel_settings),
              title: const Text('User Profile'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (s) => UserProfile()));
              },
            ),
          ],
        ),
      ),

      // ---------------- BODY ----------------
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CATEGORY BAR
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // FEATURED SLIDER
          CarouselSlider.builder(
            itemCount: featuredImages.length,
            itemBuilder: (context, index, realIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    Image.network(
                      featuredImages[index],
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      child: Text(
                        "Featured Attraction ${index + 1}",
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
            options: CarouselOptions(
                height: 180,
                autoPlay: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _carouselIndex = index;
                  });
                }),
          ),
          const SizedBox(height: 16),

          // DOT INDICATOR
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: featuredImages.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _carouselIndex == entry.key
                        ? Colors.blueAccent
                        : Colors.grey.shade400),
              );
            }).toList(),
          ),

          // 🔥 FIRESTORE CITY CARDS
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection("cities").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var cityDocs = snapshot.data!.docs;

                // Client-side filter for searchQuery
                if (searchQuery.isNotEmpty) {
                  cityDocs = cityDocs.where((city) {
                    return city['city_name']
                        .toString()
                        .toLowerCase()
                        .contains(searchQuery);
                  }).toList();
                }

                return ListView.builder(
                  itemCount: cityDocs.length,
                  itemBuilder: (context, index) {
                    var city = cityDocs[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CityDetailsPage(
                                city_name: city['city_name'],
                                city_description: city['city_description'],
                                city_image: city['city_image_url'],
                              ),
                            ));
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              child: Image.network(
                                city['city_image_url'],
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                city['city_name'],
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // BOTTOM NAV BAR
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavIndex,
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ---------------- Navigate to CityDetail on enter ----------------
 void _navigateToCityDetail(String query) async {
  final snapshot = await FirebaseFirestore.instance.collection("cities").get();
  
  QueryDocumentSnapshot? matched;

  try {
    matched = snapshot.docs.firstWhere(
      (city) => city['city_name'].toString().toLowerCase() == query.toLowerCase(),
    );
  } catch (e) {
    matched = null; // agar match na ho toh null
  }

  if (matched != null) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CityDetailsPage(
          city_name: matched?['city_name'],
          city_description: matched?['city_description'],
          city_image: matched?['city_image_url'],
        ),
      ),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("City not found!")),
    );
  }
}
}
