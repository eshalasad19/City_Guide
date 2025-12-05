import 'package:citiguide/Home.dart';
import 'package:citiguide/forgetPassword.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool _isLoading = false;
  bool _showPassword = false;

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
        // Auto close dialog after 2 seconds
        Future.delayed(Duration(seconds: 2), () {
          if (mounted && Navigator.of(context).canPop()) {
            Navigator.of(context).pop();
            // Navigate to home page or dashboard
            Navigator.of(context).push(MaterialPageRoute(builder: (h) => Home()));
            show_msg("Login successful! Redirecting to home...");
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
                    "Login Successful!",
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
                    "Welcome back to City Guide!",
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
                    "Redirecting...",
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

  void login_user() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      final email_regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");

      if (email.text.isEmpty || password.text.isEmpty) {
        show_msg("All Fields are Required");
        return;
      }

      if (!email_regex.hasMatch(email.text)) {
        show_msg("Email is Invalid");
        return;
      }

      if (password.text.length < 8) {
        show_msg("Password must be at least 8 characters");
        return;
      }

      setState(() => _isLoading = true);

      UserCredential userdata = await auth.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );

      // Check if email is verified
      if (!userdata.user!.emailVerified) {
        show_msg("Please verify your email first");
        await auth.signOut();
        setState(() => _isLoading = false);
        return;
      }

      // Show success dialog
      _showSuccessDialog();

      email.clear();
      password.clear();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        show_msg("No user found with this email");
      } else if (e.code == 'wrong-password') {
        show_msg("Wrong password provided");
      } else if (e.code == 'invalid-email') {
        show_msg("Invalid email address");
      } else {
        show_msg("Firebase Error: " + e.message.toString());
      }
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
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Login to your account",
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
                        // Email Field
                        _buildInputField(
                          controller: email,
                          label: "Email Address",
                          icon: Icons.email_outlined,
                          hint: "Enter your email",
                          keyboardType: TextInputType.emailAddress,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 18),

                        // Password Field
                        _buildPasswordField(
                          controller: password,
                          label: "Password",
                          hint: "Enter your password",
                          isVisible: _showPassword,
                          onToggle: () {
                            setState(() => _showPassword = !_showPassword);
                          },
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(height: 12),

                        // Forgot Password Link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (f) => ForgotPasswordPage()));
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                color: Color(0xFF2563EB),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),

                        // Login Button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : login_user,
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
                                : Icon(Icons.login, size: 18),
                            label: Text(
                              _isLoading ? "Logging in..." : "Login",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Divider
                        Row(
                          children: [
                            Expanded(child: Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300])),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "or",
                                style: TextStyle(
                                  color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: isDarkMode ? Colors.grey[700] : Colors.grey[300])),
                          ],
                        ),
                        SizedBox(height: 16),

                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // TODO: Navigate to registration page
                                // Navigator.push(context, MaterialPageRoute(builder: (builder)=>Signup()));
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                "Sign Up",
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
    email.dispose();
    password.dispose();
    super.dispose();
  }
}
