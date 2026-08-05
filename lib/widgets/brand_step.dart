import 'package:flutter/material.dart';

import 'common/app_text_field.dart';
import 'common/card_container.dart';
import 'common/primary_button.dart';
import 'common/progress_header.dart';
import 'common/secondary_button.dart';

class BrandStep extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onNext;
  final VoidCallback onBack;

  const BrandStep({
    super.key,
    required this.initialValue,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<BrandStep> createState() => _BrandStepState();
}

class _BrandStepState extends State<BrandStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.initialValue,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goNext() {
    widget.onNext(_controller.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 600;

    return CardContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ProgressHeader(
            currentStep: 2,
            totalSteps: 7,
            title: 'ما اسم العلامة التجارية؟',
            subtitle: 'يمكنك ترك الحقل فارغًا والمتابعة.',
            icon: Icons.storefront_rounded,
          ),
          const SizedBox(height: 28),
          AppTextField(
            controller: _controller,
            label: 'اسم العلامة — اختياري',
            hint: 'مثال: HILO PRINT',
            icon: Icons.storefront_rounded,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _goNext(),
          ),
          const SizedBox(height: 28),
          if (isMobile) ...[
            PrimaryButton(
              text: 'التالي',
              icon: Icons.arrow_forward_rounded,
              onPressed: _goNext,
            ),
            const SizedBox(height: 12),
            SecondaryButton(
              text: 'رجوع',
              icon: Icons.arrow_back_rounded,
              onPressed: widget.onBack,
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    text: 'رجوع',
                    icon: Icons.arrow_back_rounded,
                    onPressed: widget.onBack,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    text: 'التالي',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: _goNext,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
