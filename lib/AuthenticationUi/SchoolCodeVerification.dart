import 'package:digivity_admin_app/Authentication/getSchoolData.dart';
import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:go_router/go_router.dart';
import 'CustomAnimatedWidget.dart';
import 'Loader.dart';
import 'UpperCaseTextFormatter.dart';


class SchoolCodeVerification extends StatefulWidget {
  const SchoolCodeVerification({super.key});

  @override
  State<SchoolCodeVerification> createState() => _SchoolCodeVerificationState();
}

class _SchoolCodeVerificationState extends State<SchoolCodeVerification> {
  final TextEditingController _schoolCodeController = TextEditingController();
  final FocusNode _pinFocus = FocusNode();
  bool _busy = false;

  @override
  void dispose() {
    _pinFocus.dispose();
    _schoolCodeController.dispose();
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
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            const SnackBar(content: Text('Please enter a code')),
          );
        }
        return;
      }

      final data = await getSchoolData(code);
      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).maybePop();

      if (data['success'] is List && data['success'].isNotEmpty) {
        final schoolData = data['success'][0];
        _schoolCodeController.clear();
        FocusManager.instance.primaryFocus?.unfocus();
        context.pushNamed('login', extra: schoolData);
      } else {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(content: Text('No school data found')),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).maybePop();
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body:Column(
        children: [
          Image.asset(
            'assets/logos/top2.png',
            width: width * 0.5,
            fit: BoxFit.contain,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.05,
                  vertical: height * 0.05,
                ),
                child: CustomAnimatedWidget(
                  beginOffset: const Offset(0, 1),
                  duration: const Duration(seconds: 2),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logos/digivity_logo.png',
                        width: width * 0.4,
                      ),
                      SizedBox(height: height * 0.025),
                      Text(
                        "School Verification",
                        style: TextStyle(
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: height * 0.025),
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: _schoolCodeController,
                        focusNode: _pinFocus,
                        autoFocus: true,
                        animationType: AnimationType.fade,
                        keyboardType: TextInputType.text,
                        inputFormatters: [UpperCaseTextFormatter()],
                        textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                        enableActiveFill: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: width * 0.13,
                          fieldWidth: width * 0.13,
                          inactiveColor: Colors.grey,
                          selectedColor: const Color(0xFF176CE1),
                          activeColor: const Color(0xFF176CE1),
                          activeFillColor: Colors.black,
                          selectedFillColor: Colors.black,
                          inactiveFillColor: Colors.white,
                        ),
                        onChanged: (_) {},
                      ),
                      SizedBox(height: height * 0.025),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _busy ? null : _verify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF176CE1),
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.02,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (_busy) ...[
                                SizedBox(
                                  width: width * 0.045,
                                  height: width * 0.045,
                                  child: const CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: width * 0.03),
                              ],
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
                                Icons.arrow_right_alt_outlined,
                                color: Colors.white,
                                size: width * 0.08,
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
          ),
        ],
      ),
    );
  }
}
