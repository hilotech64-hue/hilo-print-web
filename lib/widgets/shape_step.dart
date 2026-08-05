import 'package:flutter/material.dart';

class ShapeStep extends StatefulWidget {
  final String initialValue;
  final ValueChanged<String> onNext;
  final VoidCallback onBack;

  const ShapeStep({
    super.key,
    required this.initialValue,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<ShapeStep> createState() => _ShapeStepState();
}

class _ShapeStepState extends State<ShapeStep> {
  String selectedShape = '';

  @override
  void initState() {
    super.initState();
    selectedShape = widget.initialValue;
  }

  void _goNext() {
    widget.onNext(selectedShape);
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.sizeOf(context).width < 600;

    final List<_ShapeOption> options = [
      const _ShapeOption(
        title: 'مستطيل',
        icon: Icons.rectangle_outlined,
      ),
      const _ShapeOption(
        title: 'دائري',
        icon: Icons.circle_outlined,
      ),
      const _ShapeOption(
        title: 'فورم دكوب',
        icon: Icons.auto_awesome_motion_rounded,
      ),
      const _ShapeOption(
        title: 'لا أعرف',
        subtitle: 'أريد اقتراحًا مناسبًا',
        icon: Icons.help_outline_rounded,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 30,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
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
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: const LinearProgressIndicator(
              value: 0.50,
              minHeight: 8,
              backgroundColor: Color(0xFFEAF0F7),
              valueColor: AlwaysStoppedAnimation<Color>(
                Color(0xFF1565C0),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            'ما شكل الملصق؟',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: isMobile ? 27 : 34,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF102A43),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'اختر الشكل الأقرب لما تحتاجه.',
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF6B8093),
            ),
          ),
          const SizedBox(height: 26),
          ...options.map((option) {
            final bool isSelected = selectedShape == option.title;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () {
                  setState(() {
                    selectedShape = option.title;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFEAF3FF)
                        : const Color(0xFFF9FBFD),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1565C0)
                          : const Color(0xFFDDE6F1),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF1565C0)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          option.icon,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF1565C0),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              option.title,
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF183B56),
                              ),
                            ),
                            if (option.subtitle != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                option.subtitle!,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.right,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF6B8093),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onBack,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'رجوع',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _goNext,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    backgroundColor: const Color(0xFF1565C0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'التالي',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ShapeOption {
  final String title;
  final String? subtitle;
  final IconData icon;

  const _ShapeOption({
    required this.title,
    this.subtitle,
    required this.icon,
  });
}