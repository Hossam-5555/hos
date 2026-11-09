import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

OverlayEntry? _toastEntry;

void _removeToast() {
  _toastEntry?.remove();
  _toastEntry = null;
}

void showSnackBar(
  BuildContext context,
  String message,
  Widget icon, {
  SnackBarAction? action,
  Duration duration = const Duration(seconds: 2),
}) {
  FocusManager.instance.primaryFocus?.unfocus();

  final overlay =
      Overlay.maybeOf(context, rootOverlay: true) ?? Get.key.currentState?.overlay;
  if (overlay == null) return;

  _removeToast(); // لو في إشعار ظاهر يتشال فوراً ويحل مكانه الجديد

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _TelegramToast(
      message: message,
      icon: icon,
      action: action,
      duration: duration,
      onClosed: () {
        if (identical(_toastEntry, entry)) _toastEntry = null;
        entry.remove();
      },
    ),
  );
  _toastEntry = entry;
  overlay.insert(entry);
}

class _TelegramToast extends StatefulWidget {
  final String message;
  final Widget icon;
  final SnackBarAction? action;
  final Duration duration;
  final VoidCallback onClosed;

  const _TelegramToast({
    required this.message,
    required this.icon,
    required this.action,
    required this.duration,
    required this.onClosed,
  });

  @override
  State<_TelegramToast> createState() => _TelegramToastState();
}

class _TelegramToastState extends State<_TelegramToast>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 280),
    reverseDuration: const Duration(milliseconds: 200),
  );
  late final Animation<double> _curve = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.easeOutCubic,
    reverseCurve: Curves.easeInCubic,
  );
  Timer? _timer;
  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
    _timer = Timer(widget.duration, _close);
  }

  Future<void> _close() async {
    if (_closing || !mounted) return;
    _closing = true;
    _timer?.cancel();
    await _ctrl.reverse();
    if (mounted) widget.onClosed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final bottom = mq.viewInsets.bottom + mq.padding.bottom + 24;

    return Positioned(
      left: 16,
      right: 16,
      bottom: bottom,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: FadeTransition(
            opacity: _curve,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.5),
                end: Offset.zero,
              ).animate(_curve),
              child: GestureDetector(
                onTap: _close,
                onVerticalDragEnd: (d) {
                  if ((d.primaryVelocity ?? 0) > 100) _close();
                },
                child: Material(
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                        color: const Color(0xE61C1C22),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            widget.icon,
                            const SizedBox(width: 12),
                            Flexible(
                              child: Text(
                                widget.message,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.3,
                                ),
                              ),
                            ),
                            if (widget.action != null) ...[
                              const SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  widget.action!.onPressed();
                                  _close();
                                },
                                child: Text(
                                  widget.action!.label,
                                  style: const TextStyle(
                                    color: Color(0xFF6AB7FF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
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

String translatePayment(String val) {
  switch (val) {
    case "credit":
      return " credit ";
    case "cash":
      return "Cash";
    case "mobil":
      return " mobileWallet";
    default:
      return "غير معروف";
  }
}