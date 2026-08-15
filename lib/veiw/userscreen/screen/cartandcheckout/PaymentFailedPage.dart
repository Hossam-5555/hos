import 'package:flutter/material.dart';

class PaymentFailedPage extends StatefulWidget {
  final String orderNumber;
  final String amount;
  final String reason;

  const PaymentFailedPage({
    super.key,
    this.orderNumber = '#10245',
    this.amount = '\$250.00',
    this.reason = 'Your payment could not be completed.',
  });

  @override
  State<PaymentFailedPage> createState() => _PaymentFailedPageState();
}

class _PaymentFailedPageState extends State<PaymentFailedPage>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _contentController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Error icon animation
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _iconController,
      curve: Curves.easeIn,
    );

    // Content animation
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _contentFadeAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );

    _contentSlideAnimation =
        Tween<Offset>(begin: const Offset(0, .08), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _contentController,
            curve: Curves.easeOutCubic,
          ),
        );

    _iconController.forward();

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _contentController.forward();
      }
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 25),

                    /// Error Icon
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _errorIcon(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// Content
                    FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: SlideTransition(
                        position: _contentSlideAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Payment Failed',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -.5,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xff17191C),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              widget.reason,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xff777B82),
                              ),
                            ),

                            const SizedBox(height: 32),

                            /// Error Information Card
                            _paymentCard(isDark),

                            const SizedBox(height: 24),

                            /// Help Message
                            _helpMessage(isDark),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Bottom Buttons
            FadeTransition(
              opacity: _contentFadeAnimation,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
                child: Column(
                  children: [
                    _tryAgainButton(),

                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: isDark
                              ? Colors.white
                              : const Color(0xff30343A),
                          side: BorderSide(
                            color: isDark
                                ? Colors.white.withOpacity(.15)
                                : const Color(0xffDCDDE0),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(17),
                          ),
                        ),
                        child: const Text(
                          'Back to Checkout',
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
            ),
          ],
        ),
      ),
    );
  }

  /// Error Icon
  Widget _errorIcon() {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xffFDECEC),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffE5484D).withOpacity(.15),
            blurRadius: 35,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xffE5484D),
        ),
        child: const Icon(Icons.close_rounded, size: 55, color: Colors.white),
      ),
    );
  }

  /// Payment Card
  Widget _paymentCard(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff181B21) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(.06)
              : const Color(0xffEDEEF0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? .12 : .05),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _detailRow(
            icon: Icons.receipt_long_rounded,
            title: 'Order Number',
            value: widget.orderNumber,
            isDark: isDark,
          ),

          _divider(isDark),

          _detailRow(
            icon: Icons.payments_rounded,
            title: 'Attempted Amount',
            value: widget.amount,
            isDark: isDark,
            highlight: true,
          ),

          _divider(isDark),

          _detailRow(
            icon: Icons.error_outline_rounded,
            title: 'Payment Status',
            value: 'Failed',
            isDark: isDark,
            error: true,
          ),
        ],
      ),
    );
  }

  Widget _detailRow({
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
    bool highlight = false,
    bool error = false,
  }) {
    final Color accentColor = error
        ? const Color(0xffE5484D)
        : const Color(0xff22A86B);

    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: error
                ? const Color(0xffFDECEC)
                : highlight
                ? const Color(0xffE9F8F0)
                : isDark
                ? const Color(0xff22262E)
                : const Color(0xffF5F6F8),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 21,
            color: error
                ? const Color(0xffE5484D)
                : highlight
                ? accentColor
                : isDark
                ? Colors.white70
                : const Color(0xff60656C),
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white54 : const Color(0xff8A8E94),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: TextStyle(
                  fontSize: highlight || error ? 16 : 14,
                  fontWeight: highlight || error
                      ? FontWeight.w800
                      : FontWeight.w600,
                  color: error
                      ? const Color(0xffE5484D)
                      : highlight
                      ? const Color(0xff22A86B)
                      : isDark
                      ? Colors.white
                      : const Color(0xff202328),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Divider(
        height: 1,
        color: isDark ? Colors.white.withOpacity(.06) : const Color(0xffECEDEF),
      ),
    );
  }

  /// Help Message
  Widget _helpMessage(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1A1D23) : const Color(0xffF1F3F5),
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            size: 21,
            color: isDark ? Colors.white60 : const Color(0xff6D7279),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              'No money was charged. You can try the payment again or choose another payment method.',
              style: TextStyle(
                fontSize: 12.5,
                height: 1.5,
                color: isDark ? Colors.white60 : const Color(0xff70757C),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Try Again Button
  Widget _tryAgainButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () {
          // افتح WebView مرة أخرى
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff17191C),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.refresh_rounded, size: 21),
            SizedBox(width: 9),
            Text(
              'Try Again',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
