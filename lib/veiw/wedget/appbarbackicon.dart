// import 'package:flutter/material.dart';

// Reusable responsive AppBar with back/close action.
import 'package:flutter/material.dart';

class Appbarbackicon extends StatelessWidget implements PreferredSizeWidget {
  const Appbarbackicon({
    super.key,
    required this.title,
    required this.herotag,
    this.selected = false,
    this.onPressed,
    this.iconButton,
    this.ontap,
  }) : needicon = false;

  Appbarbackicon.nedicon({
    super.key,
    required this.title,
    required this.herotag,
    this.selected = false,
    this.onPressed,
    this.ontap,
    this.iconButton,
    this.needicon = true,
  });

  final String title;
  final String herotag;
  final bool selected;
  final VoidCallback? onPressed;
  final VoidCallback? ontap;
  final Widget? iconButton;
  final bool needicon;

  static const double _toolbarHeight = 60;
  static const double _sidePadding = 8;

  @override
  Size get preferredSize => const Size.fromHeight(_toolbarHeight);

  @override
  Widget build(BuildContext context) {
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    // Single source of truth for the button size.
    final buttonSize = Homescrenaction.sizeOf(context);
    final iconSize = Homescrenaction.iconSizeOf(context);

    return AppBar(
      toolbarHeight: _toolbarHeight,
      centerTitle: true,
      titleSpacing: 0,
      leadingWidth: buttonSize + _sidePadding,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
      leading: Center(
        child: Padding(
          padding: const EdgeInsetsDirectional.only(start: _sidePadding),
          child: Homescrenaction(
            herotag: herotag,
            onPressed: () {
              if (selected) {
                onPressed?.call();
              } else {
                Navigator.of(context).maybePop();
              }
            },
            child: Icon(
              selected ? Icons.close_rounded : Icons.arrow_back_ios_new_rounded,
              size: iconSize,
              color:Colors.black87 ,
            ),
          ),
        ),
      ),
      actions: [
        if (iconButton != null && (selected || needicon))
          Padding(
            padding: const EdgeInsetsDirectional.only(end: _sidePadding),
            child: Center(
              child: Homescrenaction(
                herotag: "filter",
                onPressed: ontap,
                child: iconButton!,
              ),
            ),
          ),
      ],
    );
  }
}

// Reusable circular button. Same size everywhere unless [size] is passed.
class Homescrenaction extends StatelessWidget {
  const Homescrenaction({
    super.key,
    required this.herotag,
    required this.child,
    this.onPressed,
    this.color,
    this.size,
    this.backgroundColor,
    this.borderColor,
  });

  final String herotag;
  final VoidCallback? onPressed;
  final Widget child;
  final Color? color;
  final double? size;
  final Color? backgroundColor;
  final Color? borderColor;

  // Shared sizing used by every Homescrenaction and the AppBar leading.
  static double sizeOf(BuildContext context) =>
      (MediaQuery.sizeOf(context).width * 0.20).clamp(45.0, 50.0);

  static double iconSizeOf(BuildContext context) =>
      (sizeOf(context) * 0.40).clamp(18.0, 21.0);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonSize = size ?? sizeOf(context);

    return Hero(
      tag: herotag,
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: Ink(
          width: buttonSize,
          height: buttonSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? color ?? const Color(0xFFE0E3E8),
            border: Border.all(
              color:
                  borderColor ??
                  (isDark
                      ? Colors.white.withAlpha(18)
                      : Colors.black.withAlpha(12)),
              width: 1,
            ),
          ),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onPressed,
            child: Center(
              // Icons passed as child follow the same size as the leading icon.
              child: IconTheme.merge(
                data: IconThemeData(
                  size: (buttonSize * 0.40).clamp(18.0, 21.0),
                  color: isDark ? const Color(0xFFE8ECF5) : Colors.black87,
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
