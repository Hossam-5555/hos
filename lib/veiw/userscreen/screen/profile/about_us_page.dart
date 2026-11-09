import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hos/core/conistant/app_colors.dart';
import 'package:hos/veiw/wedget/appbarbackicon.dart';
import 'package:hos/veiw/wedget/bulidfooter.dart';

class EnglishAbout extends StatelessWidget {
  const EnglishAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Appbarbackicon(title: "About us", herotag: ""),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AboutHeader(),
            const SizedBox(height: 20),
            const GlassSection(
              title: 'About Us',
              child: Text(
                'ShopWave is a smart and user-friendly e-commerce platform designed to give you a smooth shopping experience through a clean interface, secure checkout, and fast delivery tracking. We are committed to bringing quality products closer to you.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const GlassSection(
              title: 'Why Choose Us',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FeatureItem(
                    icon: Icons.verified_user_outlined,
                    text: 'Secure payment & data protection',
                  ),
                  FeatureItem(
                    icon: Icons.local_shipping_outlined,
                    text: 'Fast and reliable delivery',
                  ),
                  FeatureItem(
                    icon: Icons.support_agent_outlined,
                    text: '24/7 customer support',
                  ),
                  FeatureItem(
                    icon: Icons.replay_outlined,
                    text: 'Easy returns & refunds',
                  ),
                  FeatureItem(
                    icon: Icons.workspace_premium_outlined,
                    text: 'Verified quality products',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const GlassSection(
              title: 'Our Mission',
              child: Text(
                'We aim to make online shopping simple, safe, and enjoyable for everyone, connecting customers with the best products at the best prices.',
                style: TextStyle(
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: 16),
            const GlassSection(
              title: 'Contact Us',
              child: Column(
                children: [
                  ContactTile(
                    icon: Icons.email_outlined,
                    label: 'support@shopwave.com',
                  ),
                  ContactTile(
                    icon: Icons.phone_outlined,
                    label: '+20 100 000 0000',
                  ),
                  ContactTile(
                    icon: Icons.location_on_outlined,
                    label: 'Mansoura, Egypt',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            buildFooter(),
          ],
        ),
      ),
    );
  }
}

class AboutHeader extends StatelessWidget {
  const AboutHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary,AppColors.contactStart],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6A5AE0).withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.category_outlined,
              color: Colors.white,
              size: 42,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'ShopWave',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Version 1.0.0',
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class GlassSection extends StatelessWidget {
  final String title;
  final Widget child;

  const GlassSection({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6A5AE0).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: const Color(0xFF6A5AE0)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

class ContactTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const ContactTile({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        ],
      ),
    );
  }
}
