import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:citiguide/Home.dart';
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
  bool _showContent = false;

  @override
  void initState() {
    super.initState();
    // Start the fade-in animation immediately
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _showContent = true;
        });
      }
    });

    // Navigate after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Keeping the user's theme colors for consistency
          gradient: LinearGradient(
            colors: [Color(0xff6a11cb), Color(0xff2575fc)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          // Use AnimatedOpacity for a smooth fade-in of all content
          child: AnimatedOpacity(
            opacity: _showContent ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 800),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo/Lottie for a modern, attractive look
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.5, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  builder: (context, scale, child) {
                    return Transform.scale(
                      scale: scale,
                      child: Lottie.network(
                        // A clean, modern loading animation placeholder
                        'https://lottie.host/5e9c63fc-6b5a-428b-8f40-d4e634ba1181/tZJkRuM3a2.json',
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.location_city, size: 150, color: Colors.white);
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // App Name with bold styling and subtle shadow
                const Text(
                  "CitiGuide",
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black38,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // App tagline with a lighter font for contrast
                const Text(
                  "Explore Your City Like Never Before",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 0.5,
                  ),
                ),

                const SizedBox(height: 50),

                // Clean, simple loading indicator
                const SizedBox(
                  width: 150,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white30,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}