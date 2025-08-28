import 'dart:async';

import 'package:digivity_admin_app/Components/BackgrounWeapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool onLastPage = false;

  final List<Map<String, String>> slides = [
    {
      "image": "assets/images/logos/security_alert.png", // Replace with your image
      "title": "Security",
      "desc": "We use advanced encryption and secure protocols to protect your data at every step. Rest assured, your personal information stays safe with us — always."
    },
    {
      "image": "assets/images/logos/user_frendely.jpeg", // Replace with your image
      "title": "User Friendly",
      "desc": "Simple and attractive user interface, enriched with modern, intuitive and easy-to-use GUI components."
    },
    {
      "image": "assets/images/logos/compatibility.jpeg",
      "title": "Seamless Compatibility",
      "desc": "Our app is optimized to run smoothly on all major platforms and screen sizes. Whether you use Android, iOS, or the web — your experience stays consistent and reliable."
    },
    {
      "image": "assets/images/logos/compre.jpeg",
      "title": "Comprehensive Features",
      "desc": "From user-friendly tools to advanced functionalities, everything you need is built-in. Experience a complete solution tailored to meet all your needs in one place."
    },
    {
      "image": "assets/images/logos/pepreless.jpeg",
      "title": "Paperless Efficiency",
      "desc": "Say goodbye to paperwork — manage everything digitally with ease and security. Fast, eco-friendly, and accessible anytime, anywhere."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == slides.length - 1;
              });
            },
            itemBuilder: (context, index) {
              return BackgroundWrapper(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(16), // Give space around the container for the shadow to appear

                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10), // Match the outer border radius
                        child: Image.asset(
                          slides[index]["image"]!,
                          width: double.infinity,

                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      slides[index]["title"]!,
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 15),
                    Text(
                      slides[index]["desc"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ));
            },
          ),

          // Skip button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: () {
                context.pushNamed('schoolCodeVerification');
              },
              child: Row(
                children: [
                  Text("Skip", style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 15)),
                  Icon(Icons.arrow_forward,color: Colors.blue,)
                ],
              ),
            ),
          ),

          // Dot indicator + next/done
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: slides.length,
                  effect: WormEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Colors.blue,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (onLastPage) {
                      context.pushNamed('schoolCodeVerification');
                    } else {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeIn);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // So it wraps content only
                    children: [
                      Text(
                        onLastPage ? "Get Started" : "Next",
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(width: 8), // spacing between text and icon
                      Icon(
                        onLastPage ? Icons.arrow_forward : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ],
                  ),

                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
