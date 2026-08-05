import 'package:flutter/material.dart';

import 'common/card_container.dart';
import 'common/progress_header.dart';
import 'common/primary_button.dart';
import 'common/secondary_button.dart';

class UploadStep extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onWhatsApp;
  final VoidCallback onMessenger;

  const UploadStep({
    super.key,
    required this.onBack,
    required this.onWhatsApp,
    required this.onMessenger,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ProgressHeader(
            currentStep: 7,
            totalSteps: 7,
            title: 'اختر وسيلة التواصل',
            subtitle: 'بعد فتح المحادثة أرسل الشعار وصور المنتج إن وجدت.',
            icon: Icons.chat_rounded,
          ),
          const SizedBox(height: 28),
          PrimaryButton(
            text: 'متابعة عبر واتساب',
            icon: Icons.chat,
            onPressed: onWhatsApp,
            backgroundColor: const Color(0xFF16A765),
          ),
          const SizedBox(height: 14),
          PrimaryButton(
            text: 'متابعة عبر ماسنجر',
            icon: Icons.facebook,
            onPressed: onMessenger,
            backgroundColor: const Color(0xFF1877F2),
          ),
          const SizedBox(height: 18),
          SecondaryButton(
            text: 'رجوع',
            icon: Icons.arrow_back_rounded,
            onPressed: onBack,
          ),
        ],
      ),
    );
  }
}
