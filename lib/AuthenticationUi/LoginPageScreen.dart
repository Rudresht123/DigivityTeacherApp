
import 'package:digivity_admin_app/Authentication/SharedPrefHelper.dart';
import 'package:digivity_admin_app/AuthenticationUi/Loader.dart';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/InputField.dart';
import 'package:digivity_admin_app/Helpers/DeviceToken.dart';
import 'package:digivity_admin_app/Helpers/getApiService.dart';
import 'package:flutter/cupertino.dart';
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


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }


  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schoolData = widget.schoolData;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(schoolData['school_name'] ?? ''),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Scrollable Form
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 120), // Add bottom padding so button doesn't go under image
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(schoolData['school_logo']),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        schoolData['school_name'] ?? '',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Center(
                      child: Text(
                        schoolData['school_address'] ?? '',
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Sign In",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    const Text(
                      'Welcome Back! Please signin to Continue',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Username',
                      hintText: 'Enter your Username',
                      controller: _usernameController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Username is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      label: 'Password',
                      hintText: 'Enter your Password',
                      controller: _passwordController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Password is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (!mounted) return;

                            if (_formKey.currentState!.validate()) {
                              showLoaderDialog(context, message: "Fetching data...");
                              final username = _usernameController.text.trim();
                              final password = _passwordController.text.trim();
                              final url = '${schoolData['base_url']}/api/MobileApp/login/$username/$password';

                              try {
                                final data = await getApiService.getApiServiceForLogin(url);

                                if (!mounted) return;
                                hideLoaderDialog(context);

                                Map<String, dynamic> userData = {};
                                for (var item in data['success']) {
                                  userData[item['key']] = item['value'];
                                }

                                userData['base_url'] = schoolData['base_url'];
                                userData['isLogin'] = true;

                                if (userData['role']!='teacher') {
                                  showBottomMessage(context, "Invalid User!", true);
                                  return;
                                }

                                // Save data before navigating
                                await SharedPrefHelper.storeSuccessData(userData);

                                try {
                                  await DeviceToken().getDeviceToken();
                                } catch (e) {
                                  debugPrint("Error generating device token: $e");
                                }

                                if (!mounted) return;
                                // Navigate *after* all async work
                                context.goNamed('dashboard');

                              } catch (e) {
                                if (!mounted) return;
                                hideLoaderDialog(context);
                                showBottomMessage(context, "Error: $e", true);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text('Login', style: TextStyle(fontSize: 20)),
                              SizedBox(width: 10),
                              Icon(Icons.key, size: 24),
                            ],
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom I
        ],
      ),
    );
  }
}

