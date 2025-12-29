import 'package:citiguide/firebase_options.dart';
import 'package:citiguide/showcategories.dart';
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
      builder: (context) => AddCategories(),
    ),
  );
}

class AddCategories extends StatelessWidget {
  const AddCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const AddCategoriesPage(title: 'Add Categories'),
    );
  }
}

class AddCategoriesPage extends StatefulWidget {
  const AddCategoriesPage({super.key, required this.title});
  final String title;

  @override
  State<AddCategoriesPage> createState() => _AddCategoriesPageState();
}

class _AddCategoriesPageState extends State<AddCategoriesPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void addCategory() async {
    String name = nameController.text.trim();
    String image = imageController.text.trim();
    String description = descriptionController.text.trim();

    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      if (name.isEmpty || image.isEmpty || description.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("All fields are required"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await db.collection("categories").add({
        "name": name,
        "imageUrl": image,
        "description": description,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Category Added Successfully"),
          backgroundColor: Colors.green,
        ),
      );

      clearFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void clearFields() {
    nameController.clear();
    imageController.clear();
    descriptionController.clear();
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
            const Text(
              "Add Categories",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            textField("Category Name", nameController, Icons.category),
            textField("Category Image URL", imageController, Icons.image),
            textField("Category Description", descriptionController, Icons.description),

            ElevatedButton(
              onPressed: addCategory,
              child: const Text("Submit"),
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (a) => ShowCategories()));
        },
        child: const Icon(Icons.remove_red_eye),
      ),
    );
  }

  Widget textField(String label, TextEditingController ctrl, IconData icon) {
    return Container(
      margin: const EdgeInsets.all(10),
      constraints: const BoxConstraints(maxWidth: 250),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: label,
          suffixIcon: Icon(icon),
        ),
      ),
    );
  }
}