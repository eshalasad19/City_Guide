import 'package:citiguide/firebase_options.dart';
import 'package:citiguide/showcities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      builder: (context) => Addcities(),
    ),
  );
}

class Addcities extends StatelessWidget {
  const Addcities({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const MyHomePage(title: 'Add Cities'),
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
  TextEditingController city_name = TextEditingController();
  TextEditingController city_image = TextEditingController();
  TextEditingController city_description = TextEditingController();

  void add_data() async {
    String name = city_name.text.trim();
    String image = city_image.text.trim();
    String description = city_description.text.trim();

    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      if (name == "" || description == "" || image == "") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("All fields are required"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await db.collection("cities").add({
        
        "city_name": name,
        "city_description": description,
        "city_image_url": image,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("City Added Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      clr_text();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void clr_text() {
    city_name.text = "";
    city_image.text = "";
    city_description.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Add Cities",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            // CITY NAME
            textField("City Name", city_name, Icons.location_city),

            // CITY IMAGE
            textField("City Image ", city_image, Icons.image),

            // DESCRIPTION
            textField("City Description", city_description, Icons.description),

            ElevatedButton(
              onPressed: add_data,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (a) => showcities()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget textField(String label, TextEditingController ctrl, IconData icon) {
    return Container(
      margin: EdgeInsets.all(10),
      constraints: BoxConstraints(maxWidth: 250),
      child: TextField(
        controller: ctrl,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: label,
          labelText: label,
          suffixIcon: Icon(icon),
        ),
      ),
    );
  }
}

