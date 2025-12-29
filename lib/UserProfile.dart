import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:citiguide/Home.dart'; // Assuming this is the next screen after login/splash
import 'package:citiguide/login.dart'; // Assuming this is the login page for redirection
import 'package:firebase_core/firebase_core.dart';
import 'package:citiguide/firebase_options.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';

// --- Global Constants ---
const Color primaryColor = Color(0xFF2563EB);
const Color accentColor = Color(0xFF10B981);

// --- Main Function (as provided by user) ---
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const UserProfile(),
    ),
  );
}

// --- UserProfile (as provided by user) ---
class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'City Guide',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'User Profile'),
    );
  }
}

// --- MyHomePage (Modified to host the ProfilePage) ---
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    // Check if user is logged in, otherwise redirect to login or show a loading screen
    if (FirebaseAuth.instance.currentUser == null) {
      return const Scaffold(
        body: Center(child: Text("Please log in to view your profile.")),
      );
    }
    return const ProfilePage();
  }
}

// --- Profile Page Implementation ---

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Controllers for editable fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  // Preference state
  List<String> _favoriteAttractions = ['Park', 'Museum'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
    _fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // --- Data Fetching ---
  Future<void> _fetchUserData() async {
    if (user == null) return;
    try {
      final doc = await FirebaseFirestore.instance.collection('Register').doc(user!.uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        setState(() {
          _favoriteAttractions = List<String>.from(data['Favorites'] ?? ['Park', 'Museum']);
        });
      }
    } catch (e) {
      _showSnackBar("Error fetching data: $e");
    }
  }

  // --- Update Logic ---
  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      // 1. Update Firebase Auth Profile
      await user!.updateDisplayName(_nameController.text.trim());
      // Note: Email update requires re-authentication, so we skip it here for simplicity.

      // 2. Update Firestore Document
      await FirebaseFirestore.instance.collection('Register').doc(user!.uid).set({
        'Name': _nameController.text.trim(),
        'Email': _emailController.text.trim(), // Storing email in Firestore for consistency
        'Favorites': _favoriteAttractions,
      }, SetOptions(merge: true));

      _showSnackBar("Profile updated successfully!", isError: false);
    } on FirebaseAuthException catch (e) {
      _showSnackBar("Firebase Error: ${e.message}");
    } catch (e) {
      _showSnackBar("Error updating profile: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- Delete Logic ---
  Future<void> _deleteAccount() async {
    if (user == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text("Are you sure you want to delete your account? This action is irreversible."),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Delete", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        setState(() => _isLoading = true);
        // 1. Delete Firestore data
        await FirebaseFirestore.instance.collection('Register').doc(user!.uid).delete();
        
        // 2. Delete Firebase Auth user (Requires re-authentication in a real app)
        await user!.delete();

        _showSnackBar("Account deleted successfully. Redirecting to login.", isError: false);
        // Redirect to login page
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (Route<dynamic> route) => false,
        );
      } on FirebaseAuthException catch (e) {
        _showSnackBar("Error deleting account. Please re-login and try again. Error: ${e.message}");
      } catch (e) {
        _showSnackBar("An unexpected error occurred: $e");
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  // --- Utility Widgets ---
  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : accentColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: primaryColor.withOpacity(0.1),
          backgroundImage: user?.photoURL != null
              ? NetworkImage(user!.photoURL!)
              : null,
          child: user?.photoURL == null
              ? Icon(Icons.person, size: 60, color: primaryColor)
              : null,
        ),
        const SizedBox(height: 12),
        Text(
          user?.displayName ?? 'User Name',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          user?.email ?? 'user@example.com',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: primaryColor),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: readOnly ? Colors.grey[100] : null,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your $label';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Profile"),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildProfileHeader(),
              
              // --- Profile Information Section ---
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Profile Information",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                      ),
                      const Divider(),
                      _buildEditableField(
                        controller: _nameController,
                        label: "Full Name",
                        icon: Icons.person,
                      ),
                      _buildEditableField(
                        controller: _emailController,
                        label: "Email Address",
                        icon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        readOnly: true, // Email is read-only as changing it is complex in Firebase
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- Action Buttons ---
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _updateProfile,
                icon: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Icon(Icons.save),
                label: Text(_isLoading ? "Saving..." : "Update Profile"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 15),

              TextButton.icon(
                onPressed: _isLoading ? null : _deleteAccount,
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                label: const Text("Delete Account", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
