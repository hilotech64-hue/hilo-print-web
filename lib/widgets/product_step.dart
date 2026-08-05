import 'package:flutter/material.dart';

import 'common/app_text_field.dart';
import 'common/card_container.dart';
import 'common/primary_button.dart';
import 'common/progress_header.dart';
import 'common/secondary_button.dart';

class ProductStep extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onNext;
  final VoidCallback onBack;

  const ProductStep({
    super.key,
    required this.initialValue,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<ProductStep> createState() => _ProductStepState();
}

class _ProductStepState extends State<ProductStep> {
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
            currentStep: 1,
            totalSteps: 7,
            title: 'ما اسم منتجك؟',
            subtitle: 'يمكنك ترك الحقل فارغًا والمتابعة.',
            icon: Icons.inventory_2_rounded,
          ),
          const SizedBox(height: 28),
          AppTextField(
            controller: _controller,
            label: 'اسم المنتج — اختياري',
            hint: 'مثال: عسل، قهوة، زيت الزيتون...',
            icon: Icons.inventory_2_rounded,
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
