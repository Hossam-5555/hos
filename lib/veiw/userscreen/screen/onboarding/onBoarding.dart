import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hos/core/serveces/myservisec.dart';
import 'package:hos/veiw/userscreen/screen/auth/Auth.dart';

class OnboardingModel {
  final IconData icon;
  final String title;
  final String subtitle;
  final List<Color> gradient;

  const OnboardingModel({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.gradient,
  });
}

class OnboardingController extends GetxController {
  final PageController pageController = PageController();
  int currentPage = 0;

  final List<OnboardingModel> pages = const [
    OnboardingModel(
      icon: Icons.shopping_bag_rounded,
      title: 'اكتشف عالم التسوق',
      subtitle: 'آلاف المنتجات المختارة بعناية في مكان واحد يناسب ذوقك',
      gradient: [Color(0xFF7F5AF0), Color(0xFF2CB67D)],
    ),
    OnboardingModel(
      icon: Icons.local_shipping_rounded,
      title: 'توصيل سريع وآمن',
      subtitle: 'اطلب أونلاين واستلم طلبك لحد باب البيت في أسرع وقت',
      gradient: [Color(0xFF2CB67D), Color(0xFF3DA9FC)],
    ),
    OnboardingModel(
      icon: Icons.favorite_rounded,
      title: 'تجربة مخصصة ليك',
      subtitle: 'اقتراحات ذكية بتتطور مع كل عملية شراء تعملها',
      gradient: [Color(0xFF3DA9FC), Color(0xFFE45858)],
    ),
    OnboardingModel(
      icon: Icons.verified_rounded,
      title: 'ابدأ رحلتك دلوقتي',
      subtitle: 'انضم لآلاف المستخدمين اللي بيثقوا فينا كل يوم',
      gradient: [Color(0xFFE45858), Color(0xFF7F5AF0)],
    ),
  ];

  bool get isLastPage => currentPage == pages.length - 1;

  void onPageChanged(int index) {
    currentPage = index;
    update();
  }

  void nextPage() {
    if (isLastPage) {
      next();
      return;
    }
    pageController.nextPage(
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeOutCubic,
    );
  }

  void skip() {
    pageController.animateToPage(
      pages.length - 1,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
    );
  }

  Myservisec myservisec = Get.find();
  void next() {
    myservisec.sharedPreferences.setString('step', "1");
    Get.offAll(
      () => AuthPage(),
      transition: Transition.fadeIn,
      curve: Curves.easeInOut,
      duration: const Duration(milliseconds: 900),
    );
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

class Onboarding extends StatelessWidget {
  const Onboarding({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF0B0B0F)
          : const Color(0xFFF7F7FA),
      body: GetBuilder<OnboardingController>(
        builder: (ctrl) {
          final current = ctrl.pages[ctrl.currentPage];
          return Stack(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOutCubic,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.6),
                    radius: 1.4,
                    colors: [
                      current.gradient.first.withOpacity(isDark ? 0.35 : 0.25),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -80,
                right: -60,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: current.gradient),
                  ),
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                  child: Container(color: Colors.transparent),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: ctrl.isLastPage ? 0 : 1,
                            child: TextButton(
                              onPressed: ctrl.isLastPage ? null : ctrl.skip,
                              style: TextButton.styleFrom(
                                foregroundColor: isDark
                                    ? Colors.white70
                                    : Colors.black54,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                              ),
                              child: const Text(
                                'تخطي',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: PageView.builder(
                        controller: ctrl.pageController,
                        onPageChanged: ctrl.onPageChanged,
                        itemCount: ctrl.pages.length,
                        itemBuilder: (context, index) {
                          final page = ctrl.pages[index];
                          return _OnboardingSlide(page: page, isDark: isDark);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 0, 28, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          ctrl.pages.length,
                          (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOutCubic,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            height: 8,
                            width: ctrl.currentPage == index ? 26 : 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: ctrl.currentPage == index
                                  ? LinearGradient(colors: current.gradient)
                                  : null,
                              color: ctrl.currentPage == index
                                  ? null
                                  : (isDark ? Colors.white24 : Colors.black12),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 58,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) =>
                              FadeTransition(
                                opacity: animation,
                                child: ScaleTransition(
                                  scale: animation,
                                  child: child,
                                ),
                              ),
                          child: ElevatedButton(
                            key: ValueKey(ctrl.isLastPage),
                            onPressed: ctrl.nextPage,
                            style:
                                ElevatedButton.styleFrom(
                                  backgroundColor: current.gradient.last,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ).copyWith(
                                  backgroundColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  shadowColor: WidgetStateProperty.all(
                                    Colors.transparent,
                                  ),
                                  overlayColor: WidgetStateProperty.all(
                                    Colors.white.withOpacity(0.1),
                                  ),
                                ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: current.gradient,
                                ),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      ctrl.isLastPage ? 'ابدأ الآن' : 'التالي',
                                      style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Icon(
                                      ctrl.isLastPage
                                          ? Icons.arrow_forward_rounded
                                          : Icons.arrow_forward_ios_rounded,
                                      size: 18,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final OnboardingModel page;
  final bool isDark;

  const _OnboardingSlide({required this.page, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            key: ValueKey(page.title),
            tween: Tween(begin: 0.85, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutBack,
            builder: (context, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                  colors: page.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: page.gradient.last.withOpacity(0.35),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    child: Icon(page.icon, size: 68, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.15),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Text(
              page.title,
              key: ValueKey(page.title),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
                height: 1.3,
                color: isDark ? Colors.white : const Color(0xFF1A1A1F),
              ),
            ),
          ),
          const SizedBox(height: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.15),
                end: Offset.zero,
              ).animate(animation),
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Text(
              page.subtitle,
              key: ValueKey(page.subtitle),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w400,
                height: 1.6,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
