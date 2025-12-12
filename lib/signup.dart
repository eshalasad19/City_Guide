import 'package:citiguide/firebase_options.dart';
import 'package:citiguide/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      builder: (context) => Signup(),
    ),
  );
}

class Signup extends StatelessWidget {
  const Signup({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2563EB),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color(0xFF2563EB),
          brightness: Brightness.dark,
        ),
      ),
      home: const MyHomePage(title: 'City Guide Registration'),
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
  // Dummy image URL to use if the user does not provide one
  static const String _defaultProfileImageUrl =
      "https://firebasestorage.googleapis.com/v0/b/flutter-chat-app-2024.appspot.com/o/default_profile.png?alt=media&token=c4a9a0e1-4b1f-4d3e-9f0e-3b2e4f0d2a1b";
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController pswd = TextEditingController();
  TextEditingController cpswd = TextEditingController();
  TextEditingController profileImageUrl = TextEditingController(); // New controller for URL
  bool _isLoading = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  void show_msg(String m) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(m),
        backgroundColor: Colors.grey[800],
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // Auto close dialog after 3 seconds
        Future.delayed(Duration(seconds: 3), () {
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            _redirectToLogin();
          }
        });

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Success Icon with animation
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF10B981),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF10B981).withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 24),
                  
                  // Title
                  Text(
                    "Registration Successful!",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[900],
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 12),
                  
                  // Message
                  Text(
                    "Your account has been created successfully. A verification email has been sent to your email address.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      letterSpacing: 0.3,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  
                  // Progress indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: Colors.grey[300],
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Redirecting to login...",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _redirectToLogin() {
    // TODO: Uncomment and modify to navigate to your login page
    // Navigator.of(context).pushReplacementNamed('/login');
    // OR
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
    
    // For now, showing a message
    show_msg("Redirecting to login page...");
  }

  void add_user() async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;
      FirebaseAuth auth = FirebaseAuth.instance;
      final name_regex = RegExp(r"^[a-zA-Z0-9_-]{3,15}$");
      final email_regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
      final psw_regex = RegExp(r'^.{8,}$');

      if (name.text.isEmpty || email.text.isEmpty || pswd.text.isEmpty || cpswd.text.isEmpty) {
        show_msg("All Fields are Required");
        return;
      }
      if (pswd.text != cpswd.text) {
        show_msg("Password Doesn't Match");
        return;
      }
      if (!name_regex.hasMatch(name.text)) {
        show_msg("Name is Invalid");
        return;
      }
      if (!email_regex.hasMatch(email.text)) {
        show_msg("Email is Invalid");
        return;
      }
      if (!psw_regex.hasMatch(pswd.text)) {
        show_msg("Password is Invalid");
        return;
      }

      setState(() => _isLoading = true);

      UserCredential userdata = await auth.createUserWithEmailAndPassword(
        email: email.text,
        password: pswd.text,
      );

      // Determine the final profile image URL
      // Determine the final profile image URL with fallback logic
      final String finalProfileUrl = profileImageUrl.text.trim().isNotEmpty
          ? profileImageUrl.text.trim()
          : _defaultProfileImageUrl;

      // 1. Save user data to Firestore, including the profile image URL
      await db.collection("Register").doc(userdata.user!.uid).set({
        "Name": name.text,
        "Email": email.text,
        "ProfileImageUrl": finalProfileUrl, // New field with fallback logic
        "Created_At": DateTime.now()
      });

      // 2. Update Firebase Auth profile (optional but good practice)
      await userdata.user!.updateDisplayName(name.text);
      await userdata.user!.updatePhotoURL(finalProfileUrl);

      await userdata.user?.sendEmailVerification();
      
      // Show success dialog
      _showSuccessDialog();

      name.clear();
      email.clear();
      pswd.clear();
      cpswd.clear();
      profileImageUrl.clear();
    } on FirebaseAuthException catch (e) {
      show_msg("Firebase : " + e.toString());
      print(e.toString());
    } catch (e) {
      show_msg("Error: " + e.toString());
      print(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [Color(0xFF1a1a2e), Color(0xFF16213e)]
                : [Color(0xFF2563EB), Color(0xFF1e40af)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header Section
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.15),
                    ),
                    child: Icon(
                      Icons.location_city,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Welcome to City Guide",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Create your account",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                      letterSpacing: 0.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),

                  // Form Container
                  Container(
                    constraints: BoxConstraints(maxWidth: 380),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Color(0xFF2a2a3e) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(24),
                    child: Column(
                      children: [
                       // Name Field
                        _buildInputField(
                          controller: name,
                          label: "Full Name",
                          icon: Icons.person_outline,
                          hint: "Enter your full name",
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 20),

                        // Profile Picture URL Field
                        _buildInputField(
                          controller: profileImageUrl,
                          label: "Profile Picture URL (Optional)",
                          icon: Icons.link,
                          hint: "Paste image URL here",
                          keyboardType: TextInputType.url,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 20),

                        // Email Field
                        _buildInputField(
                          controller: email,
                          label: "Email Address",
                          icon: Icons.email_outlined,
                          hint: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 14),

                        // Password Field
                        _buildPasswordField(
                          controller: pswd,
                          label: "Password",
                          hint: "Enter your password",
                          isVisible: _showPassword,
                          onToggle: () {
                            setState(() => _showPassword = !_showPassword);
                          },
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 14),

                        // Confirm Password Field
                        _buildPasswordField(
                          controller: cpswd,
                          label: "Confirm Password",
                          hint: "Confirm your password",
                          isVisible: _showConfirmPassword,
                          onToggle: () {
                            setState(() => _showConfirmPassword = !_showConfirmPassword);
                          },
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 20),

                        // Signup Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : add_user,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF2563EB),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            icon: _isLoading
                                ? SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Icon(Icons.app_registration, size: 18),
                            label: Text(
                              _isLoading ? "Creating..." : "Sign Up",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        // Login Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Have an account? ",
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (builder)=> LoginPage()));
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "Sign In",
                                style: TextStyle(
                                  color: Color(0xFF2563EB),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.grey[800],
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 14,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
            ),
            prefixIcon: Icon(
              icon,
              color: Color(0xFF2563EB),
              size: 18,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: Color(0xFF2563EB),
                width: 2,
              ),
            ),
            filled: true,
            fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool isVisible,
    required VoidCallback onToggle,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.grey[800],
            letterSpacing: 0.3,
          ),
        ),
        SizedBox(height: 6),
        StatefulBuilder(
          builder: (context, setState) {
            return TextField(
              controller: controller,
              obscureText: !isVisible,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
                ),
                prefixIcon: Icon(
                  Icons.lock_outline,
                  color: Color(0xFF2563EB),
                  size: 18,
                ),
                suffixIcon: GestureDetector(
                  onTap: onToggle,
                  child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Icon(
                      isVisible ? Icons.visibility : Icons.visibility_off,
                      color: Color(0xFF2563EB),
                      size: 18,
                    ),
                  ),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF2563EB),
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    pswd.dispose();
    cpswd.dispose();
    profileImageUrl.dispose();
    super.dispose();
  }
}