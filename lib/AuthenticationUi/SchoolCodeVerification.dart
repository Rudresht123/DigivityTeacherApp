import 'dart:math';
import 'package:digivity_admin_app/Components/ApiMessageWidget.dart';
import 'package:digivity_admin_app/Components/BouncingBubble.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:go_router/go_router.dart';
import 'CustomAnimatedWidget.dart';
import 'Loader.dart';
import 'UpperCaseTextFormatter.dart';
import 'package:digivity_admin_app/Authentication/getSchoolData.dart';

class SchoolCodeVerification extends StatefulWidget {
  const SchoolCodeVerification({super.key});

  @override
  State<SchoolCodeVerification> createState() => _SchoolCodeVerificationState();
}

class _SchoolCodeVerificationState extends State<SchoolCodeVerification>
    with SingleTickerProviderStateMixin {
  final TextEditingController _schoolCodeController = TextEditingController();
  final FocusNode _pinFocus = FocusNode();
  bool _busy = false;

  late AnimationController _buttonController;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pinFocus.dispose();
    _schoolCodeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (_busy || !mounted) return;
    setState(() => _busy = true);
    FocusManager.instance.primaryFocus?.unfocus();
    showLoaderDialog(context, message: "Fetching data...");

    try {
      final code = _schoolCodeController.text.trim();
      if (code.isEmpty) {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).maybePop();
          showBottomMessage(context, "Please Enter School Code", true);
        }
        return;
      }

      final data = await getSchoolData(code);
      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).maybePop();

      if (data['success'] is List && data['success'].isNotEmpty) {
        final schoolData = data['success'][0];
        _schoolCodeController.clear();
        context.pushNamed('login', extra: schoolData);
      } else {
        showBottomMessage(context, "No School Data Found", true);
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).maybePop();
        showBottomMessage(context, "${e}", true);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
      hideLoaderDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Animated gradient background
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

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06,
                  vertical: height * 0.05,
                ),
                child: Column(
                  children: [
                    // Logo
                    CustomAnimatedWidget(
                      beginOffset: const Offset(0, -0.5),
                      duration: const Duration(milliseconds: 800),
                      child: Image.asset(
                        'assets/logos/digivity_logo.png',
                        width: width * 0.25,
                      ),
                    ),
                    SizedBox(height: height * 0.04),

                    // Title
                    CustomAnimatedWidget(
                      beginOffset: const Offset(0, 0.5),
                      duration: const Duration(milliseconds: 1000),
                      child: Text(
                        "Enter Your School Code",
                        style: TextStyle(
                          fontSize: width * 0.065,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: height * 0.05),

                    // Glassmorphic floating card
                    CustomAnimatedWidget(
                      beginOffset: const Offset(0, 0.5),
                      duration: const Duration(milliseconds: 1200),
                      child: Container(
                        padding: EdgeInsets.all(width * 0.06),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.5),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Animated PIN Field
                            PinCodeTextField(
                              appContext: context,
                              length: 6,
                              controller: _schoolCodeController,
                              focusNode: _pinFocus,
                              autoFocus: true,
                              animationType: AnimationType.scale,
                              keyboardType: TextInputType.text,
                              inputFormatters: [UpperCaseTextFormatter()],
                              textStyle: TextStyle(
                                color: Colors.deepPurple.shade700,
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                              enableActiveFill: true,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(16),
                                fieldHeight: width * 0.10,
                                fieldWidth: width * 0.10,
                                inactiveColor: Colors.grey.shade300,
                                selectedColor: Colors.deepPurple.shade400,
                                activeColor: Colors.deepPurple.shade400,
                                activeFillColor: Colors.purple.shade50
                                    .withOpacity(0.3),
                                selectedFillColor: Colors.purple.shade50
                                    .withOpacity(0.3),
                                inactiveFillColor: Colors.white,
                              ),
                              onChanged: (_) {},
                            ),
                            SizedBox(height: height * 0.04),

                            // Neumorphic Gradient Verify Button
                            GestureDetector(
                              onTapDown: (_) => _buttonController.forward(),
                              onTapUp: (_) => _buttonController.reverse(),
                              onTapCancel: () => _buttonController.reverse(),
                              onTap: _busy ? null : _verify,
                              child: ScaleTransition(
                                scale: _buttonScale,
                                child: Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.symmetric(
                                    vertical: height * 0.02,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.purple.shade400,
                                        Colors.deepPurple.shade600,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.shade200
                                            .withOpacity(0.5),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: _busy
                                        ? SizedBox(
                                            height: width * 0.05,
                                            width: width * 0.05,
                                            child:
                                                const CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 2,
                                                ),
                                          )
                                        : Row(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Verify",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: width * 0.045,
                                                ),
                                              ),
                                              SizedBox(width: width * 0.02),
                                              Icon(
                                                Icons.arrow_forward_ios,
                                                color: Colors.white,
                                                size: width * 0.04,
                                              ),
                                            ],
                                          ),
                                  ),
                                ),
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
          ),
        ],
      ),
    );
  }
}
