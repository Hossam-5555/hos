import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NativeSwipeCards extends StatefulWidget {
  final List<String> images;
  NativeSwipeCards({super.key, required this.images, this.onTap});
  void Function(int)? onTap;
  @override
  State<NativeSwipeCards> createState() => _NativeSwipeCardsState();
}

class _NativeSwipeCardsState extends State<NativeSwipeCards>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  Offset position = Offset.zero;
  bool isDragging = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller.addListener(() {
      setState(() {
        position = _animation.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // لما المستخدم يبدأ يسحب الكارت
  void _onPanStart(DragStartDetails details) {
    setState(() {
      isDragging = true;
    });
  }

  // أثناء السحب بصباعه
  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      position += details.delta;
    });
  }

  // لما يشيل صباعه من على الشاشة
  void _onPanEnd(DragEndDetails details) {
    setState(() {
      isDragging = false;
    });

    final screenWidth = MediaQuery.of(context).size.width;
    // لو سحب الكارت أكتر من 35% من عرض الشاشة، يطير برا
    if (position.dx.abs() > screenWidth * 0.35) {
      _swipeOut(position.dx > 0);
    } else {
      // غير كده يرجع مكانه بنعومة
      _resetPosition();
    }
  }

  void _resetPosition() {
    _animation = Tween<Offset>(
      begin: position,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _controller.forward(from: 0);
  }

  void _swipeOut(bool isRight) {
    final screenWidth = MediaQuery.of(context).size.width;
    final endOffset = Offset(
      isRight ? screenWidth * 1.5 : -screenWidth * 1.5,
      position.dy,
    );

    _animation = Tween<Offset>(
      begin: position,
      end: endOffset,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward(from: 0).then((_) {
      setState(() {
        // الانتقال للصورة اللي بعدها (ولما يخلصوا يعيد من الأول)
        currentIndex = (currentIndex + 1) % widget.images.length;
        position = Offset.zero;
      });
      widget.onTap; // استدعاء الدالة عند السحب
    });
  }

  @override
  Widget build(BuildContext context) {
    final nextIndex = (currentIndex + 1) % widget.images.length;
    // حساب زاوية الميلان بناءً على مسافة السحب
    final angle = (position.dx / 300) * (pi / 12);

    return SizedBox(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. الكارت اللي في الخلفية (اللي هيظهر بعد ده)
          Transform.scale(
            // بيكبر تدريجياً كل ما تسحب الكارت اللي قدامه
            scale: (0.9 + (position.dx.abs() / 1000)).clamp(0.9, 1.0),
            child: _buildImageCard(widget.images[nextIndex]),
          ),

          // 2. الكارت الأمامي المتحرك
          GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Transform.translate(
              offset: position,
              child: Transform.rotate(
                angle: angle,
                child: _buildImageCard(widget.images[currentIndex]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageCard(String imageUrl) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.contain),
          ),
        ),
        placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
