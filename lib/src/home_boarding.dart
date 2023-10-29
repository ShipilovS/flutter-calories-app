import 'package:flutter/material.dart';
import 'package:flutter_calories_app/src/home_boarding_content.dart';
import 'package:onboarding/onboarding.dart';
import 'package:dots_indicator/dots_indicator.dart';

class HomeBoarding extends StatefulWidget {
  const HomeBoarding({super.key});

  @override
  State<HomeBoarding> createState() => _HomeBoardingState();
}

class _HomeBoardingState extends State<HomeBoarding> {
  late PageController _pageController;
  int _currentPage = 0;
  List _contents = contents;

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _contents.length,
                onPageChanged: (value) => setState(
                      () => _currentPage = value,
                ),
                itemBuilder: (context, index) => Column(
                  children: [
                    Image.asset(
                      'assets/images/fruits.jpg',
                    ),
                    Text(_contents[index].title),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          }, child: const Text("Пропустить"),
                        ),
                        _currentPage + 1 == _contents.length ? ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // Navigator.pushNamed(context, '/login');
                            // Navigator.pushReplacement(context, MaterialPageRoute<void>(
                            //   builder: (BuildContext context) => const LoginScreen(),
                            // ));
                          }, child: const Text("Старт"),
                        ) :
                        ElevatedButton(
                          onPressed: () {
                            _pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeIn
                            );
                          }, child: const Text("Далее"),
                        ),
                      ],
                    ),
                     // Поместить снизу без прокрутки
                     DotsIndicator(
                      dotsCount: _contents.length,
                      position: _currentPage,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
