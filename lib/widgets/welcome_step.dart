import 'package:flutter/material.dart';

import 'common/card_container.dart';
import 'common/primary_button.dart';

class WelcomeStep extends StatelessWidget {
  final VoidCallback onStart;

  const WelcomeStep({
    super.key,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final bool mobile = MediaQuery.sizeOf(context).width < 600;

    return CardContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 84,
            height: 84,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF3FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.local_offer_rounded,
              size: 42,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'مرحبًا بك في HILO PRINT',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: mobile ? 30 : 40,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'اطلب تصميم وطباعة ملصق منتجك بخطوات بسيطة وسريعة.',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 17,
              height: 1.7,
              color: Color(0xFF5B7083),
            ),
          ),
          const SizedBox(height: 36),
          PrimaryButton(
            text: 'ابدأ الطلب',
            icon: Icons.arrow_forward_rounded,
            onPressed: onStart,
          ),
          const SizedBox(height: 18),
          const Text(
            'لن تستغرق العملية سوى دقائق قليلة',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF7A8FA3),
            ),
          ),
        ],
      ),
    );
  }
}
