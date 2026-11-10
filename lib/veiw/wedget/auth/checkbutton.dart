// import 'package:flutter/material.dart';
// import 'package:hos/data/services/crud.dart';

// // ignore: must_be_immutable
// class Checkbutton extends StatelessWidget {
//   Checkbutton({
//     super.key,
//     required this.onTap,
//     required this.buttonName,
//     this.width,
//     this.buttonColor,
//     this.statusrequest,
//   });

//   Checkbutton.widget({
//     super.key,
//     required this.onTap,
//     required this.buttonName,
//     this.widget,
//     this.width,
//     this.buttonColor,
//     this.statusrequest,
//     this.h
//   });
//   double? h;
//   Widget? widget;
//   void Function() onTap;
//   double? width;
//   Color? buttonColor;
//   String buttonName;
//   Statusrequest? statusrequest;
//   @override
//   Widget build(BuildContext context) {
//     return IgnorePointer(
//       ignoring: statusrequest == Statusrequest.loading,
//       child: AnimatedContainer(
//         decoration: BoxDecoration(
//           color: buttonColor ?? Colors.black,
//           borderRadius: BorderRadius.circular(
//             statusrequest == Statusrequest.loading ? 30 : 40,
//           ),
//         ),
//         duration: Duration(milliseconds: 400),
//         width: statusrequest == Statusrequest.loading ? 60 : width,
//         height:h?? 55,
//         curve: Curves.easeInOut,
//         child: Material(
//           color: Colors.transparent,
//           child: InkWell(
//             borderRadius: BorderRadius.circular(30),
//             onTap: onTap,
//             child: Center(
//               child: AnimatedSwitcher(
//                 duration: const Duration(milliseconds: 250),
    
//                 transitionBuilder: (child, animation) {
//                   return FadeTransition(
//                     opacity: animation,
//                     child: ScaleTransition(scale: animation, child: child),
//                   );
//                 },
    
//                 child: statusrequest == Statusrequest.loading
//                     ? const SizedBox(
//                         key: ValueKey("loading"),
//                         width: 26,
//                         height: 26,
//                         child: CircularProgressIndicator(
//                           strokeWidth: 2.8,
//                           color: Colors.white,
//                         ),
//                       )
//                     : widget ??
//                           Text(
//                             buttonName,
//                             key: ValueKey("text"),
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:hos/data/services/crud.dart';

// ignore: must_be_immutable
class Checkbutton extends StatefulWidget {
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
    this.h,
  });

  double? h;
  Widget? widget;
  void Function() onTap;
  double? width;
  Color? buttonColor;
  String buttonName;
  Statusrequest? statusrequest;

  @override
  State<Checkbutton> createState() => _CheckbuttonState();
}

class _CheckbuttonState extends State<Checkbutton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.statusrequest == Statusrequest.loading
          ? null
          : (_) => setState(() => _scale = 0.95), // تصغير الزر عند الضغط
      onTapUp: widget.statusrequest == Statusrequest.loading
          ? null
          : (_) => setState(() => _scale = 1.0), // رجوعه للحجم الطبيعي عند رفع الإصبع
      onTapCancel: widget.statusrequest == Statusrequest.loading
          ? null
          : () => setState(() => _scale = 1.0), // رجوعه لو تم إلغاء اللمس
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        child: IgnorePointer(
          ignoring: widget.statusrequest == Statusrequest.loading,
          child: AnimatedContainer(
            decoration: BoxDecoration(
              color: widget.buttonColor ?? Colors.black,
              borderRadius: BorderRadius.circular(
                widget.statusrequest == Statusrequest.loading ? 30 : 40,
              ),
            ),
            duration: const Duration(milliseconds: 400),
            width: widget.statusrequest == Statusrequest.loading ? 60 : widget.width,
            height: widget.h ?? 55,
            curve: Curves.easeInOut,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: widget.onTap,
                child: Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: ScaleTransition(scale: animation, child: child),
                      );
                    },
                    child: widget.statusrequest == Statusrequest.loading
                        ? const SizedBox(
                            key: ValueKey("loading"),
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.8,
                              color: Colors.white,
                            ),
                          )
                        : widget.widget ??
                            Text(
                              widget.buttonName,
                              key: const ValueKey("text"),
                              style: const TextStyle(
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
      ),
    );
  }
}