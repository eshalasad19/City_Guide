import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:citiguide/firebase_options.dart';
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
      builder: (context) => const ShowCategories(),
    ),
  );
}

class ShowCategories extends StatelessWidget {
  const ShowCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: const CategoriesScreen(title: 'Categories Demo'),
    );
  }
}

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, required this.title});
  final String title;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  // Delete Function
  void deleteCategory(String id) {
    FirebaseFirestore.instance.collection("categories").doc(id).delete();
  }

  // Edit Dialog
  void editCategory(BuildContext context, String id, String name, String image, String description) {
    TextEditingController nameCtrl = TextEditingController(text: name);
    TextEditingController imageCtrl = TextEditingController(text: image);
    TextEditingController descCtrl = TextEditingController(text: description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Category"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: InputDecoration(labelText: "Name")),
              TextField(controller: imageCtrl, decoration: InputDecoration(labelText: "Image URL")),
              TextField(controller: descCtrl, decoration: InputDecoration(labelText: "Description")),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {
                FirebaseFirestore.instance.collection("categories").doc(id).update({
                  "name": nameCtrl.text.trim(),
                  "imageUrl": imageCtrl.text.trim(),
                  "description": descCtrl.text.trim(),
                });

                Navigator.pop(context);
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No categories found"));
          }

          var categoryDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categoryDocs.length,
            itemBuilder: (context, index) {
              var data = categoryDocs[index];
              String id = data.id;

              String name = data['name'] ?? 'No Name';
              String imageUrl = data['imageUrl'] ?? '';
              String description = data['description'] ?? 'No Description';

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: imageUrl.isNotEmpty
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(imageUrl),
                          radius: 25,
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.image_not_supported),
                        ),

                  title: Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(description),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // EDIT BUTTON
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          editCategory(context, id, name, imageUrl, description);
                        },
                      ),

                      // DELETE BUTTON
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          deleteCategory(id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}