import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:citiguide/Home.dart';  // Ensure this file is available
import 'package:firebase_core/firebase_core.dart';
import 'package:citiguide/firebase_options.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6a11cb), Color(0xff2575fc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie animation for better visuals
            SizedBox(
              height: 250,
              child: Lottie.network(
                'https://assets3.lottiefiles.com/packages/lf20_r6yln6kk.json',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, size: 50, color: Colors.white);
                },
              ),
            ),
            const SizedBox(height: 30),

            // App Name with bold styling
            const Text(
              "CitiGuide",
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.5,
              ),
            ),

            const SizedBox(height: 15),

            // App tagline to emphasize the app's purpose
            const Text(
              "Explore Your City Like Never Before",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),

            const SizedBox(height: 40),

            // Another loading animation to keep things lively
            Lottie.network(
              "https://lottie.host/5e9c63fc-6b5a-428b-8f40-d4e634ba1181/tZJkRuM3a2.json",
              height: 80,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 50, color: Colors.white);
              },
            ),
          ],
        ),
      ),
    );
  }
}
