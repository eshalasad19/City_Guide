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
    builder: (context) => Signup(), // Wrap your app
  ));
}


class Signup extends StatelessWidget {
  const Signup({super.key});
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
 TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pswd = TextEditingController();
  TextEditingController cpswd = TextEditingController();
  TextEditingController age = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Register Yourself", style: TextStyle(fontSize: 24)),
            Container(
              margin: EdgeInsets.all(10),
              constraints: BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Name",
                  suffixIcon: Icon(Icons.person),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(10),

              constraints: BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Email",
                  suffixIcon: Icon(Icons.email),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(10),

              constraints: BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: pswd,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Password",
                  suffixIcon: Icon(Icons.password),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),

              constraints: BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: cpswd,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Confirm Your Password",
                  suffixIcon: Icon(Icons.password),
                ),
              ),
            ),

            Container(
              margin: EdgeInsets.all(10),

              constraints: BoxConstraints(maxWidth: 300),
              child: TextField(
                controller: age,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter Your Age",
                  suffixIcon: Icon(Icons.cake),
                ),
              ),
            ),

            OutlinedButton.icon(
              onPressed: () {
                // add_user();
              },
              label: Text("Signup"),
              icon: Icon(Icons.app_registration),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: (){
                  // Navigator.push(context, MaterialPageRoute(builder: (builder)=>eshal_login()));
                }, child: Text("Already Have an Account", style: TextStyle(color: Colors.blue),)),
            )
          ],
        ),
    ));
  }
}
