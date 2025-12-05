import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:registration/dashboard.dart';

import 'package:registration/firebase_options.dart';
import 'package:registration/forgetpassword.dart';
import 'package:registration/register.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const login());
}

class login extends StatelessWidget {
  const login({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
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
  TextEditingController email = TextEditingController();
  TextEditingController pswd = TextEditingController();

  void show_msg(String m){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }
  void add_user()async{
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      final email_regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
      final psw_regex = RegExp(r'^.{8,}$');

      if( email.text.isEmpty || pswd.text.isEmpty){
        show_msg("All Fields are Required");
        return;
      }
      if(!email_regex.hasMatch(email.text)){
        show_msg("Email is Invalid");
        return;
      }
      if (!psw_regex.hasMatch(pswd.text)) {
        show_msg("Password is Inavlid");
        return;
      }

      UserCredential userdata = await auth.signInWithEmailAndPassword(
        email: email.text,
         password: pswd.text);
         if (!userdata.user!.emailVerified) {
           await auth.signOut();
           show_msg("Verify Email First");
           return;
         }else{
          show_msg("Login Successfully");
          Navigator.push(context, MaterialPageRoute(builder: (a)=>dashboard()));
         }
    } on FirebaseAuthException catch(e){
      show_msg("Firebase : " + e.toString());
      print(e.toString());
    }
     catch (e) {
      show_msg("Error: " + e.toString());
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Login Yourself", style: TextStyle(fontSize: 24)),

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
            OutlinedButton.icon(
              onPressed: () {
                add_user();
              },
              label: Text("Login"),
              icon: Icon(Icons.app_registration),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>Register()));
                }, child: Text("Don't have an Account",
                style: TextStyle(color: Colors.greenAccent),)),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (builder)=>ForgetPassword()));
                }, child: Text("Forget Password",
                style: TextStyle(color: Colors.red),)),
            )
          ],
        ),
    ));
  }
}