import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project/sign_in.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'sign_in.dart' show SignIn;

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "img-project/doctor.jpeg",
      "title": "Need a doctor?",
      "desc": "Get expert care anytime, anywhere!",
    },
    {
      "image": "img-project/Healthy_food.jpeg",
      "title": "Healthy food",
      "desc": "Eat well, move more, live better!",
    },
    {
      "image": "img-project/mental_health.jpeg",
      "title": "Take a deep breath ",
      "desc": "Your well-being starts here! ",
    },
    {
      "image": "img-project/journey.jpeg",
      "title": "Fitness Journey",
      "desc": "Your fitness journey starts now - let's go!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 202, 231, 255),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 7,
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                itemBuilder: (context, index) {
                  final data = onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: Image.asset(
                            data['image']!,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          data['title']!,
                          style: GoogleFonts.nunito(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0D273D),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          data['desc']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(fontSize: 19),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            if (index < onboardingData.length - 1) {
                              _controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignIn()
                                ),
                              );
                            }
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xff0D273D),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            index == onboardingData.length - 1
                                ? "GET STARTED"
                                : "NEXT",
                            style: GoogleFonts.nunito(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SmoothPageIndicator(
              controller: _controller,
              count: onboardingData.length,
              effect: WormEffect(
                dotColor: Colors.white,
                activeDotColor: const Color(0xff0D273D),
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
