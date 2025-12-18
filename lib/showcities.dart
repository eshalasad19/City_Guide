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
    builder: (context) => showcities(), // Wrap your app
  ));
}




class showcities extends StatelessWidget {
  const showcities({super.key});
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          
    )));
  }
}

 

 
  @override
  Widget build(BuildContext context, dynamic widget) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
       
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
