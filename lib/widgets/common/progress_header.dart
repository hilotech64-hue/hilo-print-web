import 'package:flutter/material.dart';

class ProgressHeader extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String title;
  final String? subtitle;
  final IconData? icon;

  const ProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    required this.title,
    this.subtitle,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final double progress =
    totalSteps <= 0 ? 0 : currentStep / totalSteps;

    final bool isMobile = MediaQuery.sizeOf(context).width < 600;

    return Column(
      children: [
        const Text(
          'HILO PRINT',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Color(0xFF1565C0),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'الخطوة $currentStep من $totalSteps',
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF6B8093),
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress.clamp(0, 1),
            minHeight: 8,
            backgroundColor: const Color(0xFFEAF0F7),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF1565C0),
            ),
          ),
        ),
        const SizedBox(height: 28),
        if (icon != null) ...[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 32,
              color: const Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 18),
        ],
        Text(
          title,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: isMobile ? 27 : 34,
            fontWeight: FontWeight.w900,
            height: 1.2,
            color: const Color(0xFF102A43),
          ),
        ),
        if (subtitle != null && subtitle!.trim().isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(
            subtitle!,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Color(0xFF6B8093),
            ),
          ),
        ],
      ],
    );
  }
}
