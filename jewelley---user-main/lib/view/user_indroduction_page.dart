import 'package:flutter/material.dart';
import 'package:jewellery_app/view/user_module/login/page/user_login.dart';
import 'package:jewellery_app/view/utils/prefence_value.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingPagePresenter(pages: [
  OnboardingPageModel(
    title: 'Timeless Elegance,\nJust a Click Away',
    description: 'Explore a dazzling collection of Gold, Platinum, and Silver jewelry, crafted to perfection.',
    imageUrl: 'assets/images/introd3.png', // Replace with a jewelry-related image
    bgColor:  Color.fromARGB(255, 247, 246, 248),
    subtitle: const Color.fromARGB(255, 175, 60, 143),
  ),
  OnboardingPageModel(
    title: 'Pure Luxury,Authentic\n     Craftsmanship',
    description: 'Every piece tells a story of elegance, tradition, and innovation. Find your perfect match today!',
    imageUrl: 'assets/images/introd1.png', // Replace with a relevant image
    bgColor:  Color.fromARGB(255, 249, 246, 250),
    subtitle: const Color.fromARGB(255, 153, 21, 124),
  ),
  OnboardingPageModel(
    title: 'Exclusive Collections,\nHandpicked for You',
    description: 'From daily wear to grand celebrations, discover jewelry that complements every occasion.',
    imageUrl: 'assets/images/introd5.png', // Replace with a jewelry showcase image
    bgColor: const Color.fromARGB(255, 250, 249, 250),
     subtitle: const Color.fromARGB(255, 176, 47, 149),
  ),
  OnboardingPageModel(
    title: 'Certified Purity &\nSecure Shopping',
    description: 'Shop with confidence—our gold, platinum, and silver collections come with authenticity guarantees.',
    imageUrl: 'assets/images/introd4.png', // Replace with a trust or security-related image
    bgColor: const Color.fromARGB(255, 250, 247, 251),
     subtitle: const Color.fromARGB(255, 136, 25, 125),
  ),
]),

    );
  }
}

class OnboardingPagePresenter extends StatefulWidget {
  final List<OnboardingPageModel> pages;
  final VoidCallback? onSkip;
  final VoidCallback? onFinish;

  const OnboardingPagePresenter(
      {super.key, required this.pages, this.onSkip, this.onFinish});

  @override
  State<OnboardingPagePresenter> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPagePresenter> {
  // Store the currently visible page
  int _currentPage = 0;
  // Define a controller for the pageview
  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        color: widget.pages[_currentPage].bgColor,
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                // Pageview to render each page
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: widget.pages.length,
                  onPageChanged: (idx) {
                    // Change current page when pageview changes
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemBuilder: (context, idx) {
                    final item = widget.pages[idx];
                    return Column(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(38.0),
                            child: Image.asset(
                              item.imageUrl,
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(item.title,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: item.textColor,fontSize: 25,
                                        )),
                              ),
                              Container(
                                constraints:
                                    const BoxConstraints(maxWidth: 280),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0, vertical: 8.0),
                                child: Text(item.description,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: item.subtitle,
                                        )),
                              )
                            ]))
                      ],
                    );
                  },
                ),
              ),

              // Current page indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pages
                    .map((item) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          width: _currentPage == widget.pages.indexOf(item)
                              ? 30
                              : 8,
                          height: 8,
                          margin: const EdgeInsets.all(2.0),
                          decoration: BoxDecoration(
                              color: const Color.fromRGBO(43, 13, 65, 1.0),
                              borderRadius: BorderRadius.circular(10.0)),
                        ))
                    .toList(),
              ),

              // Bottom buttons
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                        style: TextButton.styleFrom(
                            visualDensity: VisualDensity.comfortable,
                            foregroundColor:  Color.fromRGBO(43, 13, 65, 1.0),
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                       onPressed: () async {
                          // Disable the intro screen
                          await PreferenceValues.disableUserIntroScreen();

                          // Navigate to the LoginPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserLogin(),
                            ),
                          );
                        },
                        child: const Text("SKIP")),
                    TextButton(
                      style: TextButton.styleFrom(
                          visualDensity: VisualDensity.comfortable,
                          foregroundColor:  Color.fromRGBO(43, 13, 65, 1.0),
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                     onPressed: () async {
                        if (_currentPage == widget.pages.length - 1) {
                          // Disable the intro screen
                          await PreferenceValues.disableUserIntroScreen();

                          // Navigate to the UserLoginPage
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const UserLogin(),
                            ),
                          );
                        } else {
                          // Go to the next page
                          _pageController.animateToPage(
                            _currentPage + 1,
                            curve: Curves.easeInOutCubic,
                            duration: const Duration(milliseconds: 250),
                          );
                        }
                      },
                      child: Row(
                        children: [
                          Text(
                            _currentPage == widget.pages.length - 1
                                ? "DONE"
                                : "NEXT",
                          ),
                          const SizedBox(width: 8),
                          Icon(_currentPage == widget.pages.length - 1
                              ? Icons.done
                              : Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class OnboardingPageModel {
  final String title;
  final String description;
  final String imageUrl;
  final Color bgColor;
  final Color textColor;
  final Color subtitle;

  OnboardingPageModel(
      {required this.title,
      required this.description,
      required this.imageUrl,
      this.bgColor = Colors.blue,
      this.textColor = const Color.fromARGB(255, 109, 24, 124),
      this.subtitle =Colors.black});
}
