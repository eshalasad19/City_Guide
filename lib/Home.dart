import 'package:citiguide/firebase_options.dart';
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
    builder: (context) => Home(), // Wrap your app
  ));
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  List<Map<String, String>> cities = [
  {
    "name": "Islamabad",
    "image": "https://images.unsplash.com/photo-1617182868231-1bcf3797467d?auto=format&fit=crop&w=800&q=60"
  },
  {
    "name": "Lahore",
    "image": "https://images.unsplash.com/photo-1600508777124-c8decb3b3f2e?auto=format&fit=crop&w=800&q=60"
  },
  {
    "name": "Karachi",
    "image": "https://images.unsplash.com/photo-1595441911256-1b48d26f7a12?auto=format&fit=crop&w=800&q=60"
  },
  {
    "name": "Peshawar",
    "image": "https://images.unsplash.com/photo-1563201517-81f46d1c5bda?auto=format&fit=crop&w=800&q=60"
  },
];

  
 String searchQuery = "";
  
 git push


  @override
  Widget build(BuildContext context) {

   // Filter cities based on search query
    List<Map<String, String>> filteredCities = cities
        .where((city) =>
            city["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

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
            children: const [
              Icon(Icons.search, color: Colors.grey),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Search attractions...",
                  style: TextStyle(color: Colors.grey),
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
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
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
          ],
        ),
      ),

      // ---------------- BODY ----------------
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------------- CATEGORY BAR ----------------
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

            // ---------------- FEATURED SLIDER ----------------
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

            // ---------------- SLIDER INDICATOR ----------------
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
          ],
        ),
      ),

      // ---------------- BOTTOM NAVIGATION ----------------
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
}