import 'package:flutter/material.dart';

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
          // ------------------ TOP BANNER IMAGE ------------------
          SizedBox(
            height: 330,
            width: double.infinity,
            child: Image.network(
              city_image,
              fit: BoxFit.cover,
            ),
          ),

          // ------------- GRADIENT OVERLAY -------------
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

          // ------------------ CITY NAME ------------------
          Positioned(
            left: 20,
            bottom: 80,
            child: Text(
              city_name,
              style: const TextStyle(
                fontSize: 34,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: Offset(2, 2),
                    blurRadius: 6,
                  )
                ],
              ),
            ),
          ),

          // ---------------- BACK BUTTON ----------------
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

          // --------------- WHITE CONTENT AREA ---------------
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

                    // ------------------ CATEGORY BUTTONS ------------------
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _categoryButton(Icons.place, "Attractions"),
                        _categoryButton(Icons.restaurant, "Restaurants"),
                        _categoryButton(Icons.hotel, "Hotels"),
                        _categoryButton(Icons.event, "Events"),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // ---------- ABOUT CITY ----------
                    const Text(
                      "About City",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      city_description,
                      style: const TextStyle(fontSize: 16, height: 1.4),
                    ),

                    const SizedBox(height: 20),

                    // 🔥 POPULAR ATTRACTIONS SECTION
                    _sectionTitle("Popular Attractions"),
                    _itemCard("Famous Park", "https://images.unsplash.com/photo-1501785888041-af3ef285b470"),
                    _itemCard("Historic Museum", "https://images.unsplash.com/photo-1581092795360-3b6c2c1e7f9e"),

                    const SizedBox(height: 20),

                    // 🍔 RESTAURANTS SECTION
                    _sectionTitle("Top Restaurants"),
                    _itemCard("Italian Food Spot", "https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba"),
                    _itemCard("BBQ House", "https://images.unsplash.com/photo-1553621042-f6e147245754"),

                    const SizedBox(height: 20),

                    // 🏨 HOTELS SECTION
                    _sectionTitle("Best Hotels"),
                    _itemCard("Grand Luxury Hotel", "https://images.unsplash.com/photo-1542317854-d09cb1c9e399"),
                    _itemCard("Royal Palace Inn", "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b"),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // CATEGORY BUTTON
  Widget _categoryButton(IconData icon, String label) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 28, color: Colors.blueAccent),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  // SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ITEM CARD
  Widget _itemCard(String name, String imgUrl) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color.fromARGB(255, 177, 90, 90),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
            child: Image.network(
              imgUrl,
              height: 90,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
