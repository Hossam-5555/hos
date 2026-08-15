import 'package:flutter/material.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class PaymentSuccessPage extends StatefulWidget {
  final String orderNumber;
  final String transactionId;
  final String amount;
  final String paymentMethod;

  const PaymentSuccessPage({
    super.key,
    this.orderNumber = '#10245',
    this.transactionId = '#TXN-8F32A91',
    this.amount = '\$250.00',
    this.paymentMethod = 'Visa •••• 4242',
  });

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _checkController;
  late AnimationController _contentController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _contentFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Success icon animation
    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _checkController,
      curve: Curves.easeIn,
    );

    // Content animation
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _contentFadeAnimation = CurvedAnimation(
      parent: _contentController,
      curve: Curves.easeOut,
    );

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Curves.easeOutCubic,
      ),
    );

    _checkController.forward();

    Future.delayed(
      const Duration(milliseconds: 350),
      () {
        if (mounted) {
          _contentController.forward();
        }
      },
    );
  }

  @override
  void dispose() {
    _checkController.dispose();
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

                    /// Success Icon
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: _successIcon(),
                      ),
                    ),

                    const SizedBox(height: 28),

                    /// Main Content
                    FadeTransition(
                      opacity: _contentFadeAnimation,
                      child: SlideTransition(
                        position: _contentSlideAnimation,
                        child: Column(
                          children: [
                            Text(
                              'Payment Successful',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.5,
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xff17191C),
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'Your payment has been completed successfully.',
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

                            /// Payment Details Card
                            _paymentCard(isDark),

                            const SizedBox(height: 25),
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
                    _viewOrderButton(),

                    const SizedBox(height: 14),

                    TextButton(
                      onPressed: () {
                        Navigator.popUntil(
                          context,
                          (route) => route.isFirst,
                        );
                      },
                      child: Text(
                        'Back to Home',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xff555A61),
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

  /// Success Circle
  Widget _successIcon() {
    return Container(
      width: 112,
      height: 112,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xffE9F8F0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff22A86B).withOpacity(.18),
            blurRadius: 35,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Container(
        margin: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Color(0xff22A86B),
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 55,
          color: Colors.white,
        ),
      ),
    );
  }

  /// Payment Information Card
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
            color: Colors.black.withOpacity(
              isDark ? .12 : .05,
            ),
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
            icon: Icons.tag_rounded,
            title: 'Transaction ID',
            value: widget.transactionId,
            isDark: isDark,
          ),

          _divider(isDark),

          _detailRow(
            icon: Icons.payments_rounded,
            title: 'Amount Paid',
            value: widget.amount,
            isDark: isDark,
            highlight: true,
          ),

          _divider(isDark),

          _detailRow(
            icon: Icons.credit_card_rounded,
            title: 'Payment Method',
            value: widget.paymentMethod,
            isDark: isDark,
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
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: highlight
                ? const Color(0xffE9F8F0)
                : isDark
                    ? const Color(0xff22262E)
                    : const Color(0xffF5F6F8),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            size: 21,
            color: highlight
                ? const Color(0xff22A86B)
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
                  color: isDark
                      ? Colors.white54
                      : const Color(0xff8A8E94),
                ),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: TextStyle(
                  fontSize: highlight ? 17 : 14,
                  fontWeight:
                      highlight ? FontWeight.w800 : FontWeight.w600,
                  color: highlight
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
        color: isDark
            ? Colors.white.withOpacity(.06)
            : const Color(0xffECEDEF),
      ),
    );
  }

  /// View Order Button
  Widget _viewOrderButton() {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton(
        onPressed: () {
          // Navigate to Order Details
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff22A86B),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'View Order',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(width: 10),
            Icon(
              Icons.arrow_forward_rounded,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }
}