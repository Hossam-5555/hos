import 'dart:ui';

import 'package:flutter/material.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.isFav, required this.onTap});

  final bool isFav;
  final VoidCallback onTap;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(
        begin: 1.0,
        end: 1.6,
      ).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 40,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.6, end: 1.0).chain(CurveTween(curve: Curves.ease)),
      weight: 70,
    ),
  ]).animate(_controller);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: ClipPath(
          clipper: ShapeBorderClipper(shape: const CircleBorder()),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: AlignmentGeometry.topLeft,
                  end: AlignmentGeometry.bottomRight,
                  colors: [
                    Colors.white.withAlpha(102),
                    Colors.white.withAlpha(25),
                  ],
                ),
                border: Border.all(color: Colors.white.withAlpha(51)),
                shape: BoxShape.circle,
              ),
              child: ScaleTransition(
                scale: _scale,
                child: Icon(
                  widget.isFav ? Icons.favorite : Icons.favorite_border_rounded,
                  color: widget.isFav
                      ? Colors.redAccent
                      : Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
