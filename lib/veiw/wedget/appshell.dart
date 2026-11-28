import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hos/core/functions/appexitalert.dart';
import 'package:hos/veiw/wedget/Homepage/buttomAppbar.dart';

class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.title,
    required this.pages,
    required this.navItems,
    required this.currentIndex,
    required this.onTap,
    required this.pageController,
    required this.onPageChanged,
    required this.onScroll,
    required this.onOrderScroll,
    required this.visible,
    required this.cartCount,
    this.actionsBuilder,
    this.appBarColor,
  });

  final Widget title;
  final List<Widget> pages;
  final List<NavItem> navItems;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final PageController pageController;
  final ValueChanged<int> onPageChanged;
  final ValueChanged<ScrollDirection> onScroll;
  final ValueChanged<double> onOrderScroll;
  final bool visible;
  final int cartCount;
  final List<Widget> Function(int index)? actionsBuilder;
  final Color? appBarColor;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;

    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldExit = await appexitAlert();
        if (shouldExit == true) exit(0);
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: currentIndex == 1
              ? SafeArea(child: SizedBox.shrink())
              : AppBar(
                  backgroundColor: appBarColor,
                  centerTitle: false,
                  scrolledUnderElevation: 0,
                  title: title,
                  actions: actionsBuilder?.call(currentIndex) ?? const [],
                ),
        ),
        resizeToAvoidBottomInset: false,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: SafeArea(
          child: Container(
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(
              left: w * 0.04,
              right: w * 0.04,
              bottom: 10,
            ),
            child: CustomBottomNavBar(
              items: navItems,
              currentIndex: currentIndex,
              onTap: onTap,
              visible: visible,
              cartcount: cartCount,
            ),
          ),
        ),
        body: NotificationListener<UserScrollNotification>(
          onNotification: (notification) {
            if (notification.metrics.axis == Axis.vertical) {
              onScroll(notification.direction);
              onOrderScroll(notification.metrics.pixels);
            }
            return false;
          },
          child: PageView(
            controller: pageController,
            onPageChanged: (i) {
              if (!visible) onScroll(ScrollDirection.forward);
              onPageChanged(i);
            },
            children: pages,
          ),
        ),
      ),
    );
  }
}
