import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:hos/controler/usercontroller/auth/veryficodesignup.dart';
import 'package:hos/core/class/handlingdataview.dart';
import 'package:hos/core/conistant/appcolor.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';

class Veryfisign extends StatelessWidget {
  const Veryfisign({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VeryfiSignControler());
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: Appbarbackicon(title: "Verification Code", herotag: "code"),
      body: SafeArea(
        child: GetBuilder<VeryfiSignControler>(
          builder: (_) => HandlingDataView(
            statusrequest: controller.statusrequest,
            widget: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth > 480
                      ? 480.0
                      : constraints.maxWidth;
                  final fieldSize = (maxWidth * 0.14).clamp(48.0, 64.0);

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            _VerifyIcon(colors: colors),
                            const SizedBox(height: 24),
                            Text(
                              'Verify Your Email',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Enter the 5-digit code sent to',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              controller.email ?? '',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: colors.onSurface,
                              ),
                            ),
                            const SizedBox(height: 40),
                            OtpTextField(
                              numberOfFields: 5,
                              fillColor: colors.surfaceContainerHighest,
                              filled: true,
                              fieldWidth: fieldSize,
                              borderRadius: BorderRadius.circular(14),
                              enabledBorderColor: colors.outlineVariant,
                              focusedBorderColor: Appcolor.deepPurple,
                              showFieldAsBox: true,
                              cursorColor: Appcolor.deepPurple,
                              textStyle: theme.textTheme.titleMedium?.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.bold,
                              ),
                              onCodeChanged: (String code) {},
                              onSubmit: (String verificationCode) {
                                controller.gotosuccessignup(verificationCode);
                              },
                            ),
                            const SizedBox(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't receive code?",
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colors.onSurfaceVariant,
                                  ),
                                ),
                                TextButton(
                                  onPressed: controller.resendcode,
                                  style: TextButton.styleFrom(
                                    foregroundColor: Appcolor.deepPurple,
                                  ),
                                  child: const Text(
                                    "Resend",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _VerifyIcon extends StatelessWidget {
  const _VerifyIcon({required this.colors});

  final ColorScheme colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Appcolor.deepPurple.withOpacity(0.12),
      ),
      child: Icon(
        Icons.mark_email_read_outlined,
        color: Appcolor.deepPurple,
        size: 34,
      ),
    );
  }
}