import 'package:digivity_admin_app/Components/BouncingBubble.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      "image": "assets/logos/security_alert.png",
      "title": "Security",
      "desc":
          "We use advanced encryption and secure protocols to protect your data at every step. Rest assured, your personal information stays safe with us — always.",
    },
    {
      "image": "assets/logos/user_frendely.jpeg",
      "title": "User Friendly",
      "desc":
          "Simple and attractive user interface, enriched with modern, intuitive and easy-to-use GUI components.",
    },
    {
      "image": "assets/logos/compatibility.jpeg",
      "title": "Seamless Compatibility",
      "desc":
          "Our app is optimized to run smoothly on all major platforms and screen sizes. Whether you use Android, iOS, or the web — your experience stays consistent and reliable.",
    },
    {
      "image": "assets/logos/compre.jpeg",
      "title": "Comprehensive Features",
      "desc":
          "From user-friendly tools to advanced functionalities, everything you need is built-in. Experience a complete solution tailored to meet all your needs in one place.",
    },
    {
      "image": "assets/logos/pepreless.jpeg",
      "title": "Paperless Efficiency",
      "desc":
          "Say goodbye to paperwork — manage everything digitally with ease and security. Fast, eco-friendly, and accessible anytime, anywhere.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          // Background gradient (same as SchoolCodeVerification)
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
            left: Checkbox.width * 0.2,
            top: kToolbarHeight * 0.1,
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

          PageView.builder(
            controller: _controller,
            itemCount: slides.length,
            onPageChanged: (index) {
              setState(() {
                onLastPage = index == slides.length - 1;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Card-style image container
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          slides[index]["image"]!,
                          height: 220,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      slides[index]["title"]!,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.1,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      slides[index]["desc"]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.9),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Skip button
          Positioned(
            top: 50,
            right: 20,
            child: TextButton.icon(
              onPressed: () {
                context.pushNamed('schoolCodeVerification');
              },
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
              label: const Text(
                "Skip",
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          // Indicator + button
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmoothPageIndicator(
                  controller: _controller,
                  count: slides.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    activeDotColor: Colors.white,
                    dotColor: Colors.white38,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (onLastPage) {
                      context.pushNamed('schoolCodeVerification');
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                  ),
                  child: Row(
                    children: [
                      Text(
                        onLastPage ? "Get Started" : "Next",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
