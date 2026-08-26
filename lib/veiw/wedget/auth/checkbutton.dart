import 'package:flutter/material.dart';
import 'package:hos/core/class/crud.dart';

// ignore: must_be_immutable
class Checkbutton extends StatelessWidget {
  Checkbutton({
    super.key,
    required this.onTap,
    required this.buttonName,
    this.width,
    this.buttonColor,
    this.statusrequest,
  });

  Checkbutton.widget({
    super.key,
    required this.onTap,
    required this.buttonName,
    this.widget,
    this.width,
    this.buttonColor,
    this.statusrequest,
    this.h
  });
  double? h;
  Widget? widget;
  void Function() onTap;
  double? width;
  Color? buttonColor;
  String buttonName;
  Statusrequest? statusrequest;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: IgnorePointer(
        ignoring: statusrequest == Statusrequest.loading,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            color: buttonColor ?? Colors.black,
            borderRadius: BorderRadius.circular(
              statusrequest == Statusrequest.loading ? 30 : 40,
            ),
          ),
          duration: Duration(milliseconds: 400),
          width: statusrequest == Statusrequest.loading ? 60 : width,
          height:h?? 60,
          curve: Curves.easeInOut,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onTap,
              child: Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),

                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },

                  child: statusrequest == Statusrequest.loading
                      ? const SizedBox(
                          key: ValueKey("loading"),
                          width: 26,
                          height: 26,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.8,
                            color: Colors.white,
                          ),
                        )
                      : widget ??
                            Text(
                              "$buttonName",
                              key: ValueKey("text"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
