
import 'package:citiguide/addattraction.dart';
import 'package:citiguide/addcategories.dart';
import 'package:citiguide/addcities.dart';

import 'package:citiguide/attractiondetail.dart';
import 'package:citiguide/firebase_options.dart';
import 'package:citiguide/showcategories.dart';
import 'package:citiguide/showcities.dart' ;
import 'package:citiguide/showsuers.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => dashboard(),
    ),
  );
}

// ignore: camel_case_types
class dashboard extends StatelessWidget {
  const dashboard({super.key});
  @override

  Widget build(BuildContext context) {
   return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home:  AdminDashboard(),
    );
  }
}


class AdminDashboard extends StatefulWidget {
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String selectedMenu = "dashboard";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      appBar: AppBar(
        title: Text("Admin Dashboard - City Guide"),
      ),
      body: _loadPage(),
    );
  }

  // 🔷 Navigation Drawer
  Drawer _buildDrawer() {
  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(color: Colors.blue),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.admin_panel_settings, size: 50, color: Colors.white),
              SizedBox(height: 10),
              Text("City Guide Admin",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ],
          ),
        ),

        _drawerItem(Icons.dashboard, "Dashboard", "dashboard"),

        // ⭐ CITY DROPDOWN
        ExpansionTile(
          leading: Icon(Icons.location_city),
          title: Text("City"),
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add City"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (s) => Addcities()));
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Show Cities"),
             onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (s) => showcities()));
              },
            ),
          ],
        ),

        // ⭐ ATTRACTION DROPDOWN (NEW)
        ExpansionTile(
          leading: Icon(Icons.place),
          title: Text("Attractions"),
          children: [
            ListTile(
              leading: Icon(Icons.add_location_alt),
              title: Text("Add Attraction"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (s) => AddAttractionPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.list_alt),
              title: Text("Show Attractions"),
             onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (s) => AddAttractionDetail()));
              },
            ),
          ],
        ),
          ExpansionTile(
          leading: Icon(Icons.location_city),
          title: Text("category"),
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Add category"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (s) => AddCategories()));
              },
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: Text("Show category"),
             onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (s) => ShowCategories()));
              },
            ),
          ],
        ),
         ExpansionTile(
          leading: Icon(Icons.location_city),
          title: Text("Users"),
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text("Show users"),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (s) => ShowUserApp()));
              },
            ),
           
          ],
        ),


        // ⭐ Other Drawer Items
        _drawerItem(Icons.people, "Users", "users"),
        _drawerItem(Icons.reviews, "Reviews", "reviews"),
        _drawerItem(Icons.map, "Maps & Directions", "map"),
        _drawerItem(Icons.search, "Search Analytics", "search"),
        _drawerItem(Icons.notifications, "Notifications", "notifications"),
        _drawerItem(Icons.settings, "Admin Settings", "settings"),
      ],
    ),
  );
}


  ListTile _drawerItem(IconData icon, String title, String id) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        setState(() => selectedMenu = id);
        Navigator.pop(context);
      },
    );
  }

  // 🔷 Load Pages Based on Drawer Selection
  Widget _loadPage() {
    switch (selectedMenu) {
      case "cities":
        return _citiesUI()
        
        
        ;

      case "attractions":
        return _attractionsUI();

      case "users":
        return _usersUI();

      case "reviews":
        return _reviewsUI();

      case "notifications":
        return _notificationUI();

      case "search":
        return _searchUI();

      case "map":
        return _mapUI();

      case "settings":
        return _settingsUI();

      default:
        return _dashboardUI();
    }
  }

  // ---------------------------------------------------------
  // 🔷 DASHBOARD MAIN (Home Cards)
  // ---------------------------------------------------------
  Widget _dashboardUI() {
    final List<Map<String, dynamic>> stats = [
      {"title": "Total Cities", "count": "12", "icon": Icons.location_city},
      {"title": "Attractions", "count": "58", "icon": Icons.place},
      {"title": "Total Users", "count": "4.2K", "icon": Icons.people},
      {"title": "Reviews", "count": "19K", "icon": Icons.reviews},
      {"title": "Pending Requests", "count": "32", "icon": Icons.pending},
      {"title": "Notifications", "count": "120", "icon": Icons.notifications},
    ];

    return Padding(
      padding: EdgeInsets.all(16),
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.3,
        children: stats.map((s) {
          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(s["icon"], size: 40, color: Colors.blue),
                  SizedBox(height: 10),
                  Text(s["count"],
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  Text(s["title"], style: TextStyle(fontSize: 15)),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------
  // 🔷 Cities Screen
  // ---------------------------------------------------------
  Widget _citiesUI() {
    return _simpleUI("Cities Management", Icons.location_city);
  }

  // 🔷 Attractions Screen
  Widget _attractionsUI() {
    return _simpleUI("Attractions Management", Icons.place);
  }

  // 🔷 Users Screen
  Widget _usersUI() {
    return _simpleUI("Users Management", Icons.people);
  }

  // 🔷 Reviews Screen
  Widget _reviewsUI() {
    return _simpleUI("User Reviews & Ratings", Icons.reviews);
  }

  // 🔷 Search Analytics
  Widget _searchUI() {
    return _simpleUI("Search Analytics & Filters", Icons.search);
  }

  // 🔷 Map & Directions
  Widget _mapUI() {
    return _simpleUI("Maps & Directions Management", Icons.map);
  }

  // 🔷 Notifications
  Widget _notificationUI() {
    return _simpleUI("Admin Notifications Center", Icons.notifications);
  }

  // 🔷 Settings
  Widget _settingsUI() {
    return _simpleUI("Admin Settings & Controls", Icons.settings);
  }

  // ---------------------------------------------------------
  // 🔷 UI Template for each page
  // ---------------------------------------------------------
  Widget _simpleUI(String title, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 70, color: Colors.blue),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
