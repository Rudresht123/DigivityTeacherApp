import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BouncingBubble.dart';
import 'package:digivity_admin_app/Helpers/DeviceToken.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPageScreen extends StatefulWidget {
  final Map<String, dynamic> schoolData;
  const LoginPageScreen({required this.schoolData, super.key});

  @override
  State<LoginPageScreen> createState() => _LoginPageScreenState();
}

class _LoginPageScreenState extends State<LoginPageScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Bubble Widget

  @override
  Widget build(BuildContext context) {
    final schoolData = widget.schoolData;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;



    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [

          // Gradient Background same as SchoolCodeVerification
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade200, Colors.purple.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // Floating bubbles
          BouncingBubble(
            size: 60,
            left: width * 0.2,
            top: height * 0.1,
            color: Colors.purple,
          ),
          BouncingBubble(
            size: 80,
            left: width * 0.7,
            top: height * 0.2,
            color: Colors.blue,
            bounceHeight: 20, // optional
            duration: Duration(seconds: 3), // optional
          ),
          BouncingBubble(
            size: 40,
            left: width * 0.5,
            top: height * 0.33,
            color: Colors.purpleAccent,
          ),
          BouncingBubble(
            size: 50,
            left: width * 0.1,
            top: height * 0.5,
            color: Colors.blueAccent,
          ),

          BouncingBubble(
            size: 60,
            left: width * 0.1,
            top: height * 0.9,
            color: Colors.purple,
          ),
          BouncingBubble(
            size: 80,
            left: width * 0.4,
            top: height * 0.8,
            color: Colors.blue,
          ),
          BouncingBubble(
            size: 40,
            left: width * 0.6,
            top: height * 0.7,
            color: Colors.purpleAccent,
          ),
          BouncingBubble(
            size: 50,
            left: width * 0.8,
            top: height * 0.9,
            color: Colors.blueAccent,
          ),

          // Login Form
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.06,
                vertical: height * 0.05,
              ),
              child: Column(
                children: [
                  // School Logo
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(schoolData['school_logo']),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: height * 0.02),
                  Text(
                    schoolData['school_name'] ?? '',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: height * 0.005),
                  Text(
                    schoolData['school_address'] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: height * 0.05),

                  // Card Container
                  Container(
                    padding: EdgeInsets.all(width * 0.06),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Sign In",
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "Welcome back! Please sign in to continue.",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),

                          // Username Field
                          TextFormField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              hintText: 'Enter your username',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: const Icon(Icons.person),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Username is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              hintText: 'Enter your password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),

                          // Login Button
                          // State variable
                          ElevatedButton(
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (!mounted) return;

                                    if (_formKey.currentState!.validate()) {
                                      showLoaderDialog(
                                        context,
                                        message: "Fetching data...",
                                      );
                                      final username = _usernameController.text
                                          .trim();
                                      final password = _passwordController.text
                                          .trim();
                                      final url =
                                          '${schoolData['base_url']}/api/MobileApp/login/$username/$password';

                                      try {
                                        final data = await getApiService
                                            .getApiServiceForLogin(url);

                                        if (!mounted) return;

                                        Map<String, dynamic> userData = {};
                                        for (var item in data['success']) {
                                          userData[item['key']] = item['value'];
                                        }

                                        userData['base_url'] =
                                            schoolData['base_url'];
                                        userData['isLogin'] = true;

                                        if (userData['role'] == 'admin' || userData['role'] == 'master-admin' || userData['role'] == 'student') {
                                          showBottomMessage(
                                            context,
                                            "Invalid User!",
                                            true,
                                          );
                                          return;
                                        }

                                        try {
                                          await SharedPrefHelper.storeSuccessData(
                                            userData,
                                          );
                                        } catch (e) {
                                          showBottomMessage(
                                            context,
                                            "${e}",
                                            true,
                                          );
                                        }
                                        try {
                                          await DeviceToken()
                                              .registerDeviceToken();
                                        } catch (e) {
                                          debugPrint(
                                            "Error generating device token: $e",
                                          );
                                        }

                                        if (!mounted) return;
                                        // Navigate after all async work
                                        context.goNamed('dashboard');
                                      } catch (e) {
                                        if (!mounted) return;
                                        hideLoaderDialog(context);
                                        showBottomMessage(
                                          context,
                                          "Error: $e",
                                          true,
                                        );
                                      } finally {
                                        hideLoaderDialog(context);
                                      }
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: height * 0.02,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              backgroundColor: Colors.purple.shade400,
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Verify",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: width * 0.03,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.02),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.white,
                                        size: width * 0.03,
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
